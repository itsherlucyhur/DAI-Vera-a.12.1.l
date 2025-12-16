function curve = getCurveAt(x, y, slice, fourDImageSet)
    curve = fourDImageSet(slice,:,x,y);
end

