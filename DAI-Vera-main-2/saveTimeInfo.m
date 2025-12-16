function saveTimeInfo(acquisitionTime, contentTime)

    if(isrow(acquisitionTime))
        acquisitionTime = acquisitionTime';
    end
    if(isrow(contentTime))
        contentTime = contentTime';
    end
    
    TimeObject = table(acquisitionTime, contentTime);
    
    writetable(TimeObject, 'TimeInfo.txt');
end