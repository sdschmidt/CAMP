% Startscript
% ETS
% written by Simon D. Schmidt
ETSversionName = 'Shanghai';
ETSversionNumber = 37;
ETSmaintainerContact = 'sd.schmidt@sikos.de';
ETSmaintainerName = 'Simon Schmidt';
ETSwebsite = 'http://www.sidash.de/ETS/';

% stop old instances
stop;
warning off Backtrace; 

% add includes
[installpath,~,~] = fileparts(mfilename('fullpath'));
addpath([installpath,'/include/']);
addpath(installpath);    
clc;
% Header
type header;
fprintf('%26s, no. %i     @@    @@@@        @@@@    @@\n', ['Version ',ETSversionName], ETSversionNumber);
fprintf('                                                 @@@@@@@@\n'); 
fprintf('>> Should there be any questions, don''t hesitate to contact <a href="mailto:%s">%s (%s)</a>\n',  ETSmaintainerContact, ETSmaintainerName, ETSmaintainerContact);
fprintf('For further information see the website at <a href="%s">%s</a>\n', ETSwebsite, ETSwebsite);

% Message of the day
fprintf('\n>> %s\n',modt);

% Version changes
fprintf('\n>> Version Changes');
type versionchanges
fprintf('\n')

temppath = tempdir;
tempfile = [temppath,'updateETS.m'];
serverpath = 'http://www.sidash.de/ETS/';
updatepath = [serverpath,'update.m'];
versionpath = [serverpath,'version'];
 
disp('>> Checking for Updates')
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
            disp('Type start to start the program');
        catch
            disp(['Could not update ',updatepath]);
        end
    case -1
        disp('Checking for updates failed, continuing ...')
end

if ~(newUpdate == 1)
    % Create new MeasureWindClass_GUI object
    configFile = ([installpath,'/SDSconfig.m']);
    sds = MeasureWindClass_GUI(configFile);
end

% Clear Workspace
clear temppath tempfile serverpath updatepath versionpath;
clear updateversion installpath configFile newUpdate;
clear ans;
