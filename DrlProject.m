% Kristofer Drozd
% DRL Project Prototype

%{ 
ToDo: 
xxx Add maximum thrust
xxx Create functions for input structures
Get better state to target
Work on storing components of the sample trajectory
xxx Set up rewards for each segment
xxx Loading bar
Comments
%}

clear all
close all
clc

%% Initial Test Values

SC = SC_InitializationParamaters;
Test = Test_InitializationParamaters;

%% Initializing Weights

a = 0;
b = 1;
rows = 11;
cols = 2;
mats = 1;

W = UniformRandomN (a,b,rows,cols,mats);

outputs = [6 -2];
[W_,featureVec] = BabyNN_Rev (Test.x0,outputs);

W = W_;

%% Creating Sample Tranjectory

[store,P,R,F] = SampleTrajectory2(W,Test,SC,outputs);

%% Descritizing Sample Trajectory

alpha = 1e-6;

FF = F;
RR = R;
PP = P;
WW = W;

rewardPlot = sum(store.reward);

for n = 1:1000
    
    for m = 1:Test.segNumbers;
        
        score =  FF(:,m)*(RR(:,m) - PP(:,m))'./(Test.sigma^2);
        
        %alpha*score*sum (store.reward(1:end));
        
        WW = WW + alpha.*score.*sum (store.reward(m:end))/max(rewardPlot);
        
    end
    
    [store,PP,RR,FF] = SampleTrajectory(WW,Test,SC);
    
    store.x{end}(:,end)
    sum(store.reward);
    rewardPlot(n+1) = sum(store.reward);
    rewardPlot(n+1)
    
    if sum(store.reward) >= 1
        %break
    end
    
end
    
plot(1:n+1,rewardPlot) 
    

