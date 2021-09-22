 function results_struc = modefied_ieee(ieee_24_benchmark,b_multiplier,a_multiplier)
%% scale coefficients of max power capacity of generators and loads 
c=0.8;                         %% scale coefficients of max power capacity of generators
b=0.8*b_multiplier;            %% scale coefficients of variable loads A,B
a=0.5*a_multiplier;            %% scale coefficients of constant loads 

%%
mpc=loadcase(ieee_24_benchmark);
results=loadcase(ieee_24_benchmark);
%% max power capacity of generator o.8 (active power)
results.gen(1:4,9)=mpc.gen(1:4,9)*c;
results.gen(6:9,9)=mpc.gen(6:9,9)*c;
results.gen(15:17,9)=mpc.gen(15:17,9)*c;
results.gen(22:24,9)=mpc.gen(22:24,9)*c;
results.gen(27:33,9)=mpc.gen(27:33,9)*c;
results.gen(35,9)=mpc.gen(35,9)*c;
results.gen(37,9)=mpc.gen(37,9)*c;
results.gen(41:50,9)=mpc.gen(41:50,9)*c;
%% max power capacity of generator o.8 (reactive)
results.gen(1:4,4)=mpc.gen(1:4,4)*c;
results.gen(6:9,4)=mpc.gen(6:9,4)*c;
results.gen(15:17,4)=mpc.gen(15:17,4)*c;
results.gen(22:24,4)=mpc.gen(22:24,4)*c;
results.gen(27:33,4)=mpc.gen(27:33,4)*c;
results.gen(35,4)=mpc.gen(35,4)*c;
results.gen(37,4)=mpc.gen(37,4)*c;
results.gen(41:50,4)=mpc.gen(41:50,4)*c;
%% min power capacity of generator (number of unit)
results.gen(1:2,10)=(1/2)*mpc.gen(1:2,10);
results.gen(3:4,10)=(1/2)*mpc.gen(3:4,10);
results.gen(1:2,5)=(1/2)*mpc.gen(1:2,5);
results.gen(3:4,5)=(1/2)*mpc.gen(3:4,5);
results.gen(6:7,10)=(1/2)*mpc.gen(6:7,10);
results.gen(8:9,10)=(1/2)*mpc.gen(8:9,10);
results.gen(6:7,5)=(1/2)*mpc.gen(6:7,5);
results.gen(8:9,5)=(1/2)*mpc.gen(8:9,5);
results.gen(15:17,10)=(1/3)*mpc.gen(15:17,10);
results.gen(15:17,5)=(1/3)*mpc.gen(15:17,5);
results.gen(22:24,10)=(1/3)*mpc.gen(22:24,10);
results.gen(22:24,5)=(1/3)*mpc.gen(22:24,5);
results.gen(27,10)=(1)*mpc.gen(27,10);
results.gen(27,5)=(1)*mpc.gen(27,5);
results.gen(28:32,10)=(1/5)*mpc.gen(28:32,10);
results.gen(28:32,5)=(1/5)*mpc.gen(28:32,5);
results.gen(35,10)=(1)*mpc.gen(35,10);
results.gen(35,5)=(1)*mpc.gen(35,5);
results.gen(37,10)=(1)*mpc.gen(37,10);
results.gen(37,5)=(1)*mpc.gen(37,5);
results.gen(41,10)=(1)*mpc.gen(41,10);
results.gen(41,5)=(1)*mpc.gen(41,5);
results.gen(42:47,10)=(1/6)*mpc.gen(42:47,10);
results.gen(42:47,5)=(1/6)*mpc.gen(42:47,5);
results.gen(48:49,10)=(1/2)*mpc.gen(48:49,10);
results.gen(48:49,5)=(1/2)*mpc.gen(48:49,5);
%% gencost of gas generators
results.gencost(15:17,7)=240.8806;
results.gencost(15:17,6)=7.9986;
results.gencost(15:17,5)=0.0461;
results.gencost(22:24,7)=499.5703;
results.gencost(22:24,6)=16.5885;
results.gencost(22:24,5)=0.0957;
results.gencost(28:33,7)=94.7525;
results.gencost(28:33,6)=14.7666;
results.gencost(28:33,5)=0.0308;
results.gencost(42:47,7)=94.7525;
results.gencost(42:47,6)=14.7666;
results.gencost(42:47,5)=0.0308;
%% Negetive Generators (Active power)
results.gen(5,2)=b*mpc.gen(5,2);
results.gen(10:13,2)=b*mpc.gen(10:13,2);
results.gen(14,2)=a*mpc.gen(14,2);
results.gen(18:19,2)=b*mpc.gen(18:19,2);
results.gen(20:21,2)=a*mpc.gen(20:21,2);
results.gen(25,2)=b*mpc.gen(25,2);
results.gen(26,2)=a*mpc.gen(26,2);
results.gen(34,2)=a*mpc.gen(34,2);
results.gen(36,2)=b*mpc.gen(36,2);
results.gen(38:40,2)=a*mpc.gen(38:40,2);

%% Negetive Generator(Reactive power)
results.gen(5,3)=b*mpc.gen(5,3);
results.gen(10:13,3)=b*mpc.gen(10:13,3);
results.gen(14,3)=a*mpc.gen(14,3);
results.gen(18:19,3)=b*mpc.gen(18:19,3);
results.gen(20:21,3)=a*mpc.gen(20:21,3);
results.gen(25,3)=b*mpc.gen(25,3);
results.gen(26,3)=a*mpc.gen(26,3);
results.gen(34,3)=a*mpc.gen(34,3);
results.gen(36,3)=b*mpc.gen(36,3);
results.gen(38:40,3)=a*mpc.gen(38:40,3);

%% Negetive Generator (Min reactive power capacity)
results.gen(5,5)=b*mpc.gen(5,5);
results.gen(10:13,5)=b*mpc.gen(10:13,5);
results.gen(14,5)=a*mpc.gen(14,5);
results.gen(18:19,5)=b*mpc.gen(18:19,5);
results.gen(20:21,5)=a*mpc.gen(20:21,5);
results.gen(25,5)=b*mpc.gen(25,5);
results.gen(26,5)=a*mpc.gen(26,5);
results.gen(34,5)=a*mpc.gen(34,5);
results.gen(36,5)=b*mpc.gen(36,5);
results.gen(38:40,5)=a*mpc.gen(38:40,5);
%% Negetive Generator (Min active power capacity)
results.gen(5,10)=b*mpc.gen(5,10);
results.gen(10:13,10)=b*mpc.gen(10:13,10);
results.gen(14,10)=a*mpc.gen(14,10);
results.gen(18:19,10)=b*mpc.gen(18:19,10);
results.gen(20:21,10)=a*mpc.gen(20:21,10);
results.gen(25,10)=b*mpc.gen(25,10);
results.gen(26,10)=a*mpc.gen(26,10);
results.gen(34,10)=a*mpc.gen(34,10);
results.gen(36,10)=b*mpc.gen(36,10);
results.gen(38:40,10)=a*mpc.gen(38:40,10);
%%
results.branch(:,6)=0.8*mpc.branch(:,6);
results_struc =results;

end

