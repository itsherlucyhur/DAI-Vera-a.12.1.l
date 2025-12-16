function updateVersion(app)
    newVersion = app.versionNumberDAI;
    panelTitle = ['Dynamic Angiographic Imaging (DAI) - Vera', '   ', newVersion];
    figureTitle = ['DAI - Vera', ' ', newVersion];
    
    app.UIFigure.Name = figureTitle;

    app.DynamicAngiographicImagingDAIVeraPanel.Title = panelTitle;
    app.DynamicAngiographicImagingDAIVeraPanel_2.Title = panelTitle;
    app.DynamicAngiographicImagingDAIVeraPanel_3.Title = panelTitle;
    
    % changeVersionInDarkMode(newVersion);
end

function changeVersionInDarkMode(version)

    codeFileName = 'changeViewMode.m';
    newVersion = strrep(version,'.','');
    text = fileread(codeFileName);
    oldVersion = num2str(str2num(newVersion)-1);
    newText = replace(text, oldVersion, newVersion);
    
    directoryName = pwd;
    [status, attributes] = fileattrib(directoryName);
    if (attributes.UserWrite)
        fid = fopen(codeFileName, 'w');
        fprintf(fid, '%s', newText);
        fclose(fid);
    else
        error_msg = 'You do not have permission to write in this directory. Please choose a directory where you have write permission.';
        errordlg(error_msg, 'Error');
        error(error_msg);
    end
end