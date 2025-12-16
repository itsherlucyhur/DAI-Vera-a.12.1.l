function pdfFileName = convertDocxToPdf(directory, docxFileName)

    logDAI('Inside convertDocxToPdf');
    
    pdfFileName = strcat(directory, '\Documents\User Manual.pdf');
    % wordApplication = actxserver('Word.Application');
    % doc = wordApplication.Documents.Open(docxFileName);
    % doc = docx(docxFileName);
    % doc.ExportAsFixedFormat(pdfFileName, 17, false);
    % doc.Close;
    % wordApplication.Quit;
    system(pdfFileName);
    
    % logDAI('Successfully converted to PDF');
    logDAI('Successfully opened PDF');
end