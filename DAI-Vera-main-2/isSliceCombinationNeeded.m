function factorToCombineSlices = isSliceCombinationNeeded(sliceThickness)

    factorToCombineSlices = 0;
    
    if (sliceThickness < 1)
        % 2mm is the default slice thickness.
        factorToCombineSlices = round(2 / sliceThickness);
    end
    
end