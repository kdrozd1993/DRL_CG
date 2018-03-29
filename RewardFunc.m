%-------------------------------------------------------------------------%
function [reward] = RewardFunc(xSeg,mSeg,SC,Test)
%-------------------------------------------------------------------------%

%{

Author: Kristofer Drozd
Created: 02/26/2018

Descritpion:

This function defines the reward given to the agent based on its current
state.

Input: 

xSeg [6,n] - SC state at each segment time step

mSeg [1,n] - SC mass at each segment time step

System - structure giving the CRTBP system info

SC - structure giving the SC info

Test - structure giving the test info

Output: 

reward - the reward given to the agent

%}
xf = Test.xf;

if any(mSeg<=0);
    reward = -1e5;  
else
    reward = 1/norm(xSeg(1:6,end) - xf(1:6)); %- 0.1*abs((SC.massI-mSeg(end))*Mearthmoon);
end

end