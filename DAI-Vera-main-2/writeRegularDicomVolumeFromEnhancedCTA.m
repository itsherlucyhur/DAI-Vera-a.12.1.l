function writeRegularDicomVolumeFromEnhancedCTA(V, EnhancedInfo)
    Info = getMockDicomInfo();
    Info.PatientPosition = EnhancedInfo.PatientPosition;
    
    for i = 1:max(size(V))
        fname = strcat(num2str(i),'.dcm');
        Info.AccessionNumber = num2str(i);
        dicomwrite(V(:,:,i),fname,Info,'CreateMode','Copy');
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
    mockDicomInfo.Manufacturer = 'DAI';
    mockDicomInfo.InstitutionName = 'DAI';
    mockDicomInfo.ReferringPhysicianName = struct();
    mockDicomInfo.RescaleSlope = 1;
    mockDicomInfo.RescaleIntercept = -1024;
    mockDicomInfo.StudyDescription = 'DAI';
    mockDicomInfo.ProcedureCodeSequence = struct();
    mockDicomInfo.SeriesDescription = 'DAI';
    mockDicomInfo.OperatorName = struct();
    mockDicomInfo.ManufacturerModelName = 'DAI';
    mockDicomInfo.ReferencedStudySequence = struct();
    mockDicomInfo.ReferencedPatientSequence = struct();
    mockDicomInfo.PatientName = struct();
    mockDicomInfo.PatientID = 'DAI';
    mockDicomInfo.PatientBirthDate = '';
    mockDicomInfo.PatientSex = '';
    mockDicomInfo.PatientPosition = '';
    mockDicomInfo.OtherPatientIDSequence = struct();
    mockDicomInfo.PatientAge = 'Y';
    mockDicomInfo.ContrastBolusAgent = '';
    mockDicomInfo.BodyPartExamined = 'HEART';
    mockDicomInfo.ScanOptions = '';
    mockDicomInfo.SliceThickness = 2;
    mockDicomInfo.KVP = 80;

end