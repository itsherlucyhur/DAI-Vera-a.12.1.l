function imageWithContour = getROIOverlayed(inputImage, X, Y)
    for i = 1:max(size(X))
        inputImage(X(i),Y(i)) = 1500;
    end
    imageWithContour = inputImage;
end