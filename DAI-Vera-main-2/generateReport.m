function generateReport(app)
    if (~isempty(app.dicomInfo))
        [fileName, directoryName] = generateFileName(app.dicomInfo.PatientName.FamilyName);
    elseif (~isempty(app.dicomInfoRest))
        [fileName, directoryName] = generateFileName(app.dicomInfoRest.PatientName.FamilyName);
    elseif (~isempty(app.dicomInfoStressOnly))
        [fileName, directoryName] = generateFileName(app.dicomInfoStressOnly.PatientName.FamilyName);
    else
        fileName = 'DiagnosticReport';
        directoryName = pwd;  % Use current directory if no DICOM info is available
    end
    
    [status, attributes] = fileattrib(directoryName);
    if (attributes.UserWrite)
        fileName = strcat(fileName, '.txt');
        fileID = fopen(fileName,'wt');
    
        if (~isempty(app.dicomInfo))
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Diagnostic Report (Stress)\n');
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Patient Name: %s\n',app.dicomInfo.PatientName.FamilyName);
            fprintf(fileID,'Study Date: %s\n',app.dicomInfo.StudyDate);
            fprintf(fileID,'Pre-Lesion Coordiante: (%d, %d)\n',app.pa(3),app.pa(4));
            fprintf(fileID,'Pre-Lesion Location: Slice = %d, Time Point = %d\n',app.paSlice, app.paTimePoint);
            fprintf(fileID,'Post-Lesion Coordiante: (%d, %d)\n',app.pd(3),app.pd(4));
            fprintf(fileID,'Post-Lesion Location: Slice = %d, Time Point = %d\n',app.pdSlice, app.pdTimePoint);
            fprintf(fileID,'Volume of Contrast: %0.6f\n',str2double(app.ContrastVolumemLEditField.Value));
            fprintf(fileID,'Concentration of Contrast: %0.6f\n',str2double(app.ContrastConcentrationmglmLEditField.Value));
            fprintf(fileID,'Radius of Pre-Lesion: %0.3f\n',str2double(app.PrelesionLumenRadiuscmEditField.Value));
            fprintf(fileID,'Radius of Post-Lesion: %0.3f\n',str2double(app.PostlesionLumenRadiuscmEditField.Value));
            fprintf(fileID,'Systolic Blood Pressure: %d\n',str2double(app.SystolicBloodPressuremmHgEditField.Value));
            fprintf(fileID,'FFR: %0.4f\n',app.FFR);
            fprintf(fileID,'Flow Velocity of Pre-Lesion: %0.4f\n',str2double(app.PrelesionFlowVelocitycmsEditField.Value));
            fprintf(fileID,'Flow Velocity of Post-Lesion: %0.4f\n',str2double(app.PostlesionFlowVelocitycmsEditField.Value));
            fprintf(fileID,'Shear Stress of Pre-Lesion: %0.4f\n',str2double(app.PrelesionShearStressPaEditField.Value));
            fprintf(fileID,'Shear Stress of Post-Lesion: %0.4f\n',str2double(app.PostlesionShearStressPaEditField.Value));
            fprintf(fileID,'Pre-Lesion CFR: %0.4f\n',str2double(app.PrelesionCFREditField.Value));
            fprintf(fileID,'Post-Lesion CFR: %0.4f\n',str2double(app.PostlesionCFREditField.Value));
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Curve Fitting Info (Stress)\n');
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Pre-Lesion alpha: %0.4f\n',app.alphaA);
            fprintf(fileID,'Pre-Lesion beta: %0.4f\n',app.betaA);
            fprintf(fileID,'Pre-Lesion K: %0.4f\n',app.kA);
            fprintf(fileID,'Pre-Lesion RMSE: %0.4f\n',app.rmseA);
            fprintf(fileID,'Post-Lesion alpha: %0.4f\n',app.alphaB);
            fprintf(fileID,'Post-Lesion beta: %0.4f\n',app.betaB);
            fprintf(fileID,'Post-Lesion K: %0.4f\n',app.kB);
            fprintf(fileID,'Post-Lesion RMSE: %0.4f\n',app.rmseB);
        end

        if (~isempty(app.dicomInfoRest))
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Diagnostic Report (Rest)\n');
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Patient Name: %s\n',app.dicomInfoRest.PatientName.FamilyName);
            fprintf(fileID,'Study Date: %s\n',app.dicomInfoRest.StudyDate);
            fprintf(fileID,'Pre-Lesion Coordiante: (%d, %d)\n',app.paRest(3),app.paRest(4));
            fprintf(fileID,'Pre-Lesion Location: Slice = %d, Time Point = %d\n',app.paSliceRest, app.paTimePointRest);
            fprintf(fileID,'Post-Lesion Coordiante: (%d, %d)\n',app.pdRest(3),app.pdRest(4));
            fprintf(fileID,'Post-Lesion Location: Slice = %d, Time Point = %d\n',app.pdSliceRest, app.pdTimePointRest);
            fprintf(fileID,'Volume of Contrast: %0.6f\n',str2double(app.VolumeofContrastmLEditFieldRest.Value));
            fprintf(fileID,'Concentration of Contrast: %0.6f\n',str2double(app.ConcentrationofContrastmglmLEditFieldRest.Value));
            fprintf(fileID,'Radius of Pre-Lesion: %0.3f\n',str2double(app.RadiusPreLesioncmEditFieldRest.Value));
            fprintf(fileID,'Radius of Post-Lesion: %0.3f\n',str2double(app.RadiusPostLesioncmEditFieldRest.Value));
            fprintf(fileID,'Systolic Blood Pressure: %d\n',str2double(app.SystolicBloodPressuremmHgEditFieldRest.Value));
            fprintf(fileID,'FFR: %0.4f\n',app.FFRRest);
            fprintf(fileID,'Flow Velocity of Pre-Lesion: %0.4f\n',str2double(app.PreLesionVelocitycmsEditFieldRest.Value));
            fprintf(fileID,'Flow Velocity of Post-Lesion: %0.4f\n',str2double(app.PostLesionVelocitycmsEditFieldRest.Value));
            fprintf(fileID,'Shear Stress of Pre-Lesion: %0.4f\n',str2double(app.PreShearStressPaEditFieldRest.Value));
            fprintf(fileID,'Shear Stress of Post-Lesion: %0.4f\n',str2double(app.PostShearStressPaEditFieldRest.Value));
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Curve Fitting Info (Rest)\n');
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Pre-Lesion alpha: %0.4f\n',app.alphaARest);
            fprintf(fileID,'Pre-Lesion beta: %0.4f\n',app.betaARest);
            fprintf(fileID,'Pre-Lesion K: %0.4f\n',app.kARest);
            fprintf(fileID,'Pre-Lesion RMSE: %0.4f\n',app.rmseARest);
            fprintf(fileID,'Post-Lesion alpha: %0.4f\n',app.alphaBRest);
            fprintf(fileID,'Post-Lesion beta: %0.4f\n',app.betaBRest);
            fprintf(fileID,'Post-Lesion K: %0.4f\n',app.kBRest);
            fprintf(fileID,'Post-Lesion RMSE: %0.4f\n',app.rmseBRest);
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'End of File\n');
            fprintf(fileID,'======================================\n');
        end

        if (~isempty(app.dicomInfoStressOnly))
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Diagnostic Report (Stress Only)\n');
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Patient Name: %s\n',app.dicomInfoStressOnly.PatientName.FamilyName);
            fprintf(fileID,'Study Date: %s\n',app.dicomInfoStressOnly.StudyDate);
            fprintf(fileID,'Pre-Lesion Coordiante: (%d, %d)\n',app.paStressOnly(3),app.paStressOnly(4));
            fprintf(fileID,'Pre-Lesion Location: Slice = %d, Time Point = %d\n',app.paSliceStressOnly, app.paTimePointsStressOnly);
            fprintf(fileID,'Post-Lesion Coordiante: (%d, %d)\n',app.pdStressOnly(3),app.pdStressOnly(4));
            fprintf(fileID,'Post-Lesion Location: Slice = %d, Time Point = %d\n',app.pdSliceStressOnly, app.pdTimePointsStressOnly);
            fprintf(fileID,'Volume of Contrast: %0.6f\n',str2double(app.ContrastVolumemLEditFieldStressOnly.Value));
            fprintf(fileID,'Concentration of Contrast: %0.6f\n',str2double(app.ContrastConcentrationmglmLEditFieldStressOnly.Value));
            fprintf(fileID,'Radius of Pre-Lesion: %0.3f\n',str2double(app.PrelesionLumenRadiuscmEditFieldStressOnly.Value));
            fprintf(fileID,'Radius of Post-Lesion: %0.3f\n',str2double(app.PostlesionLumenRadiuscmEditFieldStressOnly.Value));
            fprintf(fileID,'Systolic Blood Pressure: %d\n',str2double(app.SystolicBloodPressuremmHgEditFieldStressOnly.Value));
            fprintf(fileID,'FFR: %0.4f\n',app.FFRStressOnly);
            fprintf(fileID,'Flow Velocity of Pre-Lesion: %0.4f\n',str2double(app.PrelesionFlowVelocitycmsEditFieldStressOnly.Value));
            fprintf(fileID,'Flow Velocity of Post-Lesion: %0.4f\n',str2double(app.PostlesionFlowVelocitycmsEditFieldStressOnly.Value));
            fprintf(fileID,'Shear Stress of Pre-Lesion: %0.4f\n',str2double(app.PrelesionShearStressPaEditFieldStressOnly.Value));
            fprintf(fileID,'Shear Stress of Post-Lesion: %0.4f\n',str2double(app.PostlesionShearStressPaEditFieldStressOnly.Value));
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Curve Fitting Info (Stress Only)\n');
            fprintf(fileID,'======================================\n');
            fprintf(fileID,'Pre-Lesion alpha: %0.4f\n',app.alphaAStressOnly);
            fprintf(fileID,'Pre-Lesion beta: %0.4f\n',app.betaAStressOnly);
            fprintf(fileID,'Pre-Lesion K: %0.4f\n',app.kAStressOnly);
            fprintf(fileID,'Pre-Lesion RMSE: %0.4f\n',app.rmseAStressOnly);
            fprintf(fileID,'Post-Lesion alpha: %0.4f\n',app.alphaBStressOnly);
            fprintf(fileID,'Post-Lesion beta: %0.4f\n',app.betaBStressOnly);
            fprintf(fileID,'Post-Lesion K: %0.4f\n',app.kBStressOnly);
            fprintf(fileID,'Post-Lesion RMSE: %0.4f\n',app.rmseBStressOnly);
        end

        fclose(fileID);
    else
        error_msg = 'You do not have permission to write in this directory. Please choose a directory where you have write permission.';
        errordlg(error_msg, 'Error');
        error(error_msg);
    end
end