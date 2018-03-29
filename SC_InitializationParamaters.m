%-------------------------------------------------------------------------%
function [SC] = SC_InitializationParamaters 
%-------------------------------------------------------------------------%

%{

Author: Kristofer Drozd
Created: 02/26/2018

Descritpion:

Inputs for the spacecraft being utilized. All units are 
non-dimensionalized.

Input: 

SC - structure giving the SC info.

Output: 

System - structure giving the CRTBP system info

%}

SC.massI = 1000;
SC.mSC = 100;
SC.Tmax = inf;
SC.Isp = 500;

end