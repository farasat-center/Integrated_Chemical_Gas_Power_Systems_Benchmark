function Cp = heat_capacity(T)
% This function calculates heat capacity of pure components using
% temperature
a = [3.8387e1 1.90223e1 2.90063e1 1.76386e1 3.40471e1 2.94119e1]; %CH4 CO2 CO H2 H20 N2
b = [-7.36639e-2 7.96291e-2 2.49235e-3 6.70055e-2 -9.65064e-3 -3.00681e-3];
c = [2.90981e-4 7.37067e-5 -1.8644e-5 -1.31485e-4 3.29983e-5 5.45064e-6];
d = [-2.63849e-7 3.74572e-8 4.79892e-8 1.05883e-7 -2.04467e-8 5.13186e-9];
e = [8.00679e-11 -8.13304e-12 -2.87266e-11 -2.91803e-11 4.30228e-12 -4.25308e-12];

Cp = (a+b*T+c*T^2+d*T^3+e*T^4)*1000;

end