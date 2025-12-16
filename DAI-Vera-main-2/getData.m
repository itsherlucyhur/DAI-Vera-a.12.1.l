function imds = getData(location)

    d = dir(location);
    isub = [d(:).isdir]; 
    subDirectories = {d(isub).name}';
    for i = 3:size(subDirectories,1)
        
        jpegDirectory = strcat(location, '\', subDirectories{i}, '\JPEGData');
        labelDirectory = strcat(location, '\', subDirectories{i}, '\LabeledData');
        dataStore{i} = imageDatastore(jpegDirectory);
        label = getLabelImagesFromDirectory(labelDirectory);
        Label{i-2} = categorical(label);
        dataStore{i}.Labels = Label{i-2};
        % TEST ONLY
        % getTraining(dataStore{i}, dataStore{i});
    end
    
    imds = imageDatastore(dataStore{3}.Files);
    for i = 4:size(dataStore,2) 
        imds = imageDatastore(cat(1, imds.Files,dataStore{i}.Files));
    end
    
    lbls = Label{1};
    for i = 4:size(dataStore,2)
        lbls = cat(1,lbls,Label{i-2});
    end
 
    imds.Labels = reshape(lbls,[size(lbls,1)*size(lbls,2),1]);
    
end

function label = getLabelImagesFromDirectory(directory)
    % The order of files would be different.
    % Need to make same filename for both.
    filePattern = fullfile(directory, '*.jpg');
    files = dir(filePattern);
    for k = 1:numel(files)
        fileName = strcat(files(k).folder,'\',files(k).name);
        % label{k} = char(imread(fileName));
        im = imread(fileName);
        if (sum(im(:)) == 0)
            label{k} = 'false';
        else
            label{k} = 'true';
        end
    end
end