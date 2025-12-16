function [numberOfIsotropicPixels, meanSample, areaOfAnIsotropicPixelInCmSq] = wGetIsotropicPixelsWithinContour(X, Y, fourDImageSet, currentSlice, dicomInfo)

    height = dicomInfo.PixelSpacing(1);
    width = dicomInfo.PixelSpacing(2);
    depth = dicomInfo.SliceThickness;
    
    pixelToConsiderForIsotropicBlock = round(depth / height);

    [Xall, Yall] = getAllPixelsInClosedContour(X, Y);
    
    if (pixelToConsiderForIsotropicBlock == 1)
        k = 1;
        for i = 1:max(size(Xall))
            allSamples(k,:) = fourDImageSet(currentSlice, 1:end, Xall(i), Yall(i));
            k = k + 1;
        end
        numberOfIsotropicPixels = k - 1;
        meanSample = mean(allSamples);
        areaOfAnIsotropicPixelInCmSq = height * width / 100;
    elseif (pixelToConsiderForIsotropicBlock == 2)
        k = 1;
        for i = 1 : pixelToConsiderForIsotropicBlock : 512-1
            for j = 1 : pixelToConsiderForIsotropicBlock : 512-1
                if (ismember(i, Xall) && ismember(i+1, Xall) && ismember(j, Yall) && ismember(j, Yall))
                    sample1 = fourDImageSet(currentSlice, 1:end, i, j);
                    sample2 = fourDImageSet(currentSlice, 1:end, i+1, j);
                    sample3 = fourDImageSet(currentSlice, 1:end, i, j+1);
                    sample4 = fourDImageSet(currentSlice, 1:end, i+1, j+1);
                    meanSample = (sample1 + sample2 + sample3 + sample4) / 4;
                    allSamples(k,:) = meanSample;
                    k = k + 1;
                end
            end
        end
        numberOfIsotropicPixels = k - 1;
        meanSample = mean(allSamples);
        areaOfAnIsotropicPixelInCmSq = ((2 * height) * (2 * width)) / 100;
    end
end

function [Xall, Yall] = getAllPixelsInClosedContour(X, Y)

    [xGrid, yGrid] = meshgrid(1:512, 1:512);
    xGridFlat = xGrid(:);
    yGridFlat = yGrid(:);
    [in, on] = inpolygon(xGridFlat, yGridFlat, X, Y);
    Xall = xGridFlat(in | on);
    Yall = yGridFlat(in | on);
end