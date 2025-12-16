function brChangeViewMode(app, viewmode)
    if (strcmp(viewmode, 'Dark'))
        app.DefineBreakerUIFigure.Color = app.colorBackgroundDarkMode;
        app.MarkbreakerpointsButton.BackgroundColor = app.colorBackgroundDarkMode;
        app.MarkbreakerpointsButton.FontColor = app.colorRegularFontDarkMode;
        
        app.NumberofbreakersDropDown.BackgroundColor = app.colorBackgroundDarkMode;
        app.NumberofbreakersDropDownLabel.FontColor = app.colorRegularFontDarkMode;
        app.NumberofbreakersDropDown.FontColor = app.colorRegularFontDarkMode;
        
        app.Slicenumberforbreaker1EditField.BackgroundColor = app.colorTextFieldDarkMode;
        app.Slicenumberforbreaker1EditFieldLabel.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker1EditField.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker2EditField.BackgroundColor = app.colorTextFieldDarkMode;
        app.Slicenumberforbreaker2EditFieldLabel.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker2EditField.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker3EditField.BackgroundColor = app.colorTextFieldDarkMode;
        app.Slicenumberforbreaker3EditFieldLabel.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker3EditField.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker4EditField.BackgroundColor = app.colorTextFieldDarkMode;
        app.Slicenumberforbreaker4EditFieldLabel.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker4EditField.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker5EditField.BackgroundColor = app.colorTextFieldDarkMode;
        app.Slicenumberforbreaker5EditFieldLabel.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker5EditField.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker6EditField.BackgroundColor = app.colorTextFieldDarkMode;
        app.Slicenumberforbreaker6EditFieldLabel.FontColor = app.colorRegularFontDarkMode;
        app.Slicenumberforbreaker6EditField.FontColor = app.colorRegularFontDarkMode;
        
    elseif(strcmp(viewmode, 'Normal'))
        
        app.DefineBreakerUIFigure.Color = app.colorBackgroundNormalMode;
        app.MarkbreakerpointsButton.BackgroundColor = app.colorBackgroundNormalMode;
        app.MarkbreakerpointsButton.FontColor = app.colorRegularFontNormalMode;
        
        app.NumberofbreakersDropDown.BackgroundColor = app.colorBackgroundNormalMode;
        app.NumberofbreakersDropDownLabel.FontColor = app.colorRegularFontNormalMode;
        app.NumberofbreakersDropDown.FontColor = app.colorRegularFontNormalMode;
        
        app.Slicenumberforbreaker1EditField.BackgroundColor = app.colorTextFieldNormalMode;
        app.Slicenumberforbreaker1EditFieldLabel.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker1EditField.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker2EditField.BackgroundColor = app.colorTextFieldNormalMode;
        app.Slicenumberforbreaker2EditFieldLabel.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker2EditField.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker3EditField.BackgroundColor = app.colorTextFieldNormalMode;
        app.Slicenumberforbreaker3EditFieldLabel.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker3EditField.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker4EditField.BackgroundColor = app.colorTextFieldNormalMode;
        app.Slicenumberforbreaker4EditFieldLabel.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker4EditField.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker5EditField.BackgroundColor = app.colorTextFieldNormalMode;
        app.Slicenumberforbreaker5EditFieldLabel.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker5EditField.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker6EditField.BackgroundColor = app.colorTextFieldNormalMode;
        app.Slicenumberforbreaker6EditFieldLabel.FontColor = app.colorRegularFontNormalMode;
        app.Slicenumberforbreaker6EditField.FontColor = app.colorRegularFontNormalMode;
    end
end