function T_out = mixer_syngas(F_NG,F_S,T_NG,T_S)
% This function calculates the temperature of combined natural gas feed and
% steam
F_out = F_NG+F_S;
Cp = heat_capacity(T_NG);
Cp_NG = Cp(1);
Cp = heat_capacity(T_S);
Cp_S = Cp(5);
error = 1;
T_g = (T_NG+T_S)/2;
y_NG = F_NG/F_out;
y_S = 1-y_NG;

while error>1e-4
    Cp = heat_capacity(T_g);
    Cp_out = y_NG*Cp(1)+y_S*Cp(5);
    T_out = (F_NG*Cp_NG*T_NG+F_S*Cp_S*T_S)/F_out/Cp_out;
    error = abs(T_out-T_g);
    T_g = T_out;
end

end