function [x,index] = state_index_shaping(X,i_x)

%% initialisation and preallocations
i_x = i_x-1;
N = length(X); % state dimension
index = zeros(N,1); % vector of indexes
x = zeros(N,1); % state vector
S = zeros(N,1); % vector of length of discretized state dimensions
for n = 1:N
    S(n) = length(X{n});
end
%% last dimension
index(end) = mod(i_x,S(end));
tmp = i_x - index(end);
%% recursive loop
k = N-1;
while k~=0
    index(k) = mod( tmp/prod(S(k+1:end)),S(k));
    tmp = tmp - index(k)*prod(S(k+1:end));
    k = k-1;
end
%% corresponding state value
index = index+1;
for k = 1:N
    x(k) = X{k}(index(k));
end
end