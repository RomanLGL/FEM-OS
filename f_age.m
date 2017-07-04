function C = f_age(P_sto,model,syst)
% computes the aging cost 
% inputs : 
%   P_sto : stored power
%   syst : system parameters
%       E_sto_max : battery rated capacity
%       alpha,beta : parameters of the aging law
%   model : model parameters
%       dT : time step
% outputs : 
%   C : aging cost

DoD = P_sto*model.dT/syst.E_sto_max;
d = abs(syst.alpha*DoD^syst.beta);
C = syst.E_bat_emb*syst.E_sto_max*d;
end