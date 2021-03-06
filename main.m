%% system parameters
syst.P_prod_max = 1e6; % maximum renewable production W
syst.P_sto_max = 1e6; % maximum storage power W
syst.P_sto_min = -1e6; % minimum storage power W
% syst.P_load_max = 100e3; % maximum load consumption W
syst.E_sto_max = 1e6; % capacity of the storage unit
syst.E_bat_emb = 200; % embedded energy of the battery kWh/kWh
syst.alpha = 2.6e-4; % parameters of the aging law
syst.beta = 1.84; 
syst.eta_EU = 0.3; % environmental efficiency of the european electricity 
                   % mix
syst.E_pv_emb = 7e3; % embedded energy of the PV panel kWh/kW
syst.E_pv_life = 30e3; % expected electricity produced over the PV panel 
                       % life
syst.eta_renew = syst.E_pv_life/syst.E_pv_emb; % environmental efficiency 
                                               % of PV panel
syst.eta_coef_bat = 0.01; % battery efficiency modeling

%% modeling of production process
model.dT = 1; % model time step in hours
model.type = 'ms_ar'; % type of desired modeling 
                      % uniform, persistence, ar1, ar2 or ms_ar

%% state space discretization
N_E_sto = 2;
EE_sto = linspace(syst.E_sto_max/N_E_sto,syst.E_sto_max,N_E_sto);
N_SOE = 20;
SOE = linspace(0,1,N_SOE);
N_DELTA_P = 20;
DELTA_P = linspace(-syst.P_prod_max,syst.P_prod_max,N_DELTA_P);
model = stochastic_modeling(DELTA_P,model,syst);

%% command boundaries
U_bnd = [syst.P_sto_min syst.P_sto_max];

%% state vector construction
switch model.type
    case 'ms_ar'
        PI = 1:model.nb_states;
        X{1} = EE_sto;
        X{2} = SOE;
        X{3} = DELTA_P;
        X{4} = PI;
    case 'ar1'
        X{1} = EE_sto;
        X{2} = SOE;
        X{3} = DELTA_P;
    case 'ar2'
        X{1} = EE_sto;
        X{2} = SOE;
        X{3} = DELTA_P;
        X{4} = DELTA_P;
    case 'uniform'
        X{1} = EE_sto;
        X{2} = SOE;
        X{3} = DELTA_P;
    case 'persistence'
        X{1} = EE_sto;
        X{2} = SOE;
        X{3} = DELTA_P;
end

%% dynamic programing
tic;
[U_law,J] = StoDynProg(X,U_bnd,model,syst);
toc
str = strcat('results_',num2str(model.type));
save(str,'X','U_bnd','model','syst','U_law','J');