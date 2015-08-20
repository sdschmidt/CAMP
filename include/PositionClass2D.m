classdef PositionClass2D
    %Helps to organize the position
    
    properties (Hidden = true, SetAccess = private)
       X = 0;
       Y = 0;
    end
    
    properties (Dependent)
        x;
        y;
        position;
    end
    
    methods 
        function this = PositionClass2D(position)    
                this.position = position;
        end
        
        function this = set.x(this, value)
            if length(value) > 1
                error('A double has to be provided')
            else
                this.X = value;
            end
        end
        
        function value = get.x(this)
            value = this.X;
        end
        
        function this = set.y(this, value)
            this.Y = value(1);
        end
        
        function value = get.y(this)
            value = this.Y;
        end
        
        function value = get.position(this)
            value = [this.X this.Y];
        end
        
        function this = set.position(this, position)
            if length(position) > 2
                warning('Only first two values of provided 2D position vector are used.');
            end
            if length(position) < 2
                error('A 2D vector needs to be provided');
            else
                this.X = position(1);
                this.Y = position(2);
            end
        end
            
    end
    
    methods (Static)

    end
    
end

