function XX = state_shaping(X)
% create a matrix XX from the state space discretisation X
% input : 
%   X : cell array. Each array contains the discretisation of this
%   particular state value. 
% output : 
%   XX : matrix, #lines = length of the state vector. #row = total number
%      of elements in the discretised state space

XX_size = zeros(1,numel(X));
XX_size(1) = length(X{1});
for i = 2:numel(X)
    XX_size(i) = length(X{i});
end
if length(XX_size)==1
    XX = X{1};
else
    XX = zeros(numel(X),prod(XX_size));
    tmp = ones(prod(XX_size(2:end)),1)*X{1};
    XX(1,:) = reshape(tmp',1,[]);
    for i = 2:length(XX_size)-1
        tmp = ones(prod(XX_size(1:i-1)),1)*X{i};
        tmp = reshape(tmp,1,[]);
        tmp = ones(prod(XX_size(i+1:end)),1)*tmp;
        XX(i,:) = reshape(tmp',1,[]);
    end
    tmp = ones(prod(XX_size(1:end-1)),1)*X{end};
    XX(end,:) = reshape(tmp,1,[]);
end

end