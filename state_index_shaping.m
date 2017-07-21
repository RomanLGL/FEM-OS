function x = state_index_shaping(X,i_x)
% deduces the vaue of the state vector on the basis of a cell array X and
% the current index
% inputs : 
%   X : cell array. Each array contains the discretisation of this
%   particular state value.
%   i_x : linear index of the vector state
%   outputs : 
%   x : state value as a vector

%% initialisation and preallocations
N = length(X); % state dimension
x = zeros(N,1); % state vector
S = zeros(N,1); % vector of length of discretized state dimensions
for n = 1:N
    S(n) = length(X{n});
end

%% conversion to index
switch N
    case 3
        [i,j,k] = ind2sub(S,i_x);
        index = [i,j,k];
    case 4
        [i,j,k,l] = ind2sub(S,i_x);
        index = [i,j,k,l];        
end

%% corresponding state value
for k = 1:N
    x(k) = X{k}(index(k));
end
end