function z = Interp_1D(X,Z,x)
% interpolates the Z values in x absisse. 
% inputs : 
%   X : vector of absisses
%   Z : vector or matrix of values to interpolate. If matrix, the
%      interpolation is done along the first dimension
%   x : value where the interpolation should be done
% output : 
%   z : interpolated value

dX = X(2)-X(1);
i_x_next = find(X>=x,1);
if i_x_next<=1
    z = Z(1,:,:) + ...
        (x - X(1))/dX*(Z(2,:,:)-Z(1,:,:));
else
    z = Z(i_x_next-1,:,:)+ ...
        (x-X(i_x_next-1))/dX*...
        (Z(i_x_next,:,:)-Z(i_x_next-1,:,:));
end
z = squeeze(z);
end