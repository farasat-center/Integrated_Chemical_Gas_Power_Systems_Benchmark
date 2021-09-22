function etha = viscosity(T)
% This function calculates viscosity of pure components using temperature
MW = [16.043 44.01 28.01 2.016 18.015 28.014]; %CH4 CO2 CO H2 H20 N2
Pc = [45.99 73.74 34.94 12.97 220.64 33.98]; %bar
Tc = [190.56 304.12 132.85 33.25 647.14 126.2]; %K
Zc = [.286 .274 .292 .305 .229 .289];
mu = [0 0 .1 0 1.8 0];
Tr = T./Tc;
index = size(MW,2);

kisi = .176*((Tc./MW.^3)./Pc.^4).^(1/6);
etha = kisi;
mu_r = 52.46*mu.^2.*Pc./Tc.^2;
Q_hydrogen = .76;
FQ_z_hydrogen = 1.22*Q_hydrogen^.15*(1+.00385*((Tr(4)-12)^2)^(1/MW(4))*sign(Tr(4)-12));
FQ_z = [1 1 1 FQ_z_hydrogen 1 1];

for i=1:index
    if mu_r(i)>=0 && mu_r(i)<.022
        FP_z = 1;
    elseif mu_r(i)>=.022 && mu_r(i)<.075
        FP_z = 1+30.55*(.292-Zc(i))^1.72;
    else
        FP_z = 1+30.55*(.292-Zc(i))^1.72*abs(.96+.1*(Tr(i)-.7));
    end    
    f = (.807*Tr(i)^.618-.357*exp(-.449*Tr(i))+.34*exp(-4.058*Tr(i))+.018)*FP_z*FQ_z(i);
    etha(i) = f/kisi(i); %muP
end

end