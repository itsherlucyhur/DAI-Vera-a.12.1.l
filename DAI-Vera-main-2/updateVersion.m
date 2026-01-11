function updateVersion(app)
    newVersion = app.versionNumberDAI;
    panelTitle = ['Dynamic Angiographic Imaging (DAI) - Vera   ', newVersion];
    figureTitle = ['DAI - Vera ', newVersion];

    % Update figure title
    app.UIFigure.Name = figureTitle;

    % List of possible panel names (old + new versions)
    panelNames = {
        'DynamicAngiographicImagingDAIVeraPanel'
        'DynamicAngiographicImagingDAIVeraPanel_2'
        'DynamicAngiographicImagingDAIVeraPanel_3'
        'dynamicangiographicimagingdaiverapanel'
        'dynamicangiographicimagingdaiverapanel_2'
        'dynamicangiographicimagingdaiverapanel_3'
    };

    % Update only panels that actually exist
    for i = 1:numel(panelNames)
        pname = panelNames{i};
        if isprop(app, pname)
            app.(pname).Title = panelTitle;
        end
    end
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