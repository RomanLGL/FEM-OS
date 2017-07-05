function [U_opt, min_cost] = minimisation(X,x,U_bnd,J_future,model,syst)
% computes the optimal control value and associated minimum cost for a
% given state value
% inputs : 
%   X : cell array. Each array contains the discretisation of this
%   particular state value. 
%   x : current state value
%   U_bnd : extremum values of the control
%   J_future : matrix of the future cost
%   model : structure containing the modelisation parameters
%   syst : structure containing the sizing parameters
% outputs : 
%   U_opt : optimal control value
%   min_cost : associated minimum cost


% control boundaries
[U_min,U_max] = calc_boundaries(X,x,U_bnd,model);
% cost function to be minimized
obj_fun = @(u)(calc_cost(X,x,u,J_future,model,syst));
% Nelder Mead simplex with multiple initialisations
U0 = [U_min U_max];
[U_opt1,min_cost1] = NMsimplex(U0, U_min, U_max, obj_fun);
U0 = [U_min (U_max+U_min)./2];
[U_opt2,min_cost2] = NMsimplex(U0, U_min, U_max, obj_fun);
U0 = [(U_max+U_min)./2 U_max];
[U_opt3,min_cost3] = NMsimplex(U0, U_min, U_max, obj_fun);
delta = x(2);
if (delta>U_min)&&(delta<U_max)
    U0 = [delta (U_max+U_min)./2];
    [U_opt4,min_cost4] = NMsimplex(U0, U_min, U_max, obj_fun);
else
    U_opt4 = U_min;
    min_cost4 = realmax;
end
% convergence tests
cost = [min_cost4 ; min_cost1 ; min_cost2; min_cost3];
U = [U_opt4 U_opt1 U_opt2 U_opt3];
[min_cost,ind_tmp] = min(cost);
U_opt = U(ind_tmp);
end