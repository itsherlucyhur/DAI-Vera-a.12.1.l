function hB = getRelativeHeight(slicePositionA, slicePositionB, sliceThickness, isNegative)
    if slicePositionA == slicePositionB
        hB = 0;
    else
        if (isNegative)
            hB = -1 * abs(slicePositionA-slicePositionB) * sliceThickness / 10;
        else
            hB = abs(slicePositionA-slicePositionB) * sliceThickness / 10;
        end
    end
end