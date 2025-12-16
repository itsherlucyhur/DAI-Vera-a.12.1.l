function dicomInfo = getDicomInfoFromEnhancedDicomInfo(enhancedDicomInfo, fourDimImageSet)

    numberOfSlices = size(fourDimImageSet, 1);
    numberOfTimePoints = size(fourDimImageSet, 2);
    row = size(fourDimImageSet, 3);
    col = size(fourDimImageSet, 4);
    dicomInfo = cell(1, numberOfSlices*numberOfTimePoints);
    
    dcmInfo = getMockDicomInfo();
    
    ptr = 1;
    
    for timePoint = 1:numberOfTimePoints
        for slice = 1:numberOfSlices
            
            if (isfield(enhancedDicomInfo{ptr}, 'FileModDate'))
                dcmInfo.FileModDate = enhancedDicomInfo{ptr}.FileModDate;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'FileSize'))
                dcmInfo.FileSize = enhancedDicomInfo{ptr}.FileSize;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'Format'))
                dcmInfo.Format = enhancedDicomInfo{ptr}.Format;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'FormatVersion'))
                dcmInfo.FormatVersion = enhancedDicomInfo{ptr}.FormatVersion;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'Width'))
                dcmInfo.Width = enhancedDicomInfo{ptr}.Width;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'Height'))
                dcmInfo.Height = enhancedDicomInfo{ptr}.Height;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'BitDepth'))
                dcmInfo.BitDepth = enhancedDicomInfo{ptr}.BitDepth;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'ColorType'))
                dcmInfo.ColorType = enhancedDicomInfo{ptr}.ColorType;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'FileMetaInformationGroupLength'))
                dcmInfo.FileMetaInformationGroupLength = enhancedDicomInfo{ptr}.FileMetaInformationGroupLength;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'FileMetaInformationVersion'))
                dcmInfo.FileMetaInformationVersion = enhancedDicomInfo{ptr}.FileMetaInformationVersion;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'ImplementationClassUID'))
                dcmInfo.ImplementationClassUID = enhancedDicomInfo{ptr}.ImplementationClassUID;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'ImplementationVersionName'))
                dcmInfo.ImplementationVersionName = enhancedDicomInfo{ptr}.ImplementationVersionName;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'ImageType'))
                dcmInfo.ImageType = enhancedDicomInfo{ptr}.ImageType;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'SOPInstanceUID'))
                dcmInfo.SOPInstanceUID = enhancedDicomInfo{ptr}.SOPInstanceUID;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'StudyDate'))
                dcmInfo.StudyDate = enhancedDicomInfo{ptr}.StudyDate;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'SeriesDate'))
                dcmInfo.SeriesDate = enhancedDicomInfo{ptr}.SeriesDate;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'AcquisitionDate'))
                dcmInfo.AcquisitionDate = enhancedDicomInfo{ptr}.AcquisitionDate;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'ContentDate'))
                dcmInfo.ContentDate = enhancedDicomInfo{ptr}.ContentDate;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'PixelSpacing'))
                dcmInfo.PixelSpacing = enhancedDicomInfo{ptr}.PixelSpacing;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'FrameOfReferenceUID'))
                dcmInfo.FrameOfReferenceUID = enhancedDicomInfo{ptr}.FrameOfReferenceUID;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'frameAcquistionTime'))
                dcmInfo.AcquisitionTime = enhancedDicomInfo{ptr}.frameAcquistionTime;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'frameAcquistionTime'))
                dcmInfo.ContentTime = enhancedDicomInfo{ptr}.frameAcquistionTime;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'Manufacturer'))
                dcmInfo.Manufacturer = enhancedDicomInfo{ptr}.Manufacturer;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'InstitutionName'))
                dcmInfo.InstitutionName = enhancedDicomInfo{ptr}.InstitutionName;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'PatientName'))
                dcmInfo.PatientName = enhancedDicomInfo{ptr}.PatientName;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'PatientID'))
                dcmInfo.PatientID = enhancedDicomInfo{ptr}.PatientID;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'PatientSex'))
                dcmInfo.PatientSex = enhancedDicomInfo{ptr}.PatientSex;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'SoftwareVersion'))
                dcmInfo.SoftwareVersion = enhancedDicomInfo{ptr}.SoftwareVersion;
            end
            if (isfield(enhancedDicomInfo{ptr}, 'BodyPartExamined'))
                dcmInfo.BodyPartExamined = enhancedDicomInfo{ptr}.BodyPartExamined;
            end
            
            dicomInfo{ptr} = dcmInfo;
            
            ptr = ptr + 1;
        end
    end
    
