classdef MeasureWindClass < WindClass
%MeasureWindClass handles measuring in the Windtunnel. It inherits from
%WindClass, which controlls the windchannel and gets the pressures for
%the pressure sensor.
%written by Simon D. Schmidt on May 2015

    properties (Access = private, Hidden = true)
        start = PositionClass2D([0 0]);         
        currentPoint = [0 0];                   % the logical point where to probe is located
        
            % filenames
        filePosition = 'position.dat';
        filePoints = 'points.dat';
        fileMeasuredPoints = 'measuredPoints.dat';
        filePvolt = 'p_volt.dat';
        filePressure = 'pressure.dat';
        fileVelocity = 'velocity.dat';
        fileParameters = 'parameters.dat';
        fileLossC = 'zeta.dat';
        fileW2W1 = 'velocityRatio.dat';
        fileAngles = 'angles.dat';
        
        noParameters = 18;
            
            % installation directory
        installdir = cd;
    end
    
    properties (SetAccess = private, Hidden = true, SetObservable)
        measuredPosition                        % Variables prefixed with 'measured' contain the up to this point measured values
        measuredPoints                          % for Position, Points, Voltage, Pressure, Velocity, as well as the from the
        measuredPvolt                           % calibration data and measurement probe dependent values LossC, the velocity
        measuredPressure;                       % ration W2W1 and the Angles at which the stream hits the probe.
        measuredVelocity;
        
        measuredLossC;
        measuredW2w1; 
        measuredAngles; 
        
        elapsed_time = 0;                       % constantly incremented value which measures the time after starting the measurement
        measurementDefined = 0;                 % 0: no measurement loaded, 1: measurement loaded, 2: measurement started
    end
    
    properties (Hidden = true)
        notesTemplate = '';                     % template from which to create notes when a measurement is created
    end
    
    properties
        name = 'noname';                        % the name of the measurement
        basedir = [cd,'/Messdaten'];            % the location of the measurement data
        calibrationSource = [cd,'/calibration'];% the location from where to load the calibration data from
        calibsubfolder = 'calibration/';        % the calibration subfolder in the savelocation directory
        points = [0 0];                         % the points which should be measured
        save_precision = 6;                     % the precision with which to save the measured values
                
        notes = '';                             % notes for the measurement
    end
    
    properties (Dependent)
        parameters;                             % dependent variable to set and get parameters. see the function set.parameters, get.parameters
        savelocation;                           % the savelocation constructed from name and basedor properties
        caliblocation;                          % the folder where the calibration data is saved
        timestamp;                              % the timestamp at the creation of the measurement
    
        currentLossC;                           % Loss Coefficient 
        currentW2w1;                            % Velocity Ratio   
        currentAngles;                          % Gamma, Beta, all obtained using the calibration data and the postprocessing function
    end
    
     properties (Hidden = true)
         % Calibration files for the 5 hole measurement probe
         % adjust the function 'loadCalibration' and 'postprocessing' to
         % change it to e.g a 7 hole measurement probe. 
         k_gamma_n;
         k_beta_n;
         gamma_n;
         beta_n;
         k_pt_n;
         k_p_n;
     end
     
    methods
        function value = get.currentLossC(this)
             [ value, ~, ~, ~ ] = postprocessing( this.pressure_current, this.k_gamma_n, this.k_beta_n, this.gamma_n, this.beta_n, this.k_pt_n, this.k_p_n);
        end
        
        function value = get.currentW2w1(this)
             [ ~, value, ~, ~ ] = postprocessing( this.pressure_current, this.k_gamma_n, this.k_beta_n, this.gamma_n, this.beta_n, this.k_pt_n, this.k_p_n);
        end
        
        function value = get.currentAngles(this)
             [ ~, ~, g, b ] = postprocessing( this.pressure_current, this.k_gamma_n, this.k_beta_n, this.gamma_n, this.beta_n, this.k_pt_n, this.k_p_n);
             value = [g, b];
        end
        
        function value = get.savelocation(this)
            value = [this.basedir,'/', this.name, '/'];
        end
        
        function value = get.timestamp(~)
            value = datestr(now,'yyyymmddhhMMss');
        end
        
        function value = get.caliblocation(this)
            value = [this.savelocation,this.calibsubfolder];
        end
        
        function createPoints(this, xPoints, yPoints)
            this.points = zeros(length(xPoints)*length(yPoints),2);
            i = 0;
            for y = yPoints
                for x = xPoints
                    i = i + 1;
                    this.points(i,:) = [x y]; 
                end
            end
            this.changeOccured;
        end
        
        function newMeasurement(this, name, putTimestamp)
            if nargin == 2
                this.name = name;
            end
            
            if nargin == 3 && putTimestamp
                this.name = [this.timestamp,'_',name];
            end
                
            if ~exist(this.savelocation,'dir')
                mkdir(this.savelocation);
                fprintf('the savelocation is %s \n',this.savelocation);
                if ~this.status
                    this.connectArduino;
                end
                this.saveParameters;
                this.savePoints;
                this.notes = this.notesTemplate;
                this.saveNotes;
                this.measurementDefined = 1;
            else
                error('no savelocation could be created. Measurment already exists');
            end
            
            this.createCalibration;
            this.loadCalibration;
            this.measuredPosition = [];
            this.measuredPoints = [];
            this.measuredPvolt = [];
            this.measuredPressure = [];
            this.measuredVelocity = [];  
            this.measuredLossC = [];
            this.measuredW2w1 = [];
            this.measuredAngles = [];
            this.elapsed_time = 0;
            this.changeOccured; 
        end
        
        function createCalibration(this)
            %try
                copyfile(this.calibrationSource,this.caliblocation);
            %catch
            %    warning('no calibration data copied. Postprocessing may not be possible');
            %end
            fprintf('Calibration data saved to %s\n',this.caliblocation);
        end
        
        function loadCalibration(this)
            try
            this.k_gamma_n = load([this.caliblocation,'k_gamma_n.dat']);
            this.k_beta_n = load([this.caliblocation,'k_beta_n.dat']);
            this.gamma_n = load([this.caliblocation,'gamma_n.dat']);
            this.beta_n = load([this.caliblocation,'beta_n.dat']);
            this.k_pt_n = load([this.caliblocation,'k_pt_n.dat']);
            this.k_p_n = load([this.caliblocation,'k_p_n.dat']);
            fprintf('Calibration data loaded from %s\n',this.caliblocation);
            catch
                warning('no Calibration data could be loaded from location %s\n',this.caliblocation);
            end
        end
        
        function loadMeasurement(this, name)
            if nargin == 2
                this.name = name;
            end
            
            if ~this.status
                this.connectArduino;
            end
            
            if exist(this.savelocation,'dir')
                try
                	this.loadData
                catch
                    warning('no measurement data found');
                end
                
                try
                    this.loadParameters
                catch
                    warning('no parameters found');
                end
                
                try
                    this.loadCalibration;
                catch
                    warning('no calibration found');
                end
                
                try
                    this.loadPoints
                catch
                    warning('no points found');
                end
                
                try
                    this.loadNotes
                catch
                    warning('no notes found');
                end

                this.measurementDefined = 1;
            else
                this.measurementDefined = 0;
                error('Measurement could not be found');
            end
            this.changeOccured;
        end
        
        function closeMeasurement(this)
            this.measuredPosition = [];
            this.measuredPoints = [];
            this.measuredPvolt = [];
            this.measuredPressure = [];
            this.measuredVelocity = [];  
            this.measuredLossC = [];
            this.measuredW2w1 = [];
            this.measuredAngles = [];
            this.measurementDefined = 0;
            this.elapsed_time = 0;
            this.status = 1;
            this.changeOccured;        
        end
        
        function clearMeasurement(this)
            recycle('on')
            delete([this.savelocation,this.filePosition]);
            delete([this.savelocation,this.filePvolt]);
            delete([this.savelocation,this.filePressure]);
            delete([this.savelocation,this.fileVelocity]);
            delete([this.savelocation,this.fileMeasuredPoints]); 
            delete([this.savelocation,this.fileLossC]);
            delete([this.savelocation,this.fileW2W1]);
            delete([this.savelocation,this.fileAngles]);
            this.measuredPosition = [];
            this.measuredPoints = [];
            this.measuredPvolt = [];
            this.measuredPressure = [];
            this.measuredVelocity = [];  
            this.measuredLossC = [];
            this.measuredW2w1 = [];
            this.measuredAngles = [];
            fprintf('Cleared data from location: %s\n',this.savelocation);
        end
        
        function list = getMeasurementList(this)            
            try
                D = dir(this.basedir);
                for i = 1:length(D)
                    if ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..') && D(i).isdir == 1
                        try
                            list{end + 1}= D(i).name; %#ok size of list is unknown and small, therefore no preallocation can take place
                        catch
                            list{1} =  D(i).name;
                        end
                    end
                end
                if ~exist('list','var')
                    list{1} = '(!) no measurements found';
                    warning('No measurments found')
                end
            catch
                list{1} = '(!) no measurements found';
                warning('No measurments found')
            end
        end
        
        function startMeasurement(this)
            this.isCalibrated; % do not start measurement routine if current position has not been user set
            if this.measurementDefined % only start if a measurement is loaded
                % start measurement
                this.measurementDefined = 2;
                % start windchannel
                this.startup

                % saveParameters, Points and Notes
                this.saveParameters; 
                this.savePoints;
                this.saveNotes;
                
                % load Data
                this.loadData;
                this.loadCalibration;
                
                % measure loop
                this.measureLoop;
                disp('Measurement Loop finished')
                this.stopAll;
                
                % end measurement
                this.measurementDefined = 1;
                this.changeOccured;
            else
                warning('no data saved. this.measurmentDefine = 0. Please assign a savelocation with eg. using "this.newMeasurement" ')
            end
        end
        
        function measured = isMeasured(this, point)
            measured = 0;
            for current = this.measuredPoints'
                if norm(current' - point',2) == 0
                    measured = 1;
                end
            end
        end
        
        function measureLoop(this)
            this.interrupt = 0; % reset interrupt;
            for point = this.points'
                st = tic;
                if ~this.isMeasured(point) % if the point is not yet measured
                    this.currentPoint = point'; 
                    this.targetPosition = point; % move to this point
                    this.moveToTargetX;
                    this.moveToTargetY;
                    fprintf('Reached %7.4f, %7.4f \n',this.currentPosition);
                    this.takeMeasurement;        % and take a measurement.
                    while ( this.velocityControlActive && ~this.velocityInTolerance)
                        %if the velocity control is active and not velocity is not in
                        %the given tolerance, then control it and take the
                        %measurement again
                        this.PIDcontrolVelocity()   % start PID-controller
                        if this.interrupt; this.interrupt = 0; this.status = 1; return; end
                        this.takeMeasurement        % take Measurement and check again
                    end
                    this.saveDataAppend; % save all Data
                    
                    % replace with an update function for measured Values
                    this.loadData; % update Data from saved in function saveDataAppen
                    fprintf('\n');
                else
                    fprintf('The point %f, %f is already measured \nskipping ... \n', ...
                        point(1), point(2));
                end

                
                this.elapsed_time = this.elapsed_time  + toc(st);
                if this.interrupt; this.interrupt = 0; this.status = 1; return; end
            end
            this.changeOccured;
        end
        
        function emergencyStop(this)
            this.stopAll;
            this.measurementDefined = 1;
        end
        
        function saveDataAppend(this)
            if this.savelocation
            s = this.save_precision; 
            dlmwrite([this.savelocation,this.filePosition],[this.current.x,this.current.y,this.elapsed_time],'precision',s,'-append');
            dlmwrite([this.savelocation,this.filePvolt],this.p_volt_current,'precision',s,'-append');
            dlmwrite([this.savelocation,this.filePressure],this.pressure_current,'precision',s,'-append');
            dlmwrite([this.savelocation,this.fileVelocity],this.velocity,'precision',s,'-append');
            dlmwrite([this.savelocation,this.fileMeasuredPoints],this.currentPoint,'precision',s,'-append');
            dlmwrite([this.savelocation,this.fileLossC],this.currentLossC,'precision',s,'-append');
            dlmwrite([this.savelocation,this.fileW2W1],this.currentW2w1,'precision',s,'-append');
            dlmwrite([this.savelocation,this.fileAngles],this.currentAngles,'precision',s,'-append');
            
            fprintf('Appended data using location: %s\n',this.savelocation);
            else
                warning('no data saved. Please assign a savelocation with eg. using "this.newMeasurement" ')
            end
        end
        
        function loadData(this)
            try
                this.measuredPosition = dlmread([this.savelocation,this.filePosition]);
                this.measuredVelocity = dlmread([this.savelocation,this.fileVelocity]);
                this.measuredPvolt = dlmread([this.savelocation,this.filePvolt]);
                this.measuredPressure = dlmread([this.savelocation,this.filePressure]);
                this.measuredPoints = dlmread([this.savelocation,this.fileMeasuredPoints]);
                this.measuredLossC = dlmread([this.savelocation,this.fileLossC]);
                this.measuredW2w1 = dlmread([this.savelocation,this.fileW2W1]);
                this.measuredAngles = dlmread([this.savelocation,this.fileAngles]);
            catch
                warning('No measurement Data found');
            end
            checkDataLength(this);
            this.changeOccured;
        end
        
        function saveParameters(this, file)
            if nargin == 1
                file = [this.savelocation,this.fileParameters];
            end
            
            try
                 dlmwrite(file,this.parameters,'precision',this.save_precision);
                 fprintf('Saved Parameters using location: %s\n', this.savelocation);
            catch
                 warning('no Parameters saved. Please assign a valid savelocation with eg. using "this.newMeasurement" ')
            end
            this.changeOccured;
        end
       
        function loadParameters(this, file)
            if nargin == 1
                file = [this.savelocation,this.fileParameters];
            end
 
            try
                parameters = dlmread(file);
            catch
                error('no Parameters found')
            end
            
            if numel(parameters) < this.noParameters
                parameters(numel(parameters):this.noParameters) = 0;
            end
            
            this.parameters = parameters(1:this.noParameters);
            disp('Parameters loaded');
            this.changeOccured;
        end
        
        function savePoints(this, file)
            if nargin == 1
                file = [this.savelocation,this.filePoints];
            end
            
            try
                 dlmwrite(file,this.points,'precision',this.save_precision);
                 fprintf('Saved Points using location: %s\n', this.savelocation);
            catch
                 warning('No Points saved. Please assign a valid savelocation with eg. using "this.newMeasurement" ')
            end
            this.changeOccured;
        end
        
        function loadPoints(this, file)
            if nargin == 1
                file = [this.savelocation,this.filePoints];
            end
            
            try
                pointsl = dlmread(file);
            catch
                error('no Points found')
            end
            
            this.points = pointsl;
            disp('Points loaded')
            this.changeOccured;
        end
        
        function saveNotes(this,file)
            if nargin == 1
                file = [this.savelocation,'notes.dat'];
            end
           
            try 
                fid = fopen(file,'wt');
                v = cellstr(this.notes);
                fprintf(fid, '%s\n', v{:});
                fclose(fid);
                fprintf('Saved Notes using location: %s\n', this.savelocation);
            catch
                warning('No Notes saved. Please assign a valid savelocation with eg. using "this.newMeasurement" ')
           
            end
            this.changeOccured;
        end
        
        function loadNotes(this, file)
            if nargin == 1
                file = [this.savelocation,'notes.dat'];
            end
            
            try
                fid = fopen(file);
                string = textscan(fid,'%s','delimiter','\n');
                this.notes = string{:};
                fclose(fid);
            catch
                this.notes = this.notesTemplate;
                this.saveNotes;
                warning('no notes found, tried to create notes ...');    
            end
            this.changeOccured
        end
        
        function value = get.parameters(this)
            value(1:3) = this.percentage; 
            value(4:6) = this.running; 
            value(7) = this.no_samples;
            value(8) = this.delta_t;
            value(9:10) = this.pressure_range;
            value(11:12) = this.voltage_range;
            value(13) = this.rho;
            value(14) = this.elapsed_time;
            value(15) = this.start_t;
            value(16) = this.velocityTarget;
            value(17) = this.velocityTargetTolerance;
            value(18) = this.velocityControlActive;
            
        end
        
        function set.parameters(this, value)
            this.percentage = value(1:3);
            this.no_samples = value(7);
            this.delta_t = value(8);
            this.pressure_range = value(9:10);
            this.voltage_range = value(11:12);
            this.rho = value(13);
            this.elapsed_time = value(14);
            this.start_t = value(15);
            this.velocityTarget = value(16);
            this.velocityTargetTolerance = value(17);
            this.velocityControlActive = value(18);
            this.changeOccured;
        end
        
        function s = checkDataLength(this)
            [a1,~] = size(this.measuredPosition);
            [a2,~] = size(this.measuredPvolt);
            [a3,~] = size(this.measuredPressure);
            [a4,~] = size(this.measuredVelocity);
            if (a1 == a2) && (a2 == a3) && (a3 == a4)
                s = 1;
            else
                s = 0;
                warning('Datalenght does not fit. Loaded Data may be corrupted');
            end
        end
                
        function startup(this)
            
            this.startSide1;
            this.startSide2;
            if ~this.velocityControlActive
                this.startAxial;
                this.waitForStartup;
            else
                this.PIDcontrolVelocity;    
            end
        end
        
        function waitForStartup(this)
            this.status = 6;
            this.changeOccured;
            fprintf('Waiting for Startup of compressor ')
            tic
            while toc < this.startupTime
                pause(2)
                fprintf('.');
                if this.interrupt; this.interrupt = 0; this.status = 1; return; end % quit on interrupt
            end
            fprintf('\n');
            this.status = 1;
            this.changeOccured;
        end
    end  
end

