function interpolatedSliceForAllTimePoints = getInterpolatedSlice(slice, sliceTobeInterpolatedWith, fourDImageSet)
    row = size(fourDImageSet,3);
    col = size(fourDImageSet,4);
    timePoints = size(fourDImageSet,2);
    
    interpolatedSliceForAllTimePoints = zeros(timePoints,row,col);
    
    for i = 1:timePoints
        c(1,1:row,1:col) = fourDImageSet(slice,i,:,:);
        c(2,1:row,1:col) = fourDImageSet(sliceTobeInterpolatedWith,i,:,:);
        interpolatedSliceForAllTimePoints(i,1:row,1:col) = mean(c,1);
    end
end