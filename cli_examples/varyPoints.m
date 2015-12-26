%% initiating CAMP
clear; clc; start; %% start
backend = CAMP.MWC;     % setting backend handle
%backend.connectArduino; % connecting to arduino
%%

n_points = 100;
s = 0:1/(n_points-1):1;
x = s*200;
y = 400-300*(s-0.5).^2;
backend.points = [x',y'];
CAMP.updateGUI;