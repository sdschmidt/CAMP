classdef GUI_MWC_eventHandler < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        MWC = MeasureWindClass;
    end
    
    properties (Dependent)
        SDS;
    end
    
    properties
        Hgreeter
        Hmain 
    end
    
    
    methods
        function value = get.SDS(this)
            value = this.MWC;
            this.updateGUI;
        end
        
        function this = set.SDS(this,value)
            this.MWC = value;
            this.updateGUI;
        end
        
        function startGUI(this)
            this.Hgreeter = greeter(this);
            this.Hmain = main;
            
            this.Hgreeter.MeasurementList.String = this.MWC.getMeasurementList;
            this.Hmain.mainMain.Visible = 'off';
        end
        
        function updateGUI(this)
            disp('updateGUI called');
            this.showWindow();   
        end
        
        function showWindow(this)
            switch this.MWC.measurementDefined
                case 0
                    this.Hgreeter.greeterMain.Visible = 'on';
                    this.Hmain.mainMain.Visible = 'off';
                case 1
                    this.Hgreeter.greeterMain.Visible = 'off';
                    this.Hmain.mainMain.Visible = 'on';
                case 2
            end
            
            
        end
        
        
        function delete(this)
            clear this.MWC;
        end
    end
    
    methods (Static)
        function onChange(~)
            disp('class changed');
        end
    end
    
    
end

