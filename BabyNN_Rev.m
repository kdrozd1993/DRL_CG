%-------------------------------------------------------------------------%
function [W,featureVec] = BabyNN_Rev (x,outputs)
%-------------------------------------------------------------------------%

%{

Author: Kristofer Drozd
Created: 02/26/2018

Descritpion:

This function performs the gives the ZEM/ZEV segment guaidance gains and
feature values.

Input: 

x [6,1] - SC state at the start of a guiding segment 

W [11,2,n] - Weight matrix for each segment (3rd dimension; n -> number of 
             segments)

Output: 

outputs [1,2] - The ZEM/ZEV gains

featureVec [11,1]- the features

%}

Beta = 1e-3;

func{1,1}  = @(z) exp(-(norm(z-[1;0;0;0;0;0]*1e3)*Beta)^2);
func{2,1}  = @(z) exp(-(norm(z-[0;1;0;0;0;0]*1e3)*Beta)^2);
func{3,1}  = @(z) exp(-(norm(z-[0;0;1;0;0;0]*1e3)*Beta)^2);
func{4,1}  = @(z) exp(-(norm(z-[0;0;0;1;0;0]*1e3)*Beta)^2);
func{5,1}  = @(z) exp(-(norm(z-[0;0;0;0;1;0]*1e3)*Beta)^2);
func{6,1}  = @(z) exp(-(norm(z-[0;0;0;0;0;1]*1e3)*Beta)^2);
func{7,1}  = @(z) exp(-(norm(z-[1;1;0;0;0;0]*1e3)*Beta)^2);
func{8,1}  = @(z) exp(-(norm(z-[1;1;1;0;0;0]*1e3)*Beta)^2);
func{9,1}  = @(z) exp(-(norm(z-[1;1;1;1;0;0]*1e3)*Beta)^2);
func{10,1} = @(z) exp(-(norm(z-[1;1;1;1;1;0]*1e3)*Beta)^2);
func{11,1} = @(z) exp(-(norm(z-[1;1;1;1;1;1]*1e3)*Beta)^2);
func{12,1} = @(z) exp(-(norm(z-[0;1;1;1;1;1]*1e3)*Beta)^2);
func{13,1} = @(z) exp(-(norm(z-[0;0;1;1;1;1]*1e3)*Beta)^2);
func{14,1} = @(z) exp(-(norm(z-[0;0;0;1;1;0]*1e3)*Beta)^2);
func{15,1} = @(z) exp(-(norm(z-[1;1;1;0;1;1]*1e3)*Beta)^2);
func{16,1} = @(z) exp(-(norm(z-[1;1;1;1;0;1]*1e3)*Beta)^2);
func{17,1} = @(z) exp(-(norm(z-[1;1;1;0;0;0]*1e3)*Beta)^2);
func{18,1} = @(z) exp(-(norm(z-[0;0;0;1;1;1]*1e3)*Beta)^2);

featureVec = zeros(size (func,1),1);

for n = 1:size(func,1)    
    featureVec(n,1) = func{n,1}(x);
end

W_t = outputs'*featureVec'*pinv(featureVec*featureVec');
W = W_t';

end