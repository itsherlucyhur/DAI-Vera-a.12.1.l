function [tracerMassAtSideBranches, tracerMassAtTrunkAfterEachSideBranch] = getTracerMassAtEverySideBranch(app)
    
    if (app.numberOfBranches > 0)
        
        tracerMassAtSideBranches = zeros(app.numberOfBranches,1);
        tracerMassAtTrunkAfterEachSideBranch = zeros(app.numberOfBranches,1);
        tracerMassAtTrunkBeforeSideBranch = app.postQinitial;

        for b = 1 : app.numberOfBranches

            radiusOfSideBranch = app.branchData.branches(b).radiusOfSideBranch;
            radiusAtTrunkBeforeSideBranch = app.branchData.branches(b).radiusAtTrunkBeforeSideBranch;
            radiusAtTrunkAfterSideBranch = app.branchData.branches(b).radiusAtTrunkAfterSideBranch;


            [tracerMassAtSideBranch, tracerMassAtTrunkAfterSideBranch] = getTracerMassAtSideBranch(radiusOfSideBranch, radiusAtTrunkBeforeSideBranch, radiusAtTrunkAfterSideBranch, tracerMassAtTrunkBeforeSideBranch);
            tracerMassAtSideBranches(b) = tracerMassAtSideBranch;
            tracerMassAtTrunkAfterEachSideBranch(b) = tracerMassAtTrunkAfterSideBranch;
            
            tracerMassAtTrunkBeforeSideBranch = tracerMassAtTrunkAfterSideBranch;

        end
    else
        tracerMassAtSideBranches = 0;
        tracerMassAtTrunkAfterEachSideBranch = app.postQinitial;
    end
end