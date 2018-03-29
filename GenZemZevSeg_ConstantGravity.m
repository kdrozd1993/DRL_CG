%-------------------------------------------------------------------------%
function [xSeg,tSeg,mSeg,ac] = GenZemZevSeg_ConstantGravity ...
                               (kr,kv,tSpan,xi,mi,SC,Test)
%-------------------------------------------------------------------------%

%{

Author: Kristofer Drozd
Created: 02/26/2018

Descritpion:

Code for the Generalized ZEM/ZEV Guidance Algorithm that is set up such 
that it can be run in segments (placed within a for loop). 

Input: 

kr [1,1] - gain paramater

kv [1,1] - gain parameter

tSpan [1,n] - time span vector of segment where each element represents the
              time the acceleration command is updated

xi [6,1] - initial state of the segment 

mi [1,1] - initial spacecraft mass of the guidance segment

System {mu,g0] - structure giving the CRTBP system info

SC {Tmax,Isp] - structure giving the spacecraft info

Test {xf,tf] - structure giving Test info

Output: 

xSeg [6,n] - spacecraft state along the guidance trajectory

tSeg [1,n] - time along the guidance trajectory

mSeg [1,n] - spacecraft mass along the guidance trajectory

ac [3,n] - acceleration command along the guidance trajectory

%}

% Unpacking information from structures
g = 9.81;
Tmax = SC.Tmax;
mSC = SC.mSC;
Isp = SC.Isp;
xf = Test.xf;
tf = Test.tf;

% Initializing state, time, and mass variables throughout the segment
xSeg = xi;
tSeg = tSpan(1);
mSeg = mi;

% Targeted state and velocity
rfd = xf(1:3);
vfd = xf(4:6);

% Initializing ZEM, ZEV, and acceleration command variables
ZEM = zeros(3,length(tSpan)-1);
ZEV = zeros(3,length(tSpan)-1);
ac = zeros(3,length(tSpan)-1);

%{
For loop that performs the ZEM/ZEV guidance algorithm for the desired
time span:

1. Determine ZEM, ZEV, and tgo variables for the point where acceleration
   command is updated by propating the unaccelerated spacecraft for the
   remaining time to go
2. Calculating acceleration command
3. Determing thrust and updated acceleration command if the thrust exceeds
   the maximum
4. Determing the new spacecraft state as the spacecraft is propagated to
   the next time step
5. Store the state, time, and mass along the guidance segment.

%}
for n = 1:length(tSpan)-1
    
    % 1.
    x0_crtbp = xSeg(:,n);
    tspan1 = linspace(tSpan(n),tf,100);
    [~,x_crtbp] = ode23(@ConstantGravityAc,tspan1,x0_crtbp,[],zeros(3,1),g);
    x_crtbpEnd = x_crtbp(end,1:6)';
    tgo = tf - tSpan(n);
    ZEM(:,n) = rfd - x_crtbpEnd(1:3,1);
    ZEV(:,n) = vfd - x_crtbpEnd(4:6,1);


    
    % 2.
    ac(:,n) = (kr/(tgo^2))*ZEM(:,n) + (kv/(tgo))*ZEV(:,n);    
    
    % 3.
    thrust = mSeg(n)*norm(ac(:,n));
    if thrust > Tmax 
        thrustVec = mSeg(n)*ac(:,n);
        maxThrustVec = Tmax*thrustVec/norm(thrustVec);
        ac(:,n) = maxThrustVec/mSeg(n);
        thrust = mSeg(n)*norm(ac(:,n));
    end
    
    if mSeg(n) <= mSC
        ac(:,n) = zeros(3,1);
        thrust = 0;
    end
    
    % 4.
    x0_crtbpAc = xSeg(:,n);
    tspan2 = linspace (tSpan(n),tSpan(n+1),100);
    [t_crtbpAc,x_crtbpAc] = ode23 ...
                            (@ConstantGravityAc,tspan2,x0_crtbpAc,[],ac(:,n),g);
    % 5.
    xSeg(:,n+1) = x_crtbpAc(end,:)';
    tSeg(1,n+1) = t_crtbpAc(end,1)';
    mSeg(1,n+1) = mSeg(n) - thrust*(tSpan(n+1) - tSpan(n))/(g*Isp); 
    
end

end