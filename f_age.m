function C = f_age(P_sto,E_sto,model,syst)
% computes the aging cost 
% inputs : 
%   P_sto : stored power
%   E_sto : rated capacity of the storage
%   syst : system parameters
%       E_sto_max : battery rated capacity
%       alpha,beta : parameters of the aging law
%   model : model parameters
%       dT : time step
% outputs : 
%   C : aging cost

DoD = P_sto*model.dT/E_sto;
d = abs(syst.alpha*DoD^syst.beta);
C = syst.E_bat_emb*E_sto*d;
end