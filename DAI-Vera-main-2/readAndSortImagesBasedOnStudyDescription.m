function readAndSortImagesBasedOnStudyDescription(directory)

    imageLoadingStartTime = clock;
    fix(imageLoadingStartTime);
    warning('off','all');
    
    dicomdict('set','dicom_dict_copy.txt');
    
    dicomlist = dir(directory);
    numberOfFiles = max(size(dicomlist))-2;
    
    logsDir = fullfile(directory, 'ReadAndSortImagesLogs');
    if ~isfolder(logsDir)
        mkdir(logsDir);
    end
    logFileName = sprintf('Logs.txt');
    logFilePath = fullfile(logsDir, logFileName);
    if ~exist(logFilePath, 'file')
        fileID = fopen(logFilePath,'w');
    else
        fileID = fopen(logFilePath,'a');
    end
        
    for k = 3 : numberOfFiles + 2
        fileName = strcat(directory, filesep, dicomlist(k).name);
        if (~isfolder(fileName))
            fprintf(fileID, '%s\n', fileName);
            dcmData = dicomread(fileName);
             try
                dcmInfo = dicominfo(strcat(fileName));
                if (strcmp(dcmInfo.Format, 'DICOM'))
                    if (isfield(dcmInfo, 'SeriesDescription'))
                        if isempty(dcmInfo.SeriesDescription)
                            SeriesDescription = 'No Series Description';
                            SeriesNumber = num2str(dcmInfo.SeriesNumber);
                        else
                            SeriesDescription = dcmInfo.SeriesDescription;
                            SeriesNumber = '';
                        end
                        destinationDiriectory = fullfile(directory, SeriesDescription, SeriesNumber);
                        if ~isfolder(destinationDiriectory)
                            mkdir(destinationDiriectory);
                        end
                        [~, name, ext] = fileparts(fileName);
                        dicomFileName = strcat(name, ext);
                        fName = fullfile(destinationDiriectory, dicomFileName);
                        dicomwrite(dcmData, fName, dcmInfo,'CreateMode','Copy');
                    end
                end
             catch ME
                if strcmp(ME.identifier, 'MATLAB:imagesci:dicominfo:notDICOM')
                    continue;
                end
             end
        end
    end


    fclose(fileID);
    imageLoadingEndTime = clock;
    fix(imageLoadingEndTime);
    
    seconds = etime(imageLoadingEndTime, imageLoadingStartTime);
    minutes = floor(seconds / 60);
    seconds = round(mod(seconds,60));
    fprintf('Image Sorter took %d minutes %d seconds\n',minutes, seconds);
end