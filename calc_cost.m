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

function inst_cost = calc_inst_cost(x,u,model,syst)
% computes the instantaneous cost
% inputs :
%   x : current state value
%   u : current command value
%   model : structure containing the modelisation parameters
%   syst : structure containing the sizing parameters
% outputs :
%   inst_cost : scalar value of the instantaneous cost

%% state vector components
E_sto = x(1);
delta = x(3);
P_sto = u;

%% computation of the instantaneous cost
C_age = f_age(P_sto,E_sto,model,syst);
C_mis = f_mis(delta-P_sto,model,syst);
C_loss = f_loss(P_sto,model,syst);

inst_cost = C_age+C_mis+C_loss;

end

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
        EE_sto = X{1};
        E_sto = x(1);
        soe = x(2);
        SOE = X{2};
        delta = x(3);
        DELTA = X{3};
        pi = x(4);
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,E_sto,model.dT);
        % probabilities of the next state (stochastic terms)
        prob_pi_next = model.A(pi,:);
        i_tmp = find(DELTA>=delta,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(pi,i_tmp,:));
        %% computation of future cost
        future_cost = Interp_1D(EE_sto,J_future,E_sto);
        future_cost = Interp_1D(SOE,future_cost,soe_next);
        prob_next = prob_delta_next*prob_pi_next;
        tmp = future_cost.*prob_next;
        future_cost = sum(tmp(:));
    case 'ar1'
        %% state_vector components
        EE_sto = X{1};
        E_sto = x(1);
        soe = x(2);
        SOE = X{2};
        delta = x(3);
        DELTA = X{3};
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        i_tmp = find(DELTA>=delta,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(i_tmp,:));
        %% computation of future cost
        future_cost = Interp_1D(EE_sto,J_future,E_sto);
        future_cost = Interp_1D(SOE,future_cost,soe_next);
        tmp = future_cost.*prob_delta_next;
        future_cost = sum(tmp(:));
    case 'ar2'
        %% state_vector components
        EE_sto = X{1};
        E_sto = x(1);
        soe = x(2);
        SOE = X{2};
        delta_1 = x(3);
        DELTA_1 = X{3};
        delta_2 = x(4);
        DELTA_2 = X{4};
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        i_tmp1 = find(DELTA_1>=delta_1,1,'first');
        i_tmp2 = find(DELTA_2>=delta_2,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(i_tmp1,i_tmp2,:));
        %% computation of future cost
        future_cost = Interp_1D(EE_sto,J_future,E_sto);
        future_cost = Interp_1D(SOE,future_cost,soe_next);
        future_cost = Interp_1D(DELTA_1,future_cost',delta_1)';
        tmp = future_cost.*prob_delta_next;
        future_cost = sum(tmp(:));
    case 'uniform'
        %% state_vector components
        EE_sto = X{1};
        E_sto = x(1);
        soe = x(2);
        SOE = X{2};
        delta = x(3);
        DELTA = X{3};
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        i_tmp = find(DELTA>=delta,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(i_tmp,:));
        %% computation of future cost
        future_cost = Interp_1D(EE_sto,J_future,E_sto);
        future_cost = Interp_1D(SOE,future_cost,soe_next);
        tmp = future_cost.*prob_delta_next;
        future_cost = sum(tmp(:));
    case 'persistence'
        %% state_vector components
        EE_sto = X{1};
        E_sto = x(1);
        soe = x(2);
        SOE = X{2};
        delta = x(3);
        DELTA = X{3};
        P_sto = u;
        %% dynamic behaviour
        % dynamic equation to compute next state (deterministic terms)
        soe_next = dynamic_function(soe,P_sto,syst.E_sto_max,model.dT);
        % probabilities of the next state (stochastic terms)
        i_tmp = find(DELTA>=delta,1,'first');
        prob_delta_next = squeeze(model.Prob_Delta(i_tmp,:));
        %% computation of future cost
        future_cost = Interp_1D(EE_sto,J_future,E_sto);
        future_cost = Interp_1D(SOE,future_cost,soe_next);
        tmp = future_cost.*prob_delta_next;
        future_cost = sum(tmp(:));
end
end