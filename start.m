% Startscript 2015/05/29
%
% written by Simon D. Schmidt
clc; clear; warning off Backtrace;
[installpath,~,~] = fileparts(mfilename('fullpath')); 
addpath([installpath,'/include/']);

ETSversionName = 'Shanghai';
ETSversionNumber = 25;
ETSmaintainerContact = 'sd.schmidt@sikos.de';
ETSmaintainerName = 'Simon Schmidt';
ETSwebsite = 'http://www.sidash.de/ETS/';

type logo;
fprintf('%s\n',versionheader(ETSversionName,ETSversionNumber,ETSmaintainerContact,ETSmaintainerName,ETSwebsite));
fprintf('\n>> %s\n',modt); % Message of the Day
fprintf('\n>> Changes include:');
type versionchanges

if isunix
    fprintf('\n')
    disp('You''e using a *NIX, Great!')
    disp('Go to http://savagechickens.com to have some fun')
end
    fprintf('\n')

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

clear temppath tempfile serverpath updatepath versionpath;

%%
if ~(newUpdate == 1)
    try
    addpath([installpath,'/include/']);
    addpath(installpath);
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
    
    % Create new MeasureWindClass_GUI object
    configFile = ([installpath,'/SDSconfig.m']);
    sds = MeasureWindClass_GUI(configFile);

    %clc;
    sds.updateGUI
end
    clear newUpdate updateversion
