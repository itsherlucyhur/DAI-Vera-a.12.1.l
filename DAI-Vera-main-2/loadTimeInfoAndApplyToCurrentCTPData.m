function [acquisitionTime, contentTime] = loadTimeInfoAndApplyToCurrentCTPData(fileName)
    
    timeObject = readtable(fileName);
    
    acquisitionTime = timeObject.acquisitionTime;
    contentTime = timeObject.contentTime;
    
end