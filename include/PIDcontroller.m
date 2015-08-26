classdef PIDcontroller < handle
    %PIDcontroller 
    % 
    properties
        P;
        I;
        D;
        lastAccess; % timestamp
    end
    
    properties (SetAccess = private)
        dt;
        sumError;
        lastError;
        feedback;
        accumulatedFeedback;
    end
    
    properties (Access = private)
        deltaT;
    end
    
    properties (Dependent)
        error;
    end

    methods
        function this = PIDcontroller(P,I,D)
            this.P = P;
            this.I = I;
            this.D = D;
            this.lastAccess = tic;
            this.sumError = 0;
            this.lastError = 0;
            this.feedback = 0;
            this.accumulatedFeedback = 0;
        end
        
        function value = get.deltaT(this) 
            value = toc(this.lastAccess);
            this.lastAccess = tic;
        end
        
        function value = get.dt(this)
            value = toc(this.lastAccess);
        end
        
        function set.error(this, error)
           dT = this.deltaT;
           disp(dT);
           this.sumError = dT * error;
           this.feedback = this.P * error * dT + this.I * this.sumError * dT + this.P * (error - this.lastError); 
           this.accumulatedFeedback = this.accumulatedFeedback + this.feedback;
           this.lastError = error;
        end
        
        function value = getFeedback(this, error)
            this.error = error;
            value = this.feedback;
        end
        
        function value = getAccumulatedFeedback(this, error)
            this.error = error;
            value = this.accumulatedFeedback;
        end
    end
    
end

