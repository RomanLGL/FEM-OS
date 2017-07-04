%% state space discretisation
X{1} = linspace(0,1,11);
X{2} = linspace(-1,1,6);
X{3} = linspace(0,5,3);
XX = state_shaping(X);

%% command constraints
U_bnd = U_constraints(XX);

%% preallocation of results matrix
[~,XX_length] = size(XX);
[~,UU_length] = size(U_bnd);
% inialisation of the optimal strategy containing optimal control
U_law = zeros([XX_length,length(TT)-1,UU_length]);
% inialisation of the optimal cost associated to optimal strategy
J = zeros(XX_length,length(TT));
% evaluation of the cost associated to the final situation
J(:,end) = final_cost(XX);

%% backward time loop
for i_t = length(TT)-1:-1:1
    J_future = squeeze(J(:,i_t+1));
    %% state loop
    for i_x = 1:XX_length
        x = XX(:,i_x);
        [U_opt, min_cost] = minimisation();
        J(i_x,i_t) = min_cost;
        U_law(i_x,i_t,:) = U_opt;
    end
end
