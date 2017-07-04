function soe_next = dynamic_function(soe,P_sto,E_max,dT)
% dynamic function giving the next state value according to the current
% state value, the control and the time step
% inputs : 
%   soe : current value of the state vector
%   P_sto : control vector at the current time step
%   dT : time step
%   E_max : rated battery capacity
% outputs :
%   soe_next : next value of the state vector

soe_next = soe + P_sto*dT/E_max;

end