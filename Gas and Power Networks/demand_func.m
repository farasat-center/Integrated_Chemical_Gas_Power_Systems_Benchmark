function d = demand_func(inputdata,rho,u)
% In this function set of desired values of gas demands is set
demand_index = [17,19,28,29,42,43,53,54];
d = zeros(size(rho,1),1);
cv = inputdata.cv;
Area = inputdata.Area;
p_0 = inputdata.p_0;
p_spec = inputdata.p_spec;
a = inputdata.a;

for i = 1:8
    if rho(demand_index(i))*p_0-p_spec(i)<=0
        d(demand_index(i)) = 0;
    else
        d(demand_index(i)) = u(i)*63.338*cv(i)*((rho(demand_index(i))*p_0*14.5/1e5-p_spec(i)*14.5/1e5)*rho(demand_index(i))*p_0/a^2/3.28^3/.45)^.5*.45/3600/Area(i)*a/p_0;
    end
end
end

