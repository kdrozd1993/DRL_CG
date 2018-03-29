%-------------------------------------------------------------------------%
function dx = ConstantGravityAc (t,x0,ac,g)
%-------------------------------------------------------------------------%

%{

Author: Kristofer Drozd
Created: 02/07/2018

Descritpion:

Circular Restricted Three-body Problem (Equations of Motion):
For use with a variable step integrator...

Input: 

t - time

x0 - initial state vector [x0,y0,z0,xdot0,ydot0,zdot0]

ac [3,1] - acceleration command

mu = m2/(m1+m2)

Output: 

dx - derivative state vector [xdot,ydot,zdot,xdotdot,ydotdot,zdotdot]

%}

% Initialize Derivative Vector:
dx = zeros(6,1);

% Integrate: dx/dt = xdot
dx(1:3) = x0(4:6);

% Integrate: dx^2/dt^2 = EOM
dx(4) =  0 + ac(1);
dx(5) =  0 + ac(2);
dx(6) = -g + ac(3);

end