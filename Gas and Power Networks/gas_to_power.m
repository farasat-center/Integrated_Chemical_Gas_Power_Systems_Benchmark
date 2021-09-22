function [p_gen ,success_gaspower] = gas_to_power(load)
% This function converts gas loads resulted from gas network simulation to
% power generator inputs using quadratic heat curve of gas-fired generators
% q(p) = q_0 + q_1*p + q_2*p^2 where q_0, q_1, and q_2 are generator
% coefficients
% Various user-defined gas flow distribution to unit generators of a power
% plant can be implemented in this function
 
%% Gas mass flux of gas power generators
J8 = load(:,1);   
J13 = load(:,2);
J19 = load(:,3);
J24 = load(:,4);

%%
 p_gen = zeros(size(J8,1),5);
 success_gaspower=p_gen;
 
%%   Bus 22- GEN=1  
  
for i=1:size(J8,1)
coeff= [0.001 0.48 (3.08-(J8(i,1)/6))];
delta=(coeff(2)^2)-4*coeff(1)*coeff(3);
if (delta<0)
    success_gaspower(i,1)=-1;

    
elseif(coeff(1)*coeff(3)>0 && (-coeff(2)/coeff(1))<0  )      
    success_gaspower(i,1)=-1;

else
r=roots(coeff);
p_gen(i,1)=r(find(r>=0),1);
success_gaspower(i,1)=1;

end
if (p_gen(i,1)<1.6667)
    p_gen(i,1)=0;
end
end


%% Bus 15- GEN2   For 5 generator units that have the same capacities
for i=1:size(J8,1)
coeff= [0.001 0.48 (3.08-(J13(i,1)/10.31))];
delta=(coeff(2)^2)-4*coeff(1)*coeff(3);
if (delta<0)
    success_gaspower(i,2)=-1;

elseif(coeff(1)*coeff(3)>0 && (-coeff(2)/coeff(1))<0  )      
    success_gaspower(i,2)=-1;

else
r=roots(coeff);
p_gen(i,2)=r(find(r>=0),1);
if (p_gen(i,2)<0.48 || p_gen(i,2)>9.6)
   p_gen(i,2)=0; 
end
success_gaspower(i,2)=1;

end

end

%% Bus 15- GEN2   For a generator unit that has a different capacity than the others
for i=1:size(J8,1)
coeff= [0.001 0.48 (3.08-(J13(i,1)*0.515))];
delta=(coeff(2)^2)-4*coeff(1)*coeff(3);
if (delta<0)
    success_gaspower(i,3)=-1;

    
elseif(coeff(1)*coeff(3)>0 && (-coeff(2)/coeff(1))<0  )     
    success_gaspower(i,3)=-1;

else
r=roots(coeff);
p_gen(i,3)=r(find(r>=0),1);
if (p_gen(i,3)<54.3 )
   p_gen(i,3)=0; 
end
success_gaspower(i,3)=1;

end

end
%% Bus13- GEN3    
for i=1:size(J8,1)
coeff=[0.0015  0.26  (7.83-(J24(i,1)/3))];
delta=(coeff(2)^2)-4*coeff(1)*coeff(3);
if (delta<0)
    success_gaspower(i,4)=-1;

    
elseif(coeff(1)*coeff(3)>0 && (-coeff(2)/coeff(1))<0  )      
    success_gaspower(i,4)=-1;

else
r=roots(coeff);
p_gen(i,4)=r(find(r>=0),1);
success_gaspower(i,4)=1;

end
if (p_gen(i,4)<23)
    p_gen(i,4)=0;
end
end

%% Bus7-GEN=4
for i=1:size(J8,1)
coeff=[0.0015  0.26  (7.83-(J19(i,1)/3))];
delta=(coeff(2)^2)-4*coeff(1)*coeff(3);
if (delta<0)
    success_gaspower(i,5)=-1;
%     break;
    
elseif(coeff(1)*coeff(3)>0 && (-coeff(2)/coeff(1))<0  )      
    success_gaspower(i,5)=-1;

else
r=roots(coeff);
p_gen(i,5)=r(find(r>=0),1);
success_gaspower(i,5)=1;

end
if (p_gen(i,5)<8.3333)
    p_gen(i,5)=0;
end
end


 end

