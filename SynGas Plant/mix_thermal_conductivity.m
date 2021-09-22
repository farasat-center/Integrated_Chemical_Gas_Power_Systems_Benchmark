function lambda_gm = mix_thermal_conductivity(T,y)
% This function calculates mixture thermal conductivity using temperature
% and composition

MW = [16.043 44.01 28.01 2.016 18.015 28.014]; %CH4 CO2 CO H2 H20 N2
Pc = [45.99 73.74 34.94 12.97 220.64 33.98]; %bar
Tc = [190.56 304.12 132.85 33.25 647.14 126.2]; %K
gamma = 210*(Tc.*MW.^3./Pc.^4).^(1/6);
Tr = T./Tc;
index = size(y,2);
lambda_gA = thermal_conductivity(T);

A = zeros(index);
for i=1:index
    for j=1:index
        lambda_tr_ratio = gamma(j)/gamma(i)*(exp(.0464*Tr(i))-exp(-.2412*Tr(i)))/(exp(.0464*Tr(i))-exp(-.2412*Tr(i)));
        A(i,j) = (1+lambda_tr_ratio^.5*(MW(i)/MW(j))^.25)^2/(8*(1+MW(i)/MW(j)))^.5;
    end
end

lambda_g = y;
for i =1:index
    lambda_g(i) = y(i)*lambda_gA(i)/sum(y.*A(i,:));
end
lambda_gm = sum(lambda_g);

end