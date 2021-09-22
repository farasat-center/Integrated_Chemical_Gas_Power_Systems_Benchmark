function simulink_setting(data)

kc = data.kc;
inv_tawi = data.inv_tawi;

set_param('gas_model/Subsystem/C_N17','P',num2str(kc(1)),'I',num2str(inv_tawi(1)));
set_param('gas_model/Subsystem/C_N19','P',num2str(kc(2)),'I',num2str(inv_tawi(2)));
set_param('gas_model/Subsystem/C_N28','P',num2str(kc(3)),'I',num2str(inv_tawi(3)));
set_param('gas_model/Subsystem/C_N29','P',num2str(kc(4)),'I',num2str(inv_tawi(4)));
set_param('gas_model/Subsystem/C_N42','P',num2str(kc(5)),'I',num2str(inv_tawi(5)));
set_param('gas_model/Subsystem/C_N43','P',num2str(kc(6)),'I',num2str(inv_tawi(6)));
set_param('gas_model/Subsystem/C_N53','P',num2str(kc(7)),'I',num2str(inv_tawi(7)));
set_param('gas_model/Subsystem/C_N54','P',num2str(kc(8)),'I',num2str(inv_tawi(8)));
%-----------------initial condition
init_cont  = data.init_cont;
set_param('gas_model/Subsystem/C_N17','InitialConditionForIntegrator',num2str(init_cont(1)));
set_param('gas_model/Subsystem/C_N19','InitialConditionForIntegrator',num2str(init_cont(2)));
set_param('gas_model/Subsystem/C_N28','InitialConditionForIntegrator',num2str(init_cont(3)));
set_param('gas_model/Subsystem/C_N29','InitialConditionForIntegrator',num2str(init_cont(4)));
set_param('gas_model/Subsystem/C_N42','InitialConditionForIntegrator',num2str(init_cont(5)));
set_param('gas_model/Subsystem/C_N43','InitialConditionForIntegrator',num2str(init_cont(6)));
set_param('gas_model/Subsystem/C_N53','InitialConditionForIntegrator',num2str(init_cont(7)));
set_param('gas_model/Subsystem/C_N54','InitialConditionForIntegrator',num2str(init_cont(8)));
end

