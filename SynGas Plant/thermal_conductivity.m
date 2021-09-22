function lambda_g = thermal_conductivity(T)
% This function calculates thermal conductivity of pure components using
% temperature
MW = [16.043 44.01 28.01 2.016 18.015 28.014]/1000; %CH4 CO2 CO H2 H20 N2
Tc = [190.56 304.12 132.85 33.25 647.14 126.2]; %K
w = [.011 .225 .045 -.216 .344 .037];
R = 8.314;
Tr = T./Tc;

etha = viscosity(T)*10^-7;
Cv = heat_capacity(T)/1000-R;
alpha = Cv/R-3/2;
beta = .7862-.7109*w+1.3168*w.^2;
beta(3) = 1/1.32; %polar gas modification
beta(5) = beta(3); %polar gas modification
Z = 2+10.5*Tr.^2;
si = 1+alpha.*(.215+.28288*alpha-1.061*beta+.26665*Z)./(.6366+beta.*Z+1.061*alpha.*beta);
lambda_g = 3.75*R*etha.*si./MW;

end
