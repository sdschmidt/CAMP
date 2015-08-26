classdef PSDcontroller < handle
    %P
    %   Detailed explanation goes here
    
    properties
        P = 1;
        S = 0;
        D = 0;
        dt = 1; % in seconds
        errorHistory = [0 0 0 0];
        feedback = [0 0 0 0];
    end
    
    methods
        function value = getFeedback(this, error)
           this.errorHistory = [error, error(1:3)];
           
        end
    end
    
end

