function lambda_ax = axial_thermal_conductivity(P,T,y,u)
% This function calculates axial thermal conductivity of stream in the
% reactor using pressure, temperature, composition and velocity

lambda_s = .3489; %W/m.K
delta = .75;
d_tube_i = .1016; %m
d_particle_i = .0084; %m
eb = .9198/(d_tube_i/d_particle_i)^2+.3414;
R = .0831;
MW = [16.043 44.01 28.01 2.016 18.015 28.014]; %CH4 CO2 CO H2 H20 N2

Mm = sum(y.*MW);
mu_m = mix_viscosity(T,y)*1e-7;
Cpm = sum(y.*heat_capacity(T))/Mm;
lambda_gm = mix_thermal_conductivity(T,y);
rho_m = P*Mm/R/T;
Pr = mu_m*Cpm/lambda_gm;
Re = rho_m*u*d_particle_i/mu_m;

lambda_ratio = eb+(1-eb)/(.139*eb-.0339+2*lambda_gm/lambda_s/3);
lambda_ax = lambda_gm*(lambda_ratio+delta*Re*Pr);

end