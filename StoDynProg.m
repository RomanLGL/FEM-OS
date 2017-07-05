function [U_law,J] = StoDynProg(X,U_bnd,model,syst)
% computes the optimal control matrix U_law along with the optimal cost
% matrix J using Bellman equation with an infinite horizon
% inputs : 
%   X : cell array. Each array contains the discretisation of this
%   particular state value.
%   U_bnd : extremum values of the control
%   model : structure containing the modelisation parameters
%   syst : structure containing the sizing parameters
% outputs : 
%   U_law : optimal control matrix U_law
%   J : optimal cost matrix

%% inialisation and preallocations of the results matrix
N = length(X); % state dimension
S = zeros(1,N); % vector of length of discretized state dimensions
for k = 1:N
    S(k) = length(X{k});
end
U_law = zeros(S); % preallocation of the optimal command matrix
J = zeros(S); % preallocation of the optimal cost matrix
U_prev = 1000*ones(S);

%% convergence criteria
rel_tol = 1e-3; % relative tolerance
abs_tol = 1; % absolute tolerance
n_max = 3; % maximum iterations

%% backward resolution loop
dif = (U_law - U_prev);
n = 1;
while ( sum(abs(dif(:))) > rel_tol*max(dif(:)) ) &&...
        ( max(abs(dif(:))) > abs_tol )&&...
        ( n <= n_max )
    U_prev = U_law;
    J_future = J;
    for i_x = 1:prod(S)
        [x,index] = state_index_shaping(X,i_x);
        [U_opt, min_cost] = minimisation(X,x,U_bnd,J_future,...
            model,syst);
        linearInd = sub2ind_dim(S,index);
        U_law(linearInd) = U_opt;
        J(linearInd) = min_cost;
    end
    
    dif = (U_law - U_prev);
    n=n+1;
end
if n==n_max
    disp('reached maximum iteration value')
end

end