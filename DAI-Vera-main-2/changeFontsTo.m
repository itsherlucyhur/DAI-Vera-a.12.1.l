function changeFontsTo(app, newFontName)
    % All Panels
    app.DynamicAngiographicImagingDAIVeraPanel.FontName = newFontName;
    app.OutputParametersPanel.FontName = newFontName;
    app.InputParametersforStressTestPanel.FontName = newFontName;
    app.InputParametersforRestTestPanel.FontName = newFontName;
    
    app.DynamicAngiographicImagingDAIVeraPanel_2.FontName = newFontName;
    app.OutputParametersPanelStressOnly.FontName = newFontName;
    app.InputParametersforStressStudyPanelStressOnly.FontName = newFontName;
    
    app.DynamicAngiographicImagingDAIVeraPanel_3.FontName = newFontName;

    % All Buttons
    app.SetWindowButtonStressOnly.FontName = newFontName;
    app.SetPreLesionButtonStressOnly.FontName = newFontName;
    app.SetPostLesionStressOnly.FontName = newFontName;
    app.OutputButtonStressOnly.FontName = newFontName;
    app.ClearInputsButtonStressOnly.FontName = newFontName;
    app.SetWindowButtonCTAStressOnly.FontName = newFontName;
    app.FitCurvesButtonStressOnly.FontName = newFontName;
    app.FitCurvesButtonStressOnly_2.FontName = newFontName;
    app.ClearOutputsButtonStressOnly.FontName = newFontName;
    
    app.SetWindowButton.FontName = newFontName;
    app.SetPreLesionButton.FontName = newFontName;
    app.SetPostLesionButton.FontName = newFontName;
    app.ComputeButton.FontName = newFontName;
    app.ClearInputsButton.FontName = newFontName;
    app.CopyRestInputsButton.FontName = newFontName;
    app.SetWindowButtonRest.FontName = newFontName;
    app.SetPreLesionButtonRest.FontName = newFontName;
    app.SetPostLesionButtonRest.FontName = newFontName;
    app.OutputButtonRest.FontName = newFontName;
    app.ClearInputsButtonRest.FontName = newFontName;
    app.CopyStressInputsButton.FontName = newFontName;
    app.FitStressCurveButton.FontName = newFontName;
    app.FitCurvesButtonRest.FontName = newFontName;
    app.FitStressCurveButton_2.FontName = newFontName;
    app.FitCurvesButtonRest_2.FontName = newFontName;
    app.ClearOutputsButton.FontName = newFontName;
    
    app.SetWindowButtonSupervised.FontName = newFontName;
    app.ClearButton.FontName = newFontName;
    app.ClearButton_2.FontName = newFontName;
    app.ClearButton_3.FontName = newFontName;
    app.MButton.FontName = newFontName;
    
    % All Input Text Fields
    app.SetWindowLevelStressOnly.FontName = newFontName;
    app.SetWindowWidthStressOnly.FontName = newFontName;
    app.SetWindowLevelCTAStressOnly.FontName = newFontName;
    app.SetWindowWidthCTAStressOnly.FontName = newFontName;
    
    app.SetWindowLevel.FontName = newFontName;
    app.SetWindowWidth.FontName = newFontName;
    app.SetWindowLevelRest.FontName = newFontName;
    app.SetWindowWidthRest.FontName = newFontName;
    
    app.SetWindowLevelSupervised.FontName = newFontName;
    app.SetWindowWidthSupervised.FontName = newFontName;
    
    app.ManualBaselineInputStressOnly.FontName = newFontName;
    app.ManualWashoutInputStressOnly.FontName = newFontName;
    app.ManualBaselineInputStressOnly_2.FontName = newFontName;
    app.ManualWashoutInputStressOnly_2.FontName = newFontName;
    app.ManualBaselineInput.FontName = newFontName;
    app.ManualBaselineInput_2.FontName = newFontName;
    app.ManualWashoutInput.FontName = newFontName;
    app.ManualWashoutInput_2.FontName = newFontName;
    app.ManualBaselineInputRest.FontName = newFontName;
    app.ManualBaselineInputRest_2.FontName = newFontName;
    app.ManualWashoutInputRest.FontName = newFontName;
    app.ManualWashoutInputRest_2.FontName = newFontName;

    app.HUTextArea.FontName = newFontName;
    app.HUTextArea_2.FontName = newFontName;
    
    % All Labels
    app.ContrastVolumemLEditField_2Label.FontName = newFontName;
    app.ContrastConcentrationmgmLLabel.FontName = newFontName;
    
    app.PrelesionLumenRadiuscmLabel_2.FontName = newFontName;
    app.PostlesionLumenRadiuscmEditField_2Label.FontName = newFontName;
	app.SystolicBloodPressuremmHgEditFieldStressOnly.FontName = newFontName;
	app.ArterialBloodPressuremmHgLabel.FontName = newFontName;
    app.FFREditField_2Label.FontName = newFontName;
    app.PrelesionFlowVelocitycmsEditField_2Label.FontName = newFontName;
    app.PostlesionFlowVelocitycmsEditField_2Label.FontName = newFontName;
    app.PrelesionShearStressPaEditField_2Label.FontName = newFontName;
    app.PostlesionShearStressPaEditField_2Label.FontName = newFontName;
    app.StressStudyLabelStressOnly.FontName = newFontName;
    app.CTAStudyLabelStressOnly.FontName = newFontName;
    app.SlicesSliderStressOnlyLabel.FontName = newFontName;
    app.TimePointsSliderStressOnlyLabel.FontName = newFontName;
    app.SlicesSliderCTAStressOnlyLabel.FontName = newFontName;
    app.UnauthorizedUseisProhibitedLabelStressOnly.FontName = newFontName;
    app.SosLabPropertyLabelStressOnly.FontName = newFontName;
    app.StressLabelStressOnly.FontName = newFontName;
    
    app.StressLabelStressOnly.FontName = newFontName;
    app.TimePointsSlider_2Label.FontName = newFontName;
    app.SlicesSliderLabelRest.FontName = newFontName;
    app.TimePointsSliderLabelRest.FontName = newFontName;
    app.StressTestLabel.FontName = newFontName;
    app.RestTestLabel.FontName = newFontName;
    app.SosLabPropertyLabel.FontName = newFontName;
    app.UnauthorizedUseisProhibitedLabel.FontName = newFontName;
    app.StressLabel.FontName = newFontName;
    app.RestLabel.FontName = newFontName;
    app.ContrastVolumemLEditFieldLabel.FontName = newFontName;
    app.ContrastConcentrationmglmLEditFieldLabel.FontName = newFontName;
    app.ConversionFactorHUpermgImLLabel.FontName = newFontName;
    app.PrelesionTracerPercentageEditFieldLabel.FontName = newFontName;
    app.PostlesionTracerPercentageEditFieldLabel.FontName = newFontName;
    app.PrelesionLumenRadiuscmEditFieldLabel.FontName = newFontName;
    app.PostlesionLumenRadiuscmEditFieldLabel.FontName = newFontName;
    app.AorticBloodPressuremmHgEditFieldLabel.FontName = newFontName;
    app.SystolicBloodPressuremmHgEditField_2Label_2.FontName = newFontName;
    app.ContrastVolumemLLabel.FontName = newFontName;
    app.ContrastConcentrationmglmLLabel.FontName = newFontName;
    app.ConversionFactorHUpermgImLLabel_2.FontName = newFontName;
    app.PrelesionTracerPercentageLabel.FontName = newFontName;
    app.PostlesionTracerPercentageLabel.FontName = newFontName;
    app.PrelesionLumenRadiuscmLabel.FontName = newFontName;
    app.PostlesionLumenRadiuscmLabel.FontName = newFontName;
    app.AorticBloodPressuremmHgLabel_2.FontName = newFontName;
    app.SystolicBloodPressuremmHgEditField_2Label_3.FontName = newFontName;
    app.FFREditFieldLabel.FontName = newFontName;
    app.PrelesionFlowVelocitycmsEditFieldLabel.FontName = newFontName;
    app.PostlesionFlowVelocitycmsEditFieldLabel.FontName = newFontName;
    app.PrelesionShearStressPaEditFieldLabel.FontName = newFontName;
    app.PostlesionShearStressPaEditFieldLabel.FontName = newFontName;
    app.PrelesionCFREditFieldLabel.FontName = newFontName;
    app.PostlesionCFREditFieldLabel.FontName = newFontName;
    
    app.SlicesSlider3DLabel.FontName = newFontName;
    app.WashoutLabel.FontName = newFontName;
    app.BaselineLabel.FontName = newFontName;
    app.SetLabel.FontName = newFontName;
    app.WashoutLabel_2.FontName = newFontName;
    app.BaselineLabel_2.FontName = newFontName;
    app.SetLabel_2.FontName = newFontName;
    
    % All Radio Buttons
    app.FrictionFactorButtonGroup.FontName = newFontName;
    app.ArteryTypeButtonGroup.FontName = newFontName;
    app.FrictionFactorButtonGroupRest.FontName = newFontName;
    app.ArteryTypeButtonGroupRest.FontName = newFontName;
    app.ChurchillButton.FontName = newFontName;
    app.ColebrookButton.FontName = newFontName;
    app.CoronaryButton.FontName = newFontName;
    app.AortaButton.FontName = newFontName;
    app.ChurchillButtonRest.FontName = newFontName;
    app.ColebrookButtonRest.FontName = newFontName;
    app.CoronaryButtonRest.FontName = newFontName;
    app.AortaButtonRest.FontName = newFontName;
    
    app.FrictionFactorButtonGroupStressOnly.FontName = newFontName;
    app.ArteryTypeButtonGroupStressOnly.FontName = newFontName;
    app.ChurchillButtonStressOnly.FontName = newFontName;
    app.ColebrookButtonStressOnly.FontName = newFontName;
    app.CoronaryButtonStressOnly.FontName = newFontName;
    app.AortaButtonStressOnly.FontName = newFontName;
    
    % All dropdown menus
    app.SearchROIDropDown.FontName = newFontName;
    app.SearchROIDropDownLabel.FontName = newFontName;
    app.SamplingROIDropDown.FontName = newFontName;
    app.SamplingROIDropDownLabel.FontName = newFontName;
    app.InterpolateCurrentSliceWithDropDown.FontName = newFontName;
    app.InterpolateCurrentSliceWithDropDownLabel.FontName = newFontName;
    app.ROIDropDownRest.FontName = newFontName;
    app.SamplingROILabel.FontName = newFontName;
    app.RestSearchROIDropDown.FontName = newFontName;
    app.SearchROIDropDown_2Label.FontName = newFontName;
    app.InterpolateCurrentSliceWithDropDownRest.FontName = newFontName;
    app.InterpolateCurrentSliceWithDropDown_2Label.FontName = newFontName;
    app.CoronaryArteryDropDown.FontName = newFontName;
    app.CoronaryArteryDropDownLabel.FontName = newFontName;
    app.CoronaryDominanceDropDown.FontName = newFontName;
    app.CoronaryDominanceDropDownLabel.FontName = newFontName;
    app.RestorStressConditionDropDown.FontName = newFontName;   
    app.RestorStressConditionDropDownLabel.FontName = newFontName; 
    app.XrayTubeVoltagekVDropDown.FontName = newFontName;
    app.XrayTubeVoltagekVDropDownLabel.FontName = newFontName; 
    
    app.SamplingROIDropDownStressOnly.FontName = newFontName;
    app.SampleROILabel.FontName = newFontName;
    app.SearchROIDropDownStressOnly.FontName = newFontName;
    app.SearchROIDropDown_2Label_2.FontName = newFontName;
    app.InterpolateCurrentSliceWithDropDownStressOnly.FontName = newFontName;
    app.InterpolateCurrentSliceWithDropDown_2Label_2.FontName = newFontName;
	app.GraphAppearanceDropDown.FontName = newFontName;
	app.GraphAppearanceDropDownLabel.FontName = newFontName;
    
    % All checkboxes
    app.veHeightCheckBox.FontName = newFontName;
    app.veHeightRestCheckBox.FontName = newFontName;
    app.ManualZoomingCheckBox.FontName = newFontName;
    app.ManualZoomingRestCheckBox.FontName = newFontName;
    
    app.ManualZoomingCheckBoxStressOnly.FontName = newFontName;
    app.veHeightCheckBoxStressOnly.FontName = newFontName;
    app.RemovePointPreCheckBoxStressOnly.FontName = newFontName;
    app.RemovePointPostCheckBoxStressOnly.FontName = newFontName;
    app.FlipSliceNumbersCheckBox.FontName = newFontName;
    app.MarkStenosisCheckBox.FontName = newFontName;
    app.EditPointCheckBox.FontName = newFontName;
    app.EditPointCheckBox_2.FontName = newFontName;
    app.MarkBreakerCheckBox.FontName = newFontName;
    app.MarkBranchCheckBox.FontName = newFontName;
    
    % All Sliders
    app.SlicesSlider.FontName = newFontName;
    app.TimePointsSlider.FontName = newFontName;
    app.SlicesSliderRest.FontName = newFontName;
    app.TimePointsSliderRest.FontName = newFontName;
    
    app.SlicesSliderStressOnly.FontName = newFontName;
    app.TimePointsSliderStressOnly.FontName = newFontName;
    app.SlicesSliderCTAStressOnly.FontName = newFontName;
    
    app.SlicesSlider3D.FontName = newFontName;
    
    % All Plot Areas
    app.paPlotArea.FontName = newFontName;
    app.pdPlotArea.FontName = newFontName;
    
    app.paPlotAreaStressOnly.FontName = newFontName;
    app.pdPlotAreaStressOnly.FontName = newFontName;
    app.FFRVsSliceLocation.FontName = newFontName;
end