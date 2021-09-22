function [d_var] = syngas_plant_equ(tq,vars,input_cond,inputdata,operational_cond)
% This function contains syngas plant odes
N = inputdata.N;
L = inputdata.L; %m
d_tube_i = inputdata.d_tube_i; %m
d_particle_i = inputdata.d_particle_i; %m

dz = L/(N-1);
omega = pi/4*d_tube_i^2; %cross area
rhos = inputdata.rhos; %kg/m^3
Cps = inputdata.Cps; %J/kg.K
MW = inputdata.MW; %CH4 CO2 CO H2 H20 N2
R = inputdata.R; %bar.m^3/kmol.K
%------------------------------------------------
t_n = input_cond(:,1);
phi_n = input_cond(:,2);
rho_n = input_cond(:,3);
%------------------------------------------------
Area = inputdata.Area;
F_NG = pchip(t_n,phi_n,tq)*Area/16/400*3600;
x_NG_mass = ratio_func(pchip(t_n,rho_n,tq));
x_NG = x_NG_mass*(1/(x_NG_mass/16+(1-x_NG_mass)/44))/16;
F_CDO = F_NG/x_NG-F_NG;
%----------control input
F_S = operational_cond(1);%17.35;
T_NG = operational_cond(2);%793.15;
T_S = operational_cond(3);793.15;
Tw = operational_cond(4);%1073.78; %K
%--------------
T_z = mixer_syngas(F_NG,F_S,T_NG,T_S); %K
P_z = inputdata.P_z; %bar
F_in = [F_NG F_CDO 0 .63 F_S .85]';

%-------------------------------------------------
dh = inputdata.dh; %kJ/mol
us_z = sum(F_in)*R*T_z/omega/P_z/3600; %m/s
%-----------------------
x_methane = vars(1:N);
x_cdo = vars(N+1:2*N);
T = vars(2*N+1:3*N);
no = inputdata.no; %stoichiometric coeff
%---------------------
eb = .9198/(d_tube_i/d_particle_i)^2+.3414;
rhob = rhos*(1-eb);
%---------------------
dx_methane = zeros(N,1);
dx_cdo = zeros(N,1);
dT = zeros(N,1);
%---------------------
Pp = P_z;
%---------------------- partial pressure of components in reactor
ext_reaction(1) = F_in(1)*x_methane(1); %kisi1 = F_CH4*x_CH4
ext_reaction(2) = F_in(1)*x_cdo(1); %kisi2 = F_CH4*x_CO2
F_component = F_in + no*ext_reaction';
y = F_component'/sum(F_component);
Mm=sum(y.*MW);
rhog = Pp*Mm/R/T(1)/T_z;
us = us_z*sum(F_component)/sum(F_in)*P_z/Pp*T(1)*T_z/T_z;
[D_ax,~] = diffusion_coeff(Pp,T(1)*T_z,y,us);
D_ax = D_ax*1e-4; %converting cm^2/s to m^2/s
lambda_ax = axial_thermal_conductivity(Pp,T(1)*T_z,y,us);
Cp = sum(y.*heat_capacity(T(1)*T_z))/Mm;

%---------------------- boundary condition
x_methane(1) = eb*D_ax(1)/(us*dz+eb*D_ax(1))*x_methane(2); %@z=0
x_cdo(1) = eb*D_ax(2)/(us*dz+eb*D_ax(2))*x_cdo(2); %@z=0
x_methane(N) = x_methane(N-1); %@z=L
x_cdo(N) = x_cdo(N-1); %@z=L
T(1) = (1-(1-eb*lambda_ax/rhog/Cp/us/dz)*T(2))/(eb*lambda_ax/rhog/Cp/us/dz); %@z=0
T(N) = T(N-1); %@z=L
%--------------------- main loop
for i=2:N-1
    %---------------------- partial pressure of components in reactor
    ext_reaction(1) = F_in(1)*x_methane(i); %kisi1 = F_CH4*x_CH4
    ext_reaction(2) = F_in(1)*x_cdo(i); %kisi2 = F_CH4*x_CO2
    F_component = F_in + no*ext_reaction';
    y = F_component'/sum(F_component);
    Mm=sum(y.*MW);
    
    Pg = Pp;
    err = 1;
    while err > 1e-2
        rhog = Pg*Mm/R/T(i)/T_z;
        us = us_z*sum(F_component)/sum(F_in)*P_z/Pg*T(i)*T_z/T_z;
        a = 1.75; b = 150;
        Re = rhog*us*d_particle_i/mix_viscosity(T(i)*T_z,y)*1e7;
        f_friction = (1-eb)/eb^3*(a+(1-eb)*b/Re);
        P = Pp-dz*(f_friction*rhog*us^2/d_particle_i/9.8/1e5);
        err = abs(P - Pg);
        Pg = P;
    end
    Pp = P;
    p_partial = P*y;
    %---------------------- properties
    [D_ax,~] = diffusion_coeff(P,T(i)*T_z,y,us);
    D_ax = D_ax*1e-4; %converting cm^2/s to m^2/s
    lambda_ax = axial_thermal_conductivity(P,T(i)*T_z,y,us);
    
    Cp = sum(y.*heat_capacity(T(i)*T_z))/Mm;
    
    Nle = (rhog*Cp*eb+rhos*Cps*(1-eb))/rhog/Cp/eb;
    U = heat_transfer_coeff(P,T(i)*T_z,y,us);
    %----------------------
    rb = reaction_rate(p_partial,T(i)*T_z);
    etha = [.005;0;.005];
    %---------------------- LHS of reactor ode equations
    dx_methane(i) = us/eb*(-(x_methane(i)-x_methane(i-1))/dz+eb*D_ax(1)/us*(x_methane(i+1)-2*x_methane(i)+x_methane(i-1))/dz^2+omega*rhob/F_in(1)*(etha(1)*rb(1)+etha(3)*rb(3)));
    dx_cdo(i) = us/eb*(-(x_cdo(i)-x_cdo(i-1))/dz+eb*D_ax(2)/us*(x_cdo(i+1)-2*x_cdo(i)+x_cdo(i-1))/dz^2+omega*rhob/F_in(1)*(etha(2)*rb(2)+etha(3)*rb(3)));
    dT(i) = 1/(Nle*rhog*Cp*eb)*(-rhog*Cp*us*(T(i)-T(i-1))/dz+eb*lambda_ax*(T(i+1)-2*T(i)+T(i-1))/dz^2+10^6/3600*rhob*sum(etha.*rb.*(-dh))/T_z-4*U/d_tube_i*(T(i)-Tw/T_z));
end

d_var = [dx_methane;dx_cdo;dT];
end

