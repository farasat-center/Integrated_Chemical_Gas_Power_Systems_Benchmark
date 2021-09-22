function [D_ax,Deff_A] = diffusion_coeff(P,T,y,u)
% This function calculates mixture and axial diffusion coefficients using
% pressure, temperature, composition and velocity

k = 1.38064852*10^-23;
R = 8.314;
taw = 3.54;

d_tube_i = .1016; %m
d_particle_i = .0084; %m
eb = .9198/(d_tube_i/d_particle_i)^2+.3414;

ec = 2355.2*.2508/1000; %rhos*void vol/w cat
sigma = [3.758 3.941 3.69 2.827 2.641 3.798]; %CH4 CO2 CO H2 H20 N2
e = [148.6 195.2 91.7 59.7 809.1 71.4]*k; %CH4 CO2 CO H2 H20 N2
MW = [16.043 44.01 28.01 2.016 18.015 28.014]; %CH4 CO2 CO H2 H20 N2
A = 1.06036; B = .15610; C = .19300; D = .47635; E = 1.03587; F = 1.52996; G = 1.76474; H = 3.89411;
P_ref = 1; %bar
Pc = [45.99 73.74 34.94 12.97 220.64 33.98]; %bar
Tc = [190.56 304.12 132.85 33.25 647.14 126.2]; %K
index = size(y,2);
M_AB = zeros(index);
e_AB = M_AB;
sigma_AB = M_AB;
Dm_A = zeros(1,index);

for i=1:index
    for j=i:index
        M_AB(i,j) = 2*(1/MW(i)+1/MW(j))^(-1);
        e_AB(i,j) = (e(i)*e(j))^.5;
        sigma_AB(i,j) = (sigma(i)+sigma(j))/2;
        M_AB(j,i) = M_AB(i,j);
        sigma_AB(j,i) = sigma_AB(i,j);
        e_AB(j,i) = e_AB(i,j);
    end
end

T_star = k*T./e_AB;
omega_D = A./(T_star.^B)+C./exp(D*T_star)+E./exp(F*T_star)+G./exp(H*T_star);

%------------diff coeff for binary in low pressure
Dm_AB = .00266*T^1.5/P_ref./(M_AB.^.5)./(sigma_AB.^2)./omega_D; %cm^2/s
%-----------------Brakow correction
vb = [34.88 .001044*10^3*18.015]; %cm^3/mol CO H2O
Tb = [81.66 373.15]; %K
mu = [.1 1.8]; %debye
del = 1.94*10^3*mu.^2./(vb.*Tb);
sigma_modified = (1.585*vb./(1+1.3*del.^2)).^(1/3);
sigma = [3.758 3.941 sigma_modified(1) 2.827 sigma_modified(2) 3.798]; %CH4 CO2 CO H2 H20 N2
e_modified = 1.18*(1+1.3*del.^2).*Tb;
e = [148.6 195.2 e_modified(1) 59.7 e_modified(2) 71.4]*k; %CH4 CO2 CO H2 H20 N2
del = [0 0 del(1) 0 del(2) 0];
e_AB = (e'*e).^.5;
sigma_AB = (sigma'*sigma).^.5;
delta_AB = (del'*del).^.5;

T_star = k*T./e_AB;
omega_D = A./(T_star.^B)+C./exp(D*T_star)+E./exp(F*T_star)+G./exp(H*T_star);
omega_D_modified = .19*delta_AB.^2./T_star;
omega_D = omega_D+omega_D_modified;
Dm_temp = .00266*T^1.5/P_ref./(M_AB.^.5)./(sigma_AB.^2)./omega_D; %cm^2/s
Dm_AB(3,:) = Dm_temp(3,:); %correction for CO
Dm_AB(:,3) = Dm_temp(:,3);
Dm_AB(5,:) = Dm_temp(5,:); %correction for H2O
Dm_AB(:,5) = Dm_temp(:,5);
%-------------mixture diff
temp = 0;
for i =1:index
    for j=1:index
        if i~=j
            temp = temp + y(j)/Dm_AB(i,j);
        end
    end
    Dm_A(i) = 1/temp;
    temp = 0;
end
%------------correction of diff coeff for high pressure used for mixture
Tc_m = sum(y.*Tc);
Pc_m = sum(y.*Pc);
Dm_A = Dm_A*P_ref/P;%*correction_factor(T,P,Tc_m,Pc_m);

%-------------knudsen diff coeff
d = [30 50 80 120 200 500 1000 10000 100000]*1e-10; %m
del_vg = [.004 .025 .0262 .0379 .0573 .0388 .019 .029 .0136]; %cm^3 of void/g of cat
Dk_A = zeros(index,size(d,2));
D_A = y;
D_temp = Dk_A;
%-----------------------------------
for i =1:index
    Dk_A(i,:) = d/3*(8*R*T/pi/MW(i)*1000)^.5*10^4; %knudsen diff coeff cm^2/s
    D_temp(i,:) = (1/Dm_A(i)+1./Dk_A(i,:)).^(-1); %total diff coeff based on diameter cm^2/s
    D_A(i) = D_temp(i,:)*del_vg'/sum(del_vg); %overall diff coeff
end
%--------------effective and axial diff coeff
a = 0.78;
b = 0.54;
c = 9.2;

Deff_A = ec/taw*D_A; %effective diff coeff
D_ax = a*Dm_A + b*u*d_particle_i/eb./(1+c*Dm_A/u/d_particle_i*eb); %axial diff coeff
%--------------------------------------------------------------------------
end
