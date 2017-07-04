function inst_cost = calc_inst_cost(x,u,model,syst)
% computes the instantaneous cost
% inputs : 
%   x : current state value
%   u : current command value
%   model : structure containing the modelisation parameters
%   syst : structure containing the sizing parameters
% outputs : 
%   inst_cost : scalar value of the instantaneous cost

%% state vector components
delta = x(2);
P_sto = u;

%% computation of the instantaneous cost
C_age = f_age(P_sto,model,syst);
C_mis = f_mis(delta-P_sto,model,syst);
C_loss = f_loss(P_sto,model,syst);

inst_cost = C_age+C_mis+C_loss;

end