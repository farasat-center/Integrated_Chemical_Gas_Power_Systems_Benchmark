function [sim_power, load_shedding, power_network_success] = power_network(gen_power, t_power)
% This function simulates power network using power generation inputs
%% initialize

sim_power=zeros(50,size(t_power,1));
load_shedding=zeros(17,size(t_power,1));
power_network_success=t_power;
index_load=[5;10;11;12;13;14;18;19;20;21;25;26;34;36;38;39;40];
index_gen=[1;2;3;4;6;7;8;9;15;16;17;22;23;24;27;28;29;30;31;32;33;35;37;41;42;43;44;45;46;47;48;49;50];

nominal_demand=zeros(17,1);

results_struc = modefied_ieee(ieee_24_benchmark,1,1);
  results_struc_f= results_struc;
for j=1:size(index_load,1)
   nominal_demand(j,1)=results_struc.gen(index_load(j),2); 
    
end
    
%% sim 

   
  for   i=1:size(t_power,1)

%% implementation of signal pattern considering user preference
   % To define a scenario on power loads, users may call modefied_ieee
    % function here, e.g. if users desire to increase power loads A 
    % to 25% between time intervals 6-8 hr and 18-20 hr, the following
    % piece of codes may be used.
    %     if(t_power(i)>=6 && t_power(i)<=8)
    %         results_struc = modefied_ieee(ieee_24_benchmark,1.25,1);
    %     end
    %     if(t_power(i)>=18 && t_power(i)<=20)
    %         results_struc = modefied_ieee(ieee_24_benchmark,1.25,1);
    %     end



%% Gas to power
if(gen_power(i,5)==0)
    results_struc.gen(15:17,9)=0;
    results_struc.gen(15:17,10)=0;
    results_struc.gen(15:17,4)=0;
    results_struc.gen(15:17,5)=0;
end
   results_struc.gen(15,2)=gen_power(i,5);
   results_struc.gen(16,2)=gen_power(i,5);
   results_struc.gen(17,2)=gen_power(i,5);
   if(gen_power(i,4)==0)
    results_struc.gen(22:24,9)=0;
    results_struc.gen(22:24,10)=0;
    results_struc.gen(22:24,4)=0;
    results_struc.gen(22:24,5)=0;
   end
   results_struc.gen(22,2)=gen_power(i,4);
   results_struc.gen(23,2)=gen_power(i,4);
   results_struc.gen(24,2)=gen_power(i,4);
   if (gen_power(i,2)==0)
        results_struc.gen(28:32,9)=0;
        results_struc.gen(28:32,10)=0;
        results_struc.gen(28:32,5)=0;
        results_struc.gen(28:32,4)=0;
        
   end
   results_struc.gen(28,2)=gen_power(i,2);
   results_struc.gen(29,2)=gen_power(i,2);
   results_struc.gen(30,2)=gen_power(i,2);
   results_struc.gen(31,2)=gen_power(i,2);
   results_struc.gen(32,2)=gen_power(i,2);
   if( gen_power(i,3)==0)
      results_struc.gen(33,9)=0;
      results_struc.gen(33,10)=0;
      results_struc.gen(33,4)=0;
      results_struc.gen(33,5)=0;
   end
   results_struc.gen(33,2)=gen_power(i,3);
   if (gen_power(i,1)==0)
      results_struc.gen(42:47,9)=0;
      results_struc.gen(42:47,10)=0;
      results_struc.gen(42:47,4)=0;
      results_struc.gen(42:47,5)=0;
   end
   results_struc.gen(42,2)=gen_power(i,1);
   results_struc.gen(43,2)=gen_power(i,1);
   results_struc.gen(44,2)=gen_power(i,1);
   results_struc.gen(45,2)=gen_power(i,1);
   results_struc.gen(46,2)=gen_power(i,1);
   results_struc.gen(47,2)=gen_power(i,1);
   
   %% total_Generation
   total_Generation=0;
   for j=1:size(index_gen,1) 
       total_Generation= total_Generation+results_struc.gen(index_gen(j),2);
   end
 
  %% total_load 
  total_load=0;
  for j=1:size(index_load,1)
      total_load=total_load+results_struc.gen(index_load(j),2);
  end
   
 %% checking && simulation
    if ( total_Generation>abs(total_load))
       
        power_network_success(i)=-1;
        
        t_power(i)
   elseif(results_struc.gen(1:50,2)>results_struc.gen(1:50,9))
        power_network_success(i)=-1;
          
   elseif( results_struc.gen(1:50,2)<results_struc.gen(1:50,10) )
       
        power_network_success(i)=-1;
    else
       
    %% pmin=pg   
    for j=1:size(index_gen,1) 
         results_struc.gen(index_gen(j),10)= results_struc.gen(index_gen(j),2);
    end
     
  
%%   pmax=pg
  
  for j=1:size(index_gen,1) 
         results_struc.gen(index_gen(j),9)= results_struc.gen(index_gen(j),2);
   end
      
       
  results_n=runopf(results_struc); 
     
     %% load shedding
  
     for j=1:size(index_load,1)
         
       load_shedding(j,i)=results_n.gen( index_load(j),2)-results_n.gen(index_load(j),10); 
    end

    power_network_success(i)=1; 
     
    results_struc=results_struc_f;   

    end
 
    
 
  end
end

