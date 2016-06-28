% Startscript
% written by Simon D. Schmidt

% stop old instances
stop;
warning off Backtrace; 

% Metadata
versionName = 'Wuhan';
versionNumber = 42;
maintainerContact = 'sd.schmidt@sikos.de';
maintainerName = 'Simon Schmidt';
url = 'http://www.sidash.de/ETS/';
autoupdate = 1;

% add includes
[installpath,~,~] = fileparts(mfilename('fullpath'));
addpath([installpath,'/include/']);
addpath(installpath);    
clc;
% Header
type header;
fprintf('%25s, no. %i                @@    @@@@        @@@@    @@\n', ['Version ',versionName], versionNumber);
fprintf('                                                           @@@@@@@@\n'); 
fprintf('>> Should there be any questions, don''t hesitate to contact <a href="mailto:%s">%s (%s)</a>\n',  maintainerContact, maintainerName, maintainerContact);
fprintf('For further information see the website at <a href="%s">%s</a>\n', url, url);

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
if autoupdate
    disp('>> Checking for Updates')
    newUpdate = 0;
    try
        updateversion = str2double(urlread(versionpath,'Timeout',15));
        if updateversion > versionNumber
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
else
   newUpdate = 0; 
end

if ~(newUpdate == 1)
    % Create new MeasureWindClass_GUI object
    configFile = ([installpath,'/SDSconfig.m']);
    CAMP = MeasureWindClass_GUI(configFile);
end

% Clear Workspace
clear temppath tempfile serverpath updatepath versionpath;
clear updateversion installpath configFile newUpdate;
clear ans;
