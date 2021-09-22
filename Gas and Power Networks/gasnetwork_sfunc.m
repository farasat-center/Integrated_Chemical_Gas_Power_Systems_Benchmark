function [sys,x0,str,ts]=gasnetwork_sfunc(~,x,u,flag,data)
% In this function, ODE set governing gas network is set and solved with
% Simulink.
switch flag
    case 0    %initialization
        str = [];
        ts = [0 0];
        s = simsizes;
        s.NumContStates = 108;
        s.NumDiscStates = 0;
        s.NumOutputs = 8;
        s.NumInputs = 8;
        s.DirFeedthrough = 0;
        s.NumSampleTimes = 1;
        sys = simsizes(s);
        x0 = data.init_cond;
		
    case 1       
		l = data.NDC; %nondimensionalization const. km
        landa_f = data.landa_f; %friction coeff.
        
		Bij = sparse(data.B);
        Landa = eye(size(data.B,1)).*data.length/l;
        K = l*10^3*landa_f*eye(size(data.B,1))./data.di;
        %------
        a = data.a; %sonic velocity m/s
        p_0 = data.p_0; %Pa
        p_spec = data.p_spec;
        s = data.s; %p=a^2*rho
        d_s = data.d_s;
        %--------------------------		
        alpha = -data.alpha;
        Bij(1,1) = alpha(1);
        Bij(20,11) = alpha(2);
        Bij(14,14) = alpha(3);
        Bij(38,38) = alpha(4);
        Bij(48,48) = alpha(5);
        %--------------------------
        Bs = Bij(:,1)';
        Bd = Bij(:,2:end)';
        Ad = sign(Bd);
        %--------------------------------
        rho = x(1:size(Bij,2)-size(Bs,1));
        phi = x(size(rho,1)+1:end);
        %--------------------------------
        d = demand_func(data,rho,u);
        %--------------------------------
        d_rho = pinv(abs(Ad)*Landa*abs(Bd'))*(4*(Ad*phi-d)-abs(Ad)*Landa*abs(Bs')*d_s);
        d_phi = -pinv(Landa)*(Bs'*s+Bd'*rho)-K*phi.*abs(phi)./(abs(Bs')*s+abs(Bd')*rho);

        sys = [d_rho;d_phi];
		
    case 3
        demand_index = [17,19,28,29,42,43,53,54];
        sys = demand_index;
        for i=1:8
            sys(i) = x(demand_index(i)+54);
        end

    case {2 4 9}
        sys=[];
    otherwise
        error(['unhandled flag=',num2str(flag)]);
end