end

function mockDicomInfo = getMockDicomInfo()
    
    mockDicomInfo = struct();
    
    mockDicomInfo.Filename = '';
    mockDicomInfo.FileModDate = '';
    mockDicomInfo.FileSize = '';
    mockDicomInfo.Format = 'DICOM';
    mockDicomInfo.FormatVersion = 3;
    mockDicomInfo.Width = 512;
    mockDicomInfo.Height = 512;
    mockDicomInfo.BitDepth = 16;
    mockDicomInfo.ColorType = 'grayscale';
    mockDicomInfo.FileMetaInformationGroupLength = 188;
    mockDicomInfo.FileMetaInformationVersion = [ ];
    mockDicomInfo.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.2';
    mockDicomInfo.MediaStorageSOPInstanceUID = '';
    mockDicomInfo.TransferSyntaxUID = '1.2.840.10008.1.2.1';
    mockDicomInfo.ImplementationClassUID = '1.2.840.113619.6.248';
    mockDicomInfo.ImplementationVersionName = '';
    mockDicomInfo.SpecificCharacterSet = 'ISO_IR 100';
    mockDicomInfo.ImageType = '';
    mockDicomInfo.InstanceCreationDate = '';
    mockDicomInfo.InstanceCreationTime = '';
    mockDicomInfo.SOPClassUID = '1.2.840.10008.5.1.4.1.1.2';
    mockDicomInfo.SOPInstanceUID = '';
    mockDicomInfo.StudyDate = '';
    mockDicomInfo.SeriesDate = '';
    mockDicomInfo.AcquisitionDate = '';
    mockDicomInfo.ContentDate = '';
    mockDicomInfo.StudyTime = '';
    mockDicomInfo.SeriesTime = '';
    mockDicomInfo.AcquisitionTime = '';
    mockDicomInfo.ContentTime = '';
    mockDicomInfo.AccessionNumber = '';
    mockDicomInfo.Modality = 'CT';
    mockDicomInfo.Manufacturer = 'SIEMENS';
    mockDicomInfo.InstitutionName = 'SUN YAT-SEN MEMORIAL HOSPITAL';
    mockDicomInfo.ReferringPhysicianName = struct();
    mockDicomInfo.RescaleSlope = 1;
    mockDicomInfo.RescaleIntercept = -1024;
    mockDicomInfo.StudyDescription = 'Cardiac^01_DS_CaSc_CoronaryCTA_AdaptSeq (Adult)';
    mockDicomInfo.ProcedureCodeSequence = struct();
    mockDicomInfo.SeriesDescription = 'NonRigidReg:DynSerio4D S  2.0  Qr36  40% -';
    mockDicomInfo.OperatorName = struct();
    mockDicomInfo.ManufacturerModelName = 'SOMATOM Force';
    mockDicomInfo.ReferencedStudySequence = struct();
    mockDicomInfo.ReferencedPatientSequence = struct();
    mockDicomInfo.PatientName = struct();
    mockDicomInfo.PatientID = 'AW1063823433.729.1286156186';
    mockDicomInfo.PatientBirthDate = '';
    mockDicomInfo.PatientSex = 'F';
    mockDicomInfo.OtherPatientIDSequence = struct();
    mockDicomInfo.PatientAge = '078Y';
    mockDicomInfo.ContrastBolusAgent = 'APPLIED';
    mockDicomInfo.BodyPartExamined = 'HEART';
    mockDicomInfo.ScanOptions = 'XOP\A4CS\0001\TRGD\PHSP40PC0649\RSER000001\RIMA000520\A4TP000016MS00';
    mockDicomInfo.SliceThickness = 2;
    mockDicomInfo.KVP = 80;

end