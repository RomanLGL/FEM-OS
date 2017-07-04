function U_bnd = U_constraints(XX)
% associates each value of the discretized state space with boundaries over
% the possible commands
% input : 
%   XX : discretised state space
% output : 
%   U_bnd : 3D matrix, same size as XX + upper and lower boundaries

U_bnd = ones([size(XX),2]);
U_bnd(:,:,1) = max(sizing.P_sto_min*ones(size(XX)),-XX(1,:)/dT);
U_bnd(:,:,2) = min(sizing.P_sto_max*ones(size(XX)),...
    (sizing.E_sto_max-XX(1,:))/dT);

end