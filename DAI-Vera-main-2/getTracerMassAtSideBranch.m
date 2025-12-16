function [tracerMassAtSideBranch, tracerMassAtTrunkAfterSideBranch] = getTracerMassAtSideBranch(radiusOfSideBranch, radiusAtTrunkBeforeSideBranch, radiusAtTrunkAfterSideBranch, tracerMassAtTrunkBeforeSideBranch)

    % tracerMassAtSideBranch = mb
    % tracerMassAtTrunkAfterSideBranch = mPostb
    % tracerMassAtTrunkBeforeSideBranch = mPreb
    % radiusOfSideBranch = rb
    % radiusAtTrunkBeforeSideBranch = rPreb
    % radiusAtTrunkAfterSideBranch = rPostb
    
    numerator_eq5 = (radiusOfSideBranch/radiusAtTrunkBeforeSideBranch)^4;
    denominator_eq5 = (radiusOfSideBranch/radiusAtTrunkBeforeSideBranch)^4 + (radiusAtTrunkAfterSideBranch/radiusAtTrunkBeforeSideBranch)^4;
    
    tracerMassAtSideBranch = tracerMassAtTrunkBeforeSideBranch * (numerator_eq5 / denominator_eq5);
    
    numerator_eq6 = (radiusAtTrunkAfterSideBranch/radiusAtTrunkBeforeSideBranch)^4;
    denominator_eq6 = (radiusOfSideBranch/radiusAtTrunkBeforeSideBranch)^4 + (radiusAtTrunkAfterSideBranch/radiusAtTrunkBeforeSideBranch)^4;
    
    tracerMassAtTrunkAfterSideBranch = tracerMassAtTrunkBeforeSideBranch * (numerator_eq6 / denominator_eq6);
end