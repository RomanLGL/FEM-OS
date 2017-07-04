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