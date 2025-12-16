function [croppedImageAtT1, croppedImageAtT2] = wGetCroppedWindowFromImage(app, cx, cy, m, t1, t2)

    croppedImageAtT1 = zeros(m, m);
    croppedImageAtT2 = zeros(m, m);
    
    sx = cx - m / 2;
    sy = cy - m / 2;
    
    if (sx == 0)
        sx = 1;
    end
    if (sy == 0)
        sy = 1;
    end
    
    row = 1;
    col = 1;
    for i = sx : sx + m - 1
        for j = sy : sy + m - 1
            
            croppedImageAtT1(row, col) = app.fourDImageSet(app.currentSlice, t1, i, j);
            croppedImageAtT2(row, col) = app.fourDImageSet(app.currentSlice, t2, i, j);
            
            col = col + 1;
        end
        row = row + 1;
        col = 1;
    end
end