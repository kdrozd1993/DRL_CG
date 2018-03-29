function [store] = TestTrajectory (R,Test,SC)

segNumbers = Test.segNumbers;
x0 = Test.x0;
timeStep = Test.timeStep;
tf = Test.tf;
xf = Test.xf;

segmentStartTime = zeros (segNumbers,1);
waitbarHandle = waitbar (0,'This is your fathers watch ...');

for n = 1:segNumbers
    
    if n == 1
        segmentStartState = x0;
        segmentStartTime(n,1) = 0;
        segmentStartMass = SC.massI;
    else
        segmentStartState = xStore{:,n-1}(:,end);
        segmentStartTime(n,1) = tStore{1,n-1}(1,end);
        segmentStartMass = mStore{1,n-1}(1,end);
    end

    kr = R(1,n);
    kv = R(2,n);    
    
    tSpanSegment = segmentStartTime(n,1):timeStep:tf/segNumbers*n;
    
    [xSeg, tSeg, mSeg, acSeg] = GenZemZevSeg_ConstantGravity (kr,kv,tSpanSegment,segmentStartState,segmentStartMass,SC,Test);  
    
    xStore{1,n} = xSeg;    
    tStore{1,n} = tSeg;
    mStore{1,n} = mSeg;
    acStore{:,n} = acSeg;
    
    rewardStore(1,n) = RewardFunc(xSeg,mSeg,SC,Test);

    
    waitbar (n/segNumbers);
     
end

store.x = xStore;
store.t = tStore;
store.m = mStore;
store.ac = acStore;
store.reward = rewardStore;

close(waitbarHandle);

end