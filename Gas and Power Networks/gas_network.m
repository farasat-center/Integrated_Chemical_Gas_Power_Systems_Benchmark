function [t,x] = gas_network
% This function simulates gas network using input data which is provided in
% the input_data.mat
data = load('input_data');
open_system('gas_model');
%-----------------settings
simulink_setting(data)
%-------------------------
nominal_demand = data.nominal_demand;
%------------------------------------
% Users may vary gas demands using variables factor and step_time defined
% below. More complex pattern is also possible to acheive
step_time = data.step_time;
factor = data.factor;
demand = nominal_demand.*factor;
set_param('gas_model/N17','Time',num2str(step_time(1)),'Before',num2str(nominal_demand(1)),'After',num2str(demand(1)));
set_param('gas_model/N28','Time',num2str(step_time(3)),'Before',num2str(nominal_demand(3)),'After',num2str(demand(3)));
set_param('gas_model/N42','Time',num2str(step_time(5)),'Before',num2str(nominal_demand(5)),'After',num2str(demand(5)));
set_param('gas_model/N54','Time',num2str(step_time(8)),'Before',num2str(nominal_demand(8)),'After',num2str(demand(8)));

set_param('gas_model/Subsystem/S-Function','Parameters','data');

[t,x] = sim('gas_model');


