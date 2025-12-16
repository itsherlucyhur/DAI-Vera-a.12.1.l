function [time, avg] = readDataFile(filename)

fileID = fopen(filename);

if fileID == -1
    error('Cannot open file for reading: %s', filename);
end

counter = 1;
try
    while ~feof(fileID)
        
        textLine = fgetl(fileID);
        
        if isempty(textLine)
            continue; % Skip "empty" lines.
        else
            C = textscan(textLine,'%d %f %f %f %f %f %f');
            if (~isempty(C{2}))
                time(counter) = C{2};
                avg(counter) = C{4};
                counter = counter + 1;
            end
        end
        
    end
    
    fclose(fileID);
catch ME
    fclose(fileID);
    error('Error reading from file: %s', ME.message);
end

time = time';
avg = avg';

end