classdef WindClass < handle
    %The WindClass class constructor handles position of the probe and the percentages of the
    %axial compressor and the side channels.
    %It has the functionality to connect to the arduino.
    %
    % functions:
    % connectArduino()
    % 

    properties (Hidden = true)
        % position values
        current = PositionClass2D([0 0]);
        target  = PositionClass2D([0 0]);
        
        calibrated = 0;
        
        % fan percentages
        percentages = [0 0 0];
        startupTime = 90; % seconds
        
        % Arduino
        port = 'COM3';
        motorX = 1;
        motorY = 2;
        
        % calibration values
        calibrationX = 125/10000; % 125mm correspond to 10000 steps 
        calibrationY = 205/65000; % 205mm correspond to 65000 steps
        
        % pins for pressure sensors
        pinmapPressures = [0 1 2 3 4 5 6 7 8]
        
        % pins for machines
            % writing percentage
                pinAxial = 42;
                pinSide1 = 46;
                pinSide2 = 44;
                pinWrite1 = 51;
                pinWrite2 = 52;    
           % start/stop
                pinStartStopAxial = 11;
                pinStartStopSide1 = 13;
                pinStartStopSide2 = 12;
    end
    
    properties (SetObservable)
        ardBoard;
        status = 0;     % status of WindChannel
        changed = now;  % when did the last change occur?
        interrupt = 0;   
    end
    
    properties (Dependent)
        % position values
        currentPosition
        targetPosition
        
        % percentages axial/side1/side2 % sets in one step
        axial = 0;
        side1 = 0;
        side2 = 0;
        percentage = [0 0 0];
    end
    
    properties (SetAccess = private)
        running = [0 0 0]
    end
    
    properties
        % parameters for measurement
        no_samples = 3;
        start_t = 0;
        delta_t = 0.2;
        p_volt_current = zeros(1,9);
    end
    
    properties (Dependent)
        pressure_current;
    end

    properties  
        % parameters for pressure
        pressure_range = [0 55.16] % mbar
        voltage_range = [102 920]  % range from 0 to 1023
    end
    
    properties 
        % parameters for velocity
        rho = 1.225/100
    end
    
    properties (Dependent)
        velocity;
    end
    
    methods
        function value = get.interrupt(this)
            value = this.interrupt;
        end
        
        function this = connectArduino(this)
            if this.status
                warning('Could not connect, already connected! Set "this.status" to 0 in order to connect again.');
                return;
            end
            
            delete(instrfind({'Port'},{'DEMO'}));
            delete(instrfind({'Port'},{this.port}));
            this.status = 5;
            
            this.changeOccured;
            try
                this.ardBoard = arduino(this.port);
                this.status = 1;
            catch
                try
                warning('using Demo!');
                this.ardBoard = arduino('DEMO');
                this.status = 1;
                catch
                    error('No connection could be established.');
                    this.status = 0;  %#ok<UNRCH>
                end
            end      
             
            if this.status
            ledPin2 = 2;         this.ardBoard.pinMode(ledPin2,'output');
            ledPin3 = 3;         this.ardBoard.pinMode(ledPin3,'output');
            ledPin4 = 4;         this.ardBoard.pinMode(ledPin4,'output');
            ledPin5 = 5;         this.ardBoard.pinMode(ledPin5,'output');
            ledPin6 = 6;         this.ardBoard.pinMode(ledPin6,'output');
            ledPin7 = 7;         this.ardBoard.pinMode(ledPin7,'output');
            ledPin8 = 8;         this.ardBoard.pinMode(ledPin8,'output');
            ledPin9 = 9;         this.ardBoard.pinMode(ledPin9,'output');
            ledPin10 = 10;       this.ardBoard.pinMode(ledPin10,'output');
            ledPin11 = 11;       this.ardBoard.pinMode(ledPin11,'output'); % axial start stop
            ledPin12 = 12;       this.ardBoard.pinMode(ledPin12,'output'); % side2 start stop
            ledPin13 = 13;       this.ardBoard.pinMode(ledPin13,'output'); % side1 start stop
            ledPin42 = 42;       this.ardBoard.pinMode(ledPin42,'output'); % axial percentage
            ledPin44 = 44;       this.ardBoard.pinMode(ledPin44,'output'); % side2 percentage
            ledPin46 = 46;       this.ardBoard.pinMode(ledPin46,'output'); % side1 percentage
            ledPin51 = 51;       this.ardBoard.pinMode(ledPin51,'output'); % general write 1
            ledPin52 = 52;       this.ardBoard.pinMode(ledPin52,'output'); % general write 2
            
            digitalWrite(this.ardBoard, 2, 0);
            digitalWrite(this.ardBoard, 6, 0);
            
                disp('reset percentages');
                this.percentage = this.percentages;
            end
            this.changeOccured;
        end
        
        function string = printStatus(this)
            switch this.status
                case 0
                    string = sprintf('initiated, not connected'); 
                case 1
                    string = sprintf('connected, ready');
                case 2
                    string = sprintf('moving probe');
                case 3
                    string = sprintf('taking measurement');
                case 4
                    string = sprintf('change percentage');
                case 5
                    string = sprintf('waiting for connection');
                case 6
                    string = sprintf('waiting for startup');
                case 7
                    string = sprintf('saving parmeters');
                case 66
                    string = sprintf('ERROR ...');
                otherwise
                    string = sprintf('status unknown ...');
            end
        end
      
        function value = get.currentPosition(this)
            value = this.current.position;
        end
        
        function set.currentPosition(this, value)
            this.current.position = value;
            this.calibrated = 1;
            this.changeOccured;
        end
        
        function value = get.targetPosition(this)
            value = this.target.position;
        end
        
        function set.targetPosition(this, value)
            this.target.position = value;
            this.changeOccured;
        end
        
        function set.no_samples(this,value)
            if ~(isscalar(value) && isnumeric(value))
                warning('Value has to be a scalar, no value set')
            else
                if value >= 0
                this.no_samples = ceil(value);
                else
                    warning('Number of samples has to be positive. no_samples has not been changed.')
                end
            end
            this.changeOccured;
        end
        
        function set.delta_t(this,value)
            if ~(isscalar(value) && isnumeric(value))
                warning('Value has to be a scalar, no value set')
            else
                if value >= 0
                    this.delta_t = value;
                else
                    warning('The time step has to be bigger than zero. delta_t has not been changed');
                end
            end
            this.changeOccured;
        end
        
        function set.start_t(this,value)
            if ~(isscalar(value) && isnumeric(value))
                warning('Value has to be a scalar, no value set')
            else
                if value >= 0
                    this.start_t = value;
                else
                    warning('The initial waiting time has to be bigger than zero. start_t has not been changed');
                end
            end
            this.changeOccured;
        end
        
        function set.axial(this,value) 
            this.percentages(1) = this.check_percentage(value);
            this.writePercentage(1);
            if value == 0
                this.stopAxial;
            end
            this.changeOccured;
        end
        
        function value = get.axial(this)
            value = this.percentages(1);
        end
        
        function set.side1(this,value) 
            this.percentages(2) = this.check_percentage(value);
            this.writePercentage(2);
            if value == 0
                this.stopSide1;
            end
            this.changeOccured;
        end
        
        function value = get.side1(this)
            value = this.percentages(2);
        end
        
        function set.side2(this,value) 
            this.percentages(3) = this.check_percentage(value);
            this.writePercentage(3);
            if value == 0
                this.stopSide2;
            end
            this.changeOccured;
        end
        
        function value = get.side2(this)
            value = this.percentages(3);
        end
        
        function set.percentage(this, value)
            this.isConnected;
            if length(value) == 3
                this.axial = value(1);
                this.side1 = value(2);
                this.side2 = value(3);
            else
                error('provide 3 vector entries. No percentage set.')
            end
        end
        
        function value = get.percentage(this)
            value = this.percentages;
        end
        
        function writePercentage(this,select)
            this.isConnected;
            this.status = 4;
            this.changeOccured;
            if nargin == 1
                this.writePercentage(1);
                this.writePercentage(2);
                this.writePercentage(3);
            else
                switch select
                    case 1
                         RPM_sds(this.axial,this.pinAxial,this.pinWrite1,this.pinWrite2,this.ardBoard); 
                         disp('written Axial')
                    case 2
                         RPM_sds(this.side1,this.pinSide1,this.pinWrite1,this.pinWrite2,this.ardBoard); 
                         disp('written Side 1')
                    case 3
                         RPM_sds(this.side2,this.pinSide2,this.pinWrite1,this.pinWrite2,this.ardBoard);
                         disp('written Side 2')
                    otherwise
                         this.writePercentage; % write all 3
                end
            end
            this.status = 1;
            this.changeOccured;
        end
        
        function set.pressure_range(this, value)
            if length(value) ~= 2 || ~isnumeric(value)
                error('no "this.pressure range" set. Please provide a numeric 2D Vector')
            else
                this.pressure_range = value;
            end
            this.changeOccured;
        end
        
        function set.voltage_range(this, value)
            if length(value) ~= 2 || ~isnumeric(value)
                error('no "this.pressure range" set. Please provide a numeric 2D Vector')
            else
                this.voltage_range = value;
            end
            this.changeOccured;
        end
        
        function value = get.pressure_current(this)
            value =  this.volt2pressure(this.p_volt_current,this.pressure_range,this.voltage_range);
        end  
        
        function value = get.velocity(this)
            value = real(sqrt((this.pressure_current(8) + this.pressure_current(9))/this.rho(1)*2));
        end
        
        function this = startstopMachine(~,pin,bool)
            
        end
        
        function this = startAxial(this)   %% write function start/stop machine
            this.isConnected;
            if this.axial > 0
                digitalWrite(this.ardBoard,this.pinStartStopAxial,1);
                this.running(1) = 1;
                disp('Axial started');
            else
                disp('Axial not started, percentage is 0');
            end
            this.changeOccured;
        end
        
        function this = stopAxial(this)
            this.isConnected;
            digitalWrite(this.ardBoard,this.pinStartStopAxial,0);
            this.running(1) = 0;
            disp('Axial stoped');
            this.changeOccured;
        end
        
        function this = startSide1(this)
            this.isConnected;
            if this.side1 > 0
                digitalWrite(this.ardBoard,this.pinStartStopSide1,1);
                this.running(2) = 1;
                disp('Side1 started');
            else
                disp('Side1 not started, percentage is 0');
            end
            this.changeOccured;
        end
        
        function this = stopSide1(this)
            this.isConnected;
            digitalWrite(this.ardBoard,this.pinStartStopSide1,0);
            this.running(2) = 0;
            disp('Side1 stoped');
            this.changeOccured;
        end
        
        function this = startSide2(this)
            this.isConnected;
            if this.side2 > 0
                digitalWrite(this.ardBoard,this.pinStartStopSide2,1);
                this.running(3) = 1;
                disp('Side2 started');
            else
                disp('Side2 not started, percentage is 0');
            end
            this.changeOccured;
        end
        
        function this = stopSide2(this)
            this.isConnected;
            digitalWrite(this.ardBoard,this.pinStartStopSide2,0);
            this.running(3) = 0;
            disp('Side2 stoped');
            this.changeOccured;
        end
        
        function this = stopAll(this)
            this.stopAxial;
            this.stopSide1;
            this.stopSide2;
            this.changeOccured;
        end
        
        function this = incrementX(this, increment)  %% write function increment machine
            this.isCalibrated; % do not move probe if current position has not been user set
            this.isConnected;
            this.status = 2;
            this.changeOccured
            incrementStepper = round(increment/this.calibrationX);
            incrementLogic = round(increment/this.calibrationX)*this.calibrationX;
            try
                % move motor according to calibration
                Faststeps(this.ardBoard,abs(incrementStepper),this.motorX,-sign(increment));
                % if no error occured, increment logic
                this.current.x = this.current.x + incrementLogic;
            catch
                warning('Too many steps, calling the increment X function with half increment');
                this.incrementX(increment/2);
                this.incrementX(increment/2);
            end
            this.status = 1;
            this.changeOccured;
        end 
        
        function this = incrementY(this, increment)
            this.isCalibrated; % do not move probe if current position has not been user set
            this.isConnected; 
            this.status = 2;
            this.changeOccured
            incrementStepper = round(increment/this.calibrationY);
            incrementLogic = round(increment/this.calibrationY)*this.calibrationY;
            try
                % move motor according to calibration
                Faststeps(this.ardBoard,abs(incrementStepper),this.motorY,sign(increment));
                 % if no error occured, increment logic
                this.current.y = this.current.y + incrementLogic;
            catch
                warning('Too many steps, calling the increment Y function with half increment');
                this.incrementY(increment/2);
                this.incrementY(increment/2);
            end
            this.status = 1;
            this.changeOccured;
        end
        
        function this = moveToTargetX(this)
            d = this.target.x - this.current.x;
            fprintf('Moving to x-target: %10.5f\n', this.target.x)
            this.incrementX(d);
        end
        
        function this = moveToTargetY(this)
            d = this.target.y - this.current.y;
            fprintf('Moving to y-target: %10.5f\n', this.target.y)
            this.incrementY(d);
        end
        
        function takeMeasurement(this,samples,start_t,delta_t)
           this.isConnected;
           if nargin == 1
               this.takeMeasurement(this.no_samples,this.start_t,this.delta_t)
           else
           this.status = 3;
           this.changeOccured;
           fprintf('measuring with %i samples with and %.3f s timesteps, after waiting for %.3f s ... \n',samples,delta_t,start_t);       
               tic;
               if start_t
                   pause(start_t);
               end
               this.p_volt_current = measure_now(this.ardBoard,samples,delta_t,this.pinmapPressures); toc;
               disp('measurement taken.')
           this.status = 1;
           this.changeOccured;
           end
        end    
        
        function out = volt2pressure(~,p_volt,pressure_range,voltage_range) 
            % convert from voltage to corresponding pressure
            % to use a bidirectional measurement, use pressure_range = [-p
            % p], where p denotes the maximum pressure. For unidirectional,
            % use pressure_range = [0 p]. 
            % Arduino has input from 0.5 to 4.5 V, so that voltage_range =
            % [0.5 4.5]
            out = (p_volt - min(voltage_range))/(max(voltage_range)-min(voltage_range))*(max(pressure_range)-min(pressure_range))+min(pressure_range);
        end
        
        function out = check_percentage(~,value) % should be private
            if ~(isscalar(value) && isnumeric(value))
                error('Value has to be a scalar, no value set');
            else
                out = value;
                if value < 0
                    out = 0;
                    warning('Value has to be between one and zero, adjusted to 0')
                end
                if value > 1
                    out = 1;
                    warning('Value has to be between one and zero, adjusted to 1')
                end
                
            end
        end
        
        function isConnected(this)
            if ~this.status
                error('not connected. Try to connect using "this.connectArduino"');
            end
        end
        
        function isCalibrated(this)
            if ~this.calibrated
                error('Please set the current position of the probe');
            end
        end
             
        function idle = isIdle(this)
            if this.status == 1
                idle = true;
            else
                idle = false;
            end
        end
                
        function changeOccured(this)
            this.changed = now;
        end
    end
end

