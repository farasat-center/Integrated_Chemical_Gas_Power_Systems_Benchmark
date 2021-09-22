function r = reaction_rate(p,T)
% This function claculates rates of reaction occuring in the reactor

R = 8.314/1000;
A = [4.225e15;1.955e6;1.02e15];
AK = [4.707e12;1.142e-2;5.375e10];
AKK = [6.65e-4;0;8.23e-5;6.12e-9;1.77e5;0]; %CH4 CO2 CO H2 H2O N2
E = [240.1;67.13;243.9];
dh = [206.1;-41.15;164.9];
dhKK = [-38.28;0;-70.65;-82.9;88.68;0];
k = A.*exp(-E/R/T);
K = AK.*exp(-dh/R/T);
KK = AKK.*exp(-dhKK/R/T);
den = 1+KK(3)*p(3)+KK(4)*p(4)+KK(1)*p(1)+KK(5)*p(5)/p(4);

r(1) = k(1)/p(4)^2.5*(p(1)*p(5)-p(4)^3*p(3)/K(1))/den^2;
r(2) = k(2)/p(4)*(p(3)*p(5)-p(4)*p(2)/K(2))/den^2;
r(3) = k(3)/p(4)^3.5*(p(1)*p(5)^2-p(4)^4*p(2)/K(3))/den^2;
r = r';
end