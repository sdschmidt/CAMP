function string = versionheader(ETSversionName,ETSversionNumber,ETSmaintainerContact,ETSmaintainerName,ETSwebsite)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    string = '';
    string = [string,sprintf('Welcome to ETS Version %s, no %i\n', ETSversionName, ETSversionNumber)];
    string = [string,sprintf('Should there be any questions, don''t hesitate to contact <a href="mailto:%s">%s (%s)</a>\n',  ETSmaintainerContact, ETSmaintainerName, ETSmaintainerContact)];
    string = [string,sprintf('For further information see the website at <a href="%s">%s</a>', ETSwebsite, ETSwebsite)];
end

