function total_cost = calc_cost(X,x,u,J_future,model,syst)
% computes the total cost associated to a current state and a command value
% inputs : 
%   X : cell array. Each array contains the discretisation of this
%   particular state value. 
%   x : current state value
%   u : current command value
%   J_future : matrix of the future cost
%   model : structure containing the modelisation parameters
%   syst : structure containing the sizing parameters
% outputs : 
%   total_cost : scalar value of the total cost

% instantaneous cost
inst_cost = calc_inst_cost(x,u,model,syst);

% future cost
future_cost = calc_future_cost(X,x,u,J_future,model,syst);

% total cost
total_cost = inst_cost + future_cost;

end