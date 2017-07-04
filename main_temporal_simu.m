%% load time series
[P_prev,P_prod] = importfile('data_wind_prod_prev_2016.csv',2,52405);

% load_data = 1;
% if load_data == 1
%     % loading previous time series
%     P_prod = csvread('data_P_prod');
%     dT = P_prod(1); % time step in hours
%     N = P_prod(2); % number of points
%     P_prod = P_prod(3:end);
%     P_load = csvread('data_P_load');
%     P_load = P_load(3:end);    
% else
%     % generating new ones
%     N = 1000; % number of points
%     dT = 0.25; % time step in hours
%     [P_prod,P_load] = data_gen(dT,N,syst);
% end

DELTA_P = P_prev - P_prod;
SOE = zeros(size(P_prod));
SOE(1) = 0.5;
P_sto = zeros(size(P_prod));

%% load optimal strategy
load('results_ar1');
TT = 0:length(DELTA_P)-1;
TT = TT.*model.dT;

%% time simulation
for i_t = 1:length(TT)-1
    % construction of the current state
    x(1) = SOE(i_t);
    x(2) = DELTA_P(i_t);
    % interpolating optimal strategy matrix
    P_sto(i_t) = Interp_Policy(X,x,U_law);
    % updating system state
    SOE(i_t+1) = dynamic_function(SOE(i_t),P_sto(i_t),syst.E_sto_max,model.dT);
end