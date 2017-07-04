function [U_min,U_max] = calc_boundaries(X,x,U,model,syst)
% compute the boundaries of the acceptable command
% inputs : 
%   X : cell array. Each array contains the discretisation of this
%   particular state value. 
%   x : current state value
%   U : vector which contains a discretisation of the command
%   model : structure containing the modelisation parameters
%   syst : structure containing the sizing parameters
% outputs :
%   U_min, U_max : scalar value of the minimum and maximum command value


%% state vector components
soe = x(1);
SOE = X{1};
P_STO = U;

%% computation of boundaries

U_min = max(P_STO(1),-soe*syst.E_sto_max/model.dT);
U_max = min(P_STO(end),(SOE(end)-soe)*syst.E_sto_max/model.dT);

end