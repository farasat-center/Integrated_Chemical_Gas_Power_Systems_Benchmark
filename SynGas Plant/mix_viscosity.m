function etha = mix_viscosity(T,y)
% This function calculates mixture viscosity using temperature and
% composition

R = .0831;
MW = [16.043 44.01 28.01 2.016 18.015 28.014]; %CH4 CO2 CO H2 H20 N2
Pc = [45.99 73.74 34.94 12.97 220.64 33.98]; %bar
Tc = [190.56 304.12 132.85 33.25 647.14 126.2]; %K
Vc = [98.6 94.07 93.1 65 55.95 90.1]/1000;%R*Zc.*Tc./Pc/1000;
Zc = Pc.*Vc./Tc/R;%[.286 .274 .292 .305 .229 .289];
mu = [0 0 .1 0 1.8 0];
%-------------------------Lucas Rules
Tcm = sum(y.*Tc);
Pcm = R*Tcm*sum(y.*Zc)/sum(y.*Vc);
Mm = sum(y.*MW);
A = 1;
if max(y)>.05 && max(y)<.7
    A = 1-.01*(max(MW)/min(MW))^.87;
end

Q_hydrogen = .76;
FQ_z_hydrogen = 1.22*Q_hydrogen^.15*(1+.00385*((T/Tc(4)-12)^2)^(1/MW(4))*sign(T/Tc(4)-12));
FQ_z = [1 1 1 FQ_z_hydrogen 1 1];
FQm_z = sum(y.*FQ_z)*A;
FP_z = FQ_z;
mu_r = 52.46*mu.^2.*Pc./Tc.^2;

for i=1:size(MW,2)
    if mu_r(i)>=0 && mu_r(i)<.022
        FP_z(i) = 1;
    elseif mu_r(i)>=.022 && mu_r(i)<.075
        FP_z(i) = 1+30.55*(.292-Zc(i))^1.72;
    else
        FP_z(i) = 1+30.55*(.292-Zc(i))^1.72*abs(.96+.1*(T/Tc(i)-.7));
    end
end
FPm_z = sum(y.*FP_z);

Trm = T/Tcm;

kisi = .176*(Tcm/Mm^3/Pcm^4)^(1/6);

f = (.807*Trm^.618-.357*exp(-.449*Trm)+.34*exp(-4.058*Trm)+.018)*FPm_z*FQm_z;
etha = f/kisi; %muP

end