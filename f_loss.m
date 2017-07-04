function C = f_loss(P_sto,model,syst)
% computes the cost associated to the battery losses 
% inputs : 
%   P_sto : stored power
%   syst : system parameters
%       a : losses coefficient
%       eta_renew : environmental efficiency of the renewable system
%   model : model parameters
%       dT : time step
% outputs : 
%   C : losses cost

P_loss = syst.eta_coef_bat*P_sto^2./syst.P_sto_max;
C = model.dT*P_loss./syst.eta_renew;

end