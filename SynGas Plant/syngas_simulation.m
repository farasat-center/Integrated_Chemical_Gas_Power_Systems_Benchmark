function [t, x] = syngas_simulation(inletdata)
% This function simulates the syngas plant equations
inputdata = load('syngasinputdata');
N = inputdata.N;
x_methane = zeros(N,1)';
x_cdo = zeros(N,1)';
T = ones(N,1)';
%-----------Setting inlet condition
t = inletdata(:,1);
phi_nominal = inletdata(:,2);
rho_delivery = inletdata(:,3);
%----------------------Filtering inlet data
m = size(t,1);
i = 2;
Tol = 1e-4;
while i<m
   if (t(i+1)-t(i))<Tol
      t(i) = [];
      phi_nominal(i) = [];
      rho_delivery(i) = [];
      m = m-1;
   end
   i = i+1;
end
%------------Setting operational conditions
% Users may change operational conditions based on their preferences here
F_S = 17.35; %kmol/hr
T_NG = 793.15; %K
T_S = 793.15; %K
Tw = 1073.78; %K
operational_cond = [F_S T_NG T_S Tw];
initial_cond = [x_methane,x_cdo,T];
inlet_cond = [t phi_nominal rho_delivery];
tspan = [t(1) t(end)];
[t, x] = ode15s(@syngas_plant_equ,tspan,initial_cond,[],inlet_cond,inputdata,operational_cond);
