function U = heat_transfer_coeff(P,T,y,u)
% This function calculates overall heat transfer coefficient using pressure,
% temperature, composition and velocity
d_tube_i = .1016; %m
d_tube_o = .1322; %m
d_particle_i = .0084; %m
em = .8;
lambda_s = .3489; %W/m.K
MW = [16.043 44.01 28.01 2.016 18.015 28.014]; %CH4 CO2 CO H2 H20 N2
R = .0831;

eb = .9198/(d_tube_i/d_particle_i)^2+.3414;
a_ru = .8171*(T/100)^3/(1+eb/2/(1-eb)*(1-em)/em);
a_rs = .8171*em/(2-em)*(T/100)^3;
lambda_gm = mix_thermal_conductivity(T,y);
Mm = sum(y.*MW);
mu_m = mix_viscosity(T,y)*10^-7;
Cpm = sum(y.*heat_capacity(T))/Mm;
rho_m = P*Mm/R/T;
Pr = mu_m*Cpm/lambda_gm;
Re = rho_m*u*d_particle_i/mu_m;

lambda_erz = eb*(lambda_gm+.95*a_ru*d_particle_i)+.95*(1-eb)/(2/3/lambda_s+1/(10*lambda_gm+a_rs*d_particle_i));
lambda_er = lambda_erz+.111*lambda_gm*Re*Pr^(1/3)/(1+46*(d_particle_i/d_tube_o)^2);
aw = (1-1.5*(d_tube_i/d_particle_i)^-1.5)*lambda_gm/d_particle_i*Re^.59*Pr^(1/3);

Bi = aw*d_tube_o/2/lambda_er;
U = (1/aw+d_tube_o/6/lambda_er*(Bi+3)/(Bi+4))^-1;

end