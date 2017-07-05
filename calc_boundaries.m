function [U_min,U_max] = calc_boundaries(X,x,U_bnd,model)
% compute the boundaries of the acceptable command
% inputs : 
%   X : cell array. Each array contains the discretisation of this
%   particular state value. 
%   x : current state value
%   U_bnd : extremum values of the control
%   model : structure containing the modelisation parameters
% outputs :
%   U_min, U_max : scalar value of the minimum and maximum command value


%% state vector components
E_sto = x(1);
soe = x(2);
SOE = X{2};
P_STO_bnd = U_bnd;

%% computation of boundaries

U_min = max(P_STO_bnd(1),-soe*E_sto/model.dT);
U_max = min(P_STO_bnd(end),(SOE(end)-soe)*E_sto/model.dT);

end