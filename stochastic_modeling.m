function model = stochastic_modeling(DELTA_P,model,syst)
% function computing the matrix of the probability of the next forecast
% error, given the current forecast error and a hidden state
% inputs :
%   DELTA_P : vector of the discretized values of forecast error
%   model : structure of the model parameters
%   syst : structure containing the sizing parameters
% outputs :
%   model : update structure of the model parameters, including Prob_Delta,
%       matrix of the probabilities of the next forecast error

d_DELTA_P = DELTA_P(2) - DELTA_P(1);

switch model.type
    % markov switching auto regressive
    case 'ms_ar'
        model.nb_states = 3; % nomber of MS_AR regimes
        model.Phi = [0.9 0.3 0.5]; % autocorrelation of errors in various states
        model.Sigma = syst.P_prod_max.*[0.1 0.4 0.3]; % standart variation of
                                                       % errors in various states
        model.A = [0.9 0.09 0.01 ; 0.3 0.6 0.1 ; 0.3 0.3 0.4]; % transition matrix
        Prob_Delta = zeros(model.nb_states,length(DELTA_P),length(DELTA_P));
        for k = 1:model.nb_states
            for i = 1:length(DELTA_P)
                for j = 1:length(DELTA_P)
                    delta_sup = DELTA_P(j) + d_DELTA_P/2 ;
                    delta_inf = DELTA_P(j) - d_DELTA_P/2 ;
                    Mu = model.Phi(k)*DELTA_P(i);
                    Prob_Delta(k,i,j) = 0.5*(1 + erf((delta_sup - Mu)/...
                        sqrt(2)/model.Sigma(k))) -...
                        0.5*(1 + erf((delta_inf - Mu)/...
                        sqrt(2)/model.Sigma(k)));
                end
                Prob_Delta(k,i,:) = Prob_Delta(k,i,:)./sum(Prob_Delta(k,i,:));
            end
        end
        % autoregressive
    case 'ar1'
        model.Phi = 0.98; % autocorrelation of errors
        model.Sigma = syst.P_prod_max.*41/4500; % standart variation of
                                            % errors 
        Prob_Delta = zeros(length(DELTA_P),length(DELTA_P));
        for i = 1:length(DELTA_P)
            for j = 1:length(DELTA_P)
                delta_sup = DELTA_P(j) + d_DELTA_P/2 ;
                delta_inf = DELTA_P(j) - d_DELTA_P/2 ;
                Mu = model.Phi*DELTA_P(i);
                Prob_Delta(i,j) = 0.5*(1 + erf((delta_sup - Mu)/...
                    sqrt(2)/model.Sigma)) -...
                    0.5*(1 + erf((delta_inf - Mu)/...
                    sqrt(2)/model.Sigma));
            end
            Prob_Delta(i,:) = Prob_Delta(i,:)./sum(Prob_Delta(i,:));            
        end
    case 'ar2'
        model.Phi = [1.4427 -0.4696]; % autocorrelation of errors with previous values
        model.Sigma = syst.P_prod_max.*37/4500; % standart variation of
                                              % errors 
        Prob_Delta = zeros(length(DELTA_P),length(DELTA_P),length(DELTA_P));
        for i = 1:length(DELTA_P)
            for j = 1:length(DELTA_P)
                for k = 1:length(DELTA_P)
                    delta_sup = DELTA_P(k) + d_DELTA_P/2 ;
                    delta_inf = DELTA_P(k) - d_DELTA_P/2 ;
                    Mu = model.Phi(1)*DELTA_P(i) + ...
                        model.Phi(2)*DELTA_P(j);
                    Prob_Delta(i,j,k) = 0.5*(1 + erf((delta_sup - Mu)/...
                        sqrt(2)/model.Sigma(1))) -...
                        0.5*(1 + erf((delta_inf - Mu)/...
                        sqrt(2)/model.Sigma(1)));
                end
                Prob_Delta(i,j,:) = Prob_Delta(i,j,:)./sum(Prob_Delta(i,j,:));
            end
        end
    case 'uniform'
        Prob_Delta = ones(length(DELTA_P))./length(DELTA_P);
    case 'persistence'
        Prob_Delta = eye(length(DELTA_P));                
end
model.Prob_Delta = Prob_Delta;
end