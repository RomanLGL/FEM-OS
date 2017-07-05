function u = Interp_Policy(X,x,U_law)
% interpolates in the x value the optimal command matrix which describes
% the best value for the command in any configuration of X
% inputs :
%   X : cell array. Each array contains the discretisation of this
%   particular state value.
%   x : current state value
%   U_law : matrix of the best control for each configuration of X
% outputs :
%   u : interpolated control for the x configuration

u = U_law;
for i = 1:length(size(U_law))
    u = Interp_Policy_1D(X{i},x(i),u);
end

end

function u = Interp_Policy_1D(X,x,U_law)
% run the interpolation over the first dimension of a n-dimensional
% matrix. The result is then reshaped to have a (n-1)-dimensional matrix of
% the corresponding size.
% inputs :
%   X : Vector containing the discretisation of the state along which the
%      interpolation is performed
%   x : current state value
%   U_law : n-dimensional matrix of the best control for each configuration
%       of the discretised state space (not only along X)
% outputs :
%   u : interpolated control for the x configuration, (n-1)-dimensional
%      matrix

S = size(U_law);
dX = X(2) - X(1);
i_X = find(X>=x,1);
if i_X <=1
    u = U_law(1,:) + ...
        (x(1)-X(i_X))/dX*(U_law(2,:)-U_law(1,:));
else
    u = U_law(i_X-1,:) + ...
        (x-X(i_X-1))/dX*...
        (U_law(i_X,:)-U_law(i_X-1,:));
end
u = squeeze(u);

if length(S)>2
    u = reshape(u,S(2:end));
end

end