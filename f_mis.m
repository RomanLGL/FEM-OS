function C = f_mis(dP_grid,model,syst)
% computes the cost associated to the commitment mismatch 
% inputs : 
%   dP_grid : commitment mismatch power
%   syst : system parameters
%       eta_EU : environmental efficiency of the european electricity mix
%   model : model parameters
%       dT : time step
% outputs : 
%   C : mismatch cost

C = model.dT*abs(dP_grid)./syst.eta_EU;
end