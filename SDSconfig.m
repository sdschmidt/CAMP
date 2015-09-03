% Configuration File 
% is executed once at startup
% 'this' refers to the created 'MeasureWindClass_GUI' class object
% 'this.MWC' refers to the backend Object of class 'MeasureWindClass'
%
% restart the program to see effect in changes

% Where to save the Measurement Data
this.MWC.basedir = '/Users/sdschmidt/Desktop/MessdatenAlex/';

% Where to load the Calibration from;
this.MWC.calibrationSource = [cd,'/calibration'];

% Arduino Port
this.MWC.port = 'COM3';
% Pressure Sensors
this.MWC.pressure_range =  [-22 22];             % in mbar
this.MWC.voltage_range  =  [102.3 920.7];            % values 0 to 2023
this.MWC.pinmapPressures = [0 1 2 3 4 5 6 7 8];  % Which pins of Arduino to use.
this.MWC.pinmapNegative =  [1 1 1 1 1 1 1 1 1];  % 1 for positive sign, -1 for negative sign, use if connections on e.g. unidirectional sensor are switched (fuer vertauschte druckanschluesse bei unidirektionalen Drucksensoren)
% those pins correspond to
% in postprocessing.m:
%         Nr      used as
%         1       pressure hole 1, 5 hole probe       
%         2       pressure hole 2, 5 hole probe
%         3       pressure hole 3, 5 hole probe
%         4       pressure hole 4, 5 hole probe
%         5       pressure hole 0 (middle hole), 5 hole probe
%         6       unused
%         7       unused
%         8       static pressure, prandtl probe
%         9       dynamic pressure, prandtl probe

% Pins for Machines
% writing percentage
this.MWC.pinAxial = 42;
this.MWC.pinSide1 = 46;
this.MWC.pinSide2 = 44;
this.MWC.pinWrite1 = 51;
this.MWC.pinWrite2 = 52;    
% start/stop
this.MWC.pinStartStopAxial = 11;
this.MWC.pinStartStopSide1 = 13;
this.MWC.pinStartStopSide2 = 12;

% Arduino Stepper Motors
this.MWC.motorX = 1;
this.MWC.motorY = 2;
this.MWC.calibrationX = 125/10000; % 125mm correspond to 10000 steps 
this.MWC.calibrationY = 205/65000; % 205mm correspond to 65000 steps

% Velocity of Wind Tunnel
this.MWC.rho = 1.225/100;

% Template for the Notes
s{1} = 'Notes';
s{2} = 'angle_probe = ';
s{3} = 'angle_blade = ';
s{4} = 'angle_box_z = ';
s{5} = 'angle_box_y = ';
s{6} = 'angle_arm_y = ';
this.MWC.notesTemplate = s; clear s;
