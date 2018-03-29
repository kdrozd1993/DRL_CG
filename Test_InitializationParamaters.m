%-------------------------------------------------------------------------%
function [Test] = Test_InitializationParamaters 
%-------------------------------------------------------------------------%

%{

Author: Kristofer Drozd
Created: 02/26/2018

Descritpion:

Inputs for the simulation being performed, such as initial and targeted 
state. All units are non-dimensionalized with respect to the CRTBP system.

Input: 

Test - structure giving the test info.

Output: 

System - structure giving the CRTBP system info

%}


Test.segNumbers = 10;

Test.x0 = [ 0;...
            0;...
            1000;...
            0;...
            0;...
            0];
   
Test.xf = [ 0;...
            0;...
            0;...
            0;...
            0;...
            0];

Test.timeStep = 0.1;
Test.tf = 30;
Test.sigma = 1;

end

