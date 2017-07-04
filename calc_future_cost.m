function future_cost = calc_future_cost(X,x,u,J_future,model,syst)
% compute the expectancy of the future cost
% inputs :
%   X : cell array. Each array contains the discretisation of this
%   particular state value.
%   x : current state value
%   u : current command value
%   J_future : matrix of the future cost
%   model : structure containing the modelisation parameters
%   syst : structure containing the sizing parameters
% outputs :
%   future_cost : scalar value of the expected future cost

switch model.type
    case 'ms_ar'
        %% state vector components
        soe = x(1);
        SOE = X{1};
        delta = x(2);
        DELTA = X{2};
        pi = x(3);
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        prob_pi_next = model.A(pi,:);
        i_tmp = find(DELTA>=delta,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(pi,i_tmp,:));
        %% computation of future cost
        future_cost = Interp_1D(SOE,J_future,soe_next);
        prob_next = prob_delta_next*prob_pi_next;
        tmp = future_cost.*prob_next;
        future_cost = sum(tmp(:));        
    case 'ar1'
        %% state_vector components
        soe = x(1);
        SOE = X{1};
        delta = x(2);
        DELTA = X{2};
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        i_tmp = find(DELTA>=delta,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(i_tmp,:));
        %% computation of future cost
        future_cost = Interp_1D(SOE,J_future,soe_next);
        tmp = future_cost.*prob_delta_next;
        future_cost = sum(tmp(:));        
    case 'ar2'
        %% state_vector components
        soe = x(1);
        SOE = X{1};
        delta_1 = x(2);
        DELTA_1 = X{2};
        delta_2 = x(3);
        DELTA_2 = X{3};
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        i_tmp1 = find(DELTA_1>=delta_1,1,'first');
        i_tmp2 = find(DELTA_2>=delta_2,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(i_tmp1,i_tmp2,:));
        %% computation of future cost
        future_cost = Interp_1D(SOE,J_future,soe_next);
        future_cost = Interp_1D(DELTA_2,future_cost',delta_2)';
        tmp = future_cost.*prob_delta_next;
        future_cost = sum(tmp(:));        
    case 'uniform'
        %% state_vector components
        soe = x(1);
        SOE = X{1};
        delta = x(2);
        DELTA = X{2};
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        i_tmp = find(DELTA>=delta,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(i_tmp,:));
        %% computation of future cost
        future_cost = Interp_1D(SOE,J_future,soe_next);
        tmp = future_cost.*prob_delta_next;
        future_cost = sum(tmp(:));        
    case 'persistence'
        %% state_vector components
        soe = x(1);
        SOE = X{1};
        delta = x(2);
        DELTA = X{2};
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        i_tmp = find(DELTA>=delta,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(i_tmp,:));
        %% computation of future cost
        future_cost = Interp_1D(SOE,J_future,soe_next);
        tmp = future_cost.*prob_delta_next;
        future_cost = sum(tmp(:));        
end