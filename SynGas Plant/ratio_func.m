function x_NG = ratio_func(rho_delivery)
% This function calculates composition of natural gas in the feed stream of
% the reactor using spgr of natural gas
rho_air = 1.188; %@20C 1bar
spgr_NG = 0.7*45;
rho_cdo = 26; % @500-800 psia and 793K

x_NG = (spgr_NG*rho_air-rho_cdo)/(rho_delivery-rho_cdo);
end