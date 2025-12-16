function [volume, info] = readRegularCTAVolume(directory)

    listings = dir(directory);
    volume = zeros(512, 512, max(size(listings))-2);

    for i = 3:max(size(listings))
        fname = strcat(listings(i).folder, '\', listings(i).name);
        img = dicomread(fname);
        info = dicominfo(fname);
        volume(:,:,str2double(info.AccessionNumber)) = img;
    end
    
end