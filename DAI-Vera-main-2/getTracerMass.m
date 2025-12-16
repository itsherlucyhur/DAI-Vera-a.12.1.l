function tracerMass = getTracerMass(app)

    switch app.dominanceType
        case "Right"
            Trca = 5;
            Tlad = 7;
            Tlcx = 5;
        case "Left"
            Trca = 4;
            Tlad = 7;
            Tlcx = 6;
        case "Co"
            Trca = 4.5;
            Tlad = 7;
            Tlcx = 5.5;
    end
    
    mRca = app.mTotal * app.f * (Trca / 17)*0.04;
    mLad = app.mTotal * app.f * (Tlad / 17)*0.04;
    mLcx = app.mTotal * app.f * (Tlcx / 17)*0.04;
    mLM = mLad + mLcx;
    
    tracerMass = [mRca, mLM, mLad, mLcx];
end