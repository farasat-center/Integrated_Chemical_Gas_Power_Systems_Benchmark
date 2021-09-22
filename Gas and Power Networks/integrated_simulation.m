clc
clear all
%% gas network
data = load('input_data');
a = data.a;
p_0 = data.p_0;
l=data.l;
[t,x]= gas_network;
%% gas to power
load = zeros(size(t,1),4);
load(:,1) = x(:,73);
load(:,2) = x(:,83);
load(:,3) = x(:,97);
load(:,4) = x(:,107);
load = load*p_0/a;
[p_gen ,success_gaspower] = gas_to_power(load);
%% power  network
t_power=t/3600/a*l*1000;
[sim_power,load_shedding, power_network_success] = power_network(p_gen,t_power);
%% syngas plant
% To simulate syngas plant, add the path where syngas plant equations are
% located such as: addpath ~/SynGas Plant
inlet_data = zeros(size(t,1),3);
inlet_data(:,1) = t/a*1e4;
inlet_data(:,2) = x(:,71)*p_0/a;
inlet_data(:,3) = x(:,17)*p_0/a^2;
[t_syngas, output_syngas] = syngas_simulation(inlet_data); 
% Results include distribution of dimensionless temperature as well
% as methane and carbon dioxide conversions along reactor length


