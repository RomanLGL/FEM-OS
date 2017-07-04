function [X_opt,Y_opt,ret] = NMsimplex(X0, X_min, X_max, obj_fun)
% Nelder Mead simplex
% inputs : 
%   X0 : initial simplex
%   X_min : lower boundaries
%   X_max : upper boundaries
%   obj_fun : function to be minimized
% output : 
%   X_opt : arg_min(obj_fun)
%   Y_opt : min(obj_fun)
%   ret : equal to the number of iterations before convergence or 0 if the
%     maximum iteration criteria is reached before convergence

% simplex parameters default values
alpha = 1;
gamma = 2;
rho = -0.5;
sigma = 0.5;

% tolerance parameters
x_tol = 1e-6*max(abs(X_min),abs(X_max)); 
n_max = 100;

% problem dimension
[N,M] = size(X0);
% M : number of points in the simplex
% N : dimension of the problem
if N+1~=M
    disp('simplex badly initialized')
    X_opt = NaN;
    Y_opt = NaN;
    ret = 0;
    return 
end

% boundaries
X0 = min(X0,X_max);
X0 = max(X0,X_min);

% initial guess
X = X0;
F = zeros(1,M);
n=1;
cond =1;
while cond
    X0=X;
    % EVALUATION
    for i = 1:M
        F(i) = obj_fun(X(:,i));
    end
    % ORDERING
    [F,ind] = sort(F);
    X = X(:,ind);
    % CENTROID
    % as it is 1D, centroid is the first point
    x0 = mean(X(:,1:end-1),2);
    % REFLECTION
    xr = x0 + alpha*(x0-X(:,end));
    xr = max(min(xr,X_max),X_min);
    if obj_fun(xr) < F(end-1)
        % EXPANSION
        xe = x0 + gamma*(x0-X(:,end));
        xe = max(min(xe,X_max),X_min);
        if obj_fun(xe)<obj_fun(xr)
            X = [X(:,1:end-1) xe];
        else
            X = [X(:,1:end-1) xr];
        end
    else
        % CONTRACTION
        xc = x0 + rho*(x0-X(:,end));
        xc = max(min(xc,X_max),X_min);
        if obj_fun(xc)<F(end-1)
            X = [X(:,1:end-1)  xc];
        else
            % REDUCTION
            X = X(:,1)*ones(1,M) + sigma*(X - X(:,1)*ones(1,M));
        end
    end
    n=n+1;
    cond = (norm(X-X0)>x_tol).*(n<n_max);  
end
ret = n;
if (n==n_max)&&(norm(X)>x_tol)
    ret = 0;
end
X_opt = X(:,1);
X_opt = x_tol.*round(X_opt./x_tol);
Y_opt = F(1);
end
