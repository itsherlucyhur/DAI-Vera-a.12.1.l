function conversionFactor = getConversionFactor(app)
    
    conversionFactorsForSiemens = [43, 33, 27];
    conversionFactorsForCanon = [46, 35, 30];
    conversionFactorsForGE = [38, 30, 25];
    
    if (strcmp(app.scannerType, "Siemens"))
        conversionFactor = conversionFactorsForSiemens(app.xRayTubeVoltageIndex);
    elseif (strcmp(app.scannerType, "Canon"))
        conversionFactor = conversionFactorsForCanon(app.xRayTubeVoltageIndex);
    elseif (strcmp(app.scannerType, "GE"))
        conversionFactor = conversionFactorsForGE(app.xRayTubeVoltageIndex);
    end
    
end