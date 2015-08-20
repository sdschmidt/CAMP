% Startscript
% ETS
% written by Simon D. Schmidt
clc;
warning off Backtrace;

ETSversionName = 'Shanghai';
ETSversionNumber = 26;
ETSmaintainerContact = 'sd.schmidt@sikos.de';
ETSmaintainerName = 'Simon Schmidt';
ETSwebsite = 'http://www.sidash.de/ETS/';

fprintf('Welcome to Version %s!\nThe Version Number is %i \n', ETSversionName, ETSversionNumber)
fprintf('Should there be any questions, don''t hesitate to contact <a href="mailto:%s">%s (%s)</a>\n',  ETSmaintainerContact, ETSmaintainerName, ETSmaintainerContact);
fprintf('For further information see the website at <a href="%s">%s</a>\n\n', ETSwebsite, ETSwebsite);

switch datestr(now,'ddd')
    case 'Mon'
        fprintf('Heute ist Montag. \nIch w?nsche pers?nlich einen guten Start in die Woche!');
    case 'Tue'
        fprintf('Heute ist Dienstag. Wer Montage hasst, wird Dienstage m?gen!');
    case 'Wed'
        fprintf('Heute ist Mittwoch. Dies bedeutet Halbzeit!');
    case 'Thu'
        fprintf('Donnerstag. Der Tag der Studentenfeiern. \nHeute ist Happy Hour von 21.00 bis 22.00 Uhr!');
    case 'Fri'
        fprintf('Heute ist Freitag. Und das bedeutet morgen ist Wochenende!');
    case 'Sat'
        fprintf('Samstag. F?r viele Leute ein Arbeitstag. Aber dennoch Wochenende!');
    case 'Sun'
        fprintf('Sonntag. Der Tag der Ruhe und Besinnlichlkeit.\nG?nnen auch Sie sich ein bisschen Ruhe! \nOder Ich empfehle: ');
end
fprintf('\n\n');
fprintf('Version changes include: setting file variables in WindClass class constructor\n');
fprintf('Overhauling function measure_now()\n');
fprintf('Overhauling function WindClass.writePercentages()\n');
fprintf('Preparation and Object for future PIDcontrol.m class Object in MeasureWindClass\n');
fprintf('Moving WindClass.waitForStartup() to MeasureWindClass class constructor due to concept\n\n')

if isunix
    disp('You''e using a *NIX, Great!')
    disp('Go to http://savagechickens.com to have some fun')
    fprintf('\n\n')
end

installpath = cd;
temppath = tempdir;
tempfile = [temppath,'updateETS.m'];
serverpath = 'http://www.sidash.de/ETS/';
updatepath = [serverpath,'update.m'];
versionpath = [serverpath,'version'];

path(pathdef); 
try
    sds.MWC.stopAll;
    delete(sds);
    clear sds;
catch
end

disp('Checking for Updates')
newUpdate = 0;
try
    updateversion = str2double(urlread(versionpath));
    if updateversion > ETSversionNumber
        newUpdate = 1;
    end
catch
    newUpdate = -1;
end

switch newUpdate
    case 0
        disp('No new updates available ...')
    case 1
        disp('New updates available, updating ...')
        try
            urlwrite(updatepath,tempfile);
        catch
            disp(['Could not retrieve ',updatepath]);
        end
        
        try
            addpath(temppath);
            updateETS(installpath);
            delete(tempfile);
            disp('Update successfull');
            disp('Type start to start the program');
        catch
            disp(['Could not update ',updatepath]);
        end
    case -1
        disp('Checking for updates failed, continuing ...')
end

clear installpath temppath tempfile serverpath updatepath versionpath;

%%
if ~(newUpdate == 1)
    try
    addpath([cd,'/include/']);
    addpath(cd);
    catch
        error('Path ./include not found. Make sure you are in the directory of the start-file')
    end

    % Try to stop
    try
        sds.MWC.stopAll;
        delete(sds);
        clear sds;
    catch
    end

    % Try to delete previous
    try
        delete(sds);
        clear sds;
    catch
    end
    
    clear;
    % Create new MeasureWindClass_GUI object
    configFile = ([cd,'/SDSconfig.m']);
    sds = MeasureWindClass_GUI(configFile);

    %clc;
    sds.updateGUI
end
