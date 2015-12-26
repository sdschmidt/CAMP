classdef MeasureWindClass_GUI < handle
    %MeasureWindClass_GUI defines a user interface for the
    %MeasureWindClass. The backend can be accessed using this.MWC. The GUI
    %is updated upon change of this.MWC.changed. 
    %written by Simon D. Schmidt May 2015
    properties
        % Listener handle
        listener
        
        % Backend handle
        MWC
        
        % Frontend GUI handles
        Greeter
        Main   
        Measure
        
        % Plots
        velo
        loss
        axialV
        beta
        
        % Configuration File
        configFile
        
        % Plottype
        plotType = 3; 
            % none    1
            % y-line  2
            % x-line  3
            % contour fill
            % surface
            % 3D plot
        
        % Log last updateGUI function call
        last
    end
    
    methods
        function this = MeasureWindClass_GUI(configFile) %initiate
            this.configFile = configFile;
            
            this.MWC = MeasureWindClass;
            this.startListening;
            
            this.Greeter = greeter;
            this.Greeter.greeterMain.UserData = this; % pass handle
            imshow('logo.png', 'Parent', this.Greeter.logo);
            
            this.Main = main;
            imshow('logo.png', 'Parent', this.Main.logo);
            this.Main.mainMain.Visible = 'off';
            this.Main.mainMain.UserData = this; % pass handle  
            
            this.Measure = measure;
            imshow('logo.png', 'Parent', this.Measure.logo);
            this.Measure.measureMain.Visible = 'off';
            this.Measure.measureMain.UserData = this;

            this.loss = figure(1);
            this.loss.MenuBar = 'none';
            plot(0,0);
            this.loss.CurrentAxes.Title.String = 'Loss Coefficient';
            hold off;
            
            this.velo = figure(2); 
            this.velo.MenuBar = 'none';
            plot(0,0);
            this.velo.CurrentAxes.Title.String = 'Velocity Ratio';
            hold off;
            
            this.axialV = figure(3); 
            this.axialV.MenuBar = 'none';
            plot(0,0);
            this.axialV.CurrentAxes.Title.String = 'Velocity of Axial Compressor';
            hold off;
            
            this.beta = figure(4); 
            this.beta.MenuBar = 'none';
            plot(0,0);
            this.beta.CurrentAxes.Title.String = 'Pitch Angle';
            hold off;
            
            run(configFile);
        end
        
        function startListening(this)
            this.listener = addlistener(this.MWC,'changed','PostSet',@this.updateGUI);
                % upon change of the backend, update the GUI
        end
        
        function updateGUI(this,~,~) 
            %disp('(!) Update called');
            %update the GUI
            this.last = now;
            this.showWindow;
            
            switch this.MWC.measurementDefined % updates split up by windows and state
                case 0
                    this.updateGreeter;        
                case 1
                    this.updateMain;     
                case 2
                    this.updateMeasure;
            end
            
            this.positionPlot;
            this.dataPlot;
        end
        
        function showWindow(this)   % show the active window
            switch this.MWC.measurementDefined
                case 0
                    this.Greeter.greeterMain.Visible = 'on';
                    this.Main.mainMain.Visible = 'off';
                    this.Measure.measureMain.Visible = 'off';
                case 1
                    this.Greeter.greeterMain.Visible = 'off';
                    this.Main.mainMain.Visible = 'on';
                    this.Measure.measureMain.Visible = 'off';
                case 2
                    this.Greeter.greeterMain.Visible = 'off';
                    this.Main.mainMain.Visible = 'off';
                    this.Measure.measureMain.Visible = 'on';
            end
        end
        
        function updateGreeter(this)
            this.Greeter.state.String = this.MWC.printStatus;
            this.Greeter.MeasurementList.String = this.MWC.getMeasurementList;
            this.Greeter.checkbox2.Value = this.MWC.interrupt;
            this.Greeter.notes.String = this.MWC.notes;
        end
        
        function updateMain(this)
            if this.MWC.velocityControlActive
                this.Main.axialPercentage.String = [num2str(this.MWC.velocityTarget), ' m/s'];
                this.Main.velocityTolerance.Visible = 'on';
                this.Main.startPID.Visible = 'on';
                this.Main.pidP.Visible = 'on';
                this.Main.pidTi.Visible = 'on';
                this.Main.pidTd.Visible = 'on';
            else
                this.Main.axialPercentage.String = [num2str(this.MWC.axial * 100),' %'];
                this.Main.velocityTolerance.Visible = 'off';
                this.Main.startPID.Visible = 'off';
                this.Main.pidP.Visible = 'off';
                this.Main.pidTi.Visible = 'off';
                this.Main.pidTd.Visible = 'off';
            end
            
            this.Main.pidP.String = num2str(this.MWC.pidParameters(1));
            this.Main.pidTi.String = num2str(this.MWC.pidParameters(2));
            this.Main.pidTd.String = num2str(this.MWC.pidParameters(3));
            
            this.Main.velocityTolerance.String = [num2str(this.MWC.velocityTargetTolerance),' m/s Tolerance'];
            this.Main.side1percentage.String = [num2str(this.MWC.side1 * 100),' %'];
            this.Main.side2percentage.String = [num2str(this.MWC.side2 * 100),' %'];
            
            this.Main.axialToggle.Value = this.MWC.running(1);
            this.Main.side1Toggle.Value = this.MWC.running(2);
            this.Main.side2Toggle.Value = this.MWC.running(3);
            
            this.Main.PIDcontrol.Value = this.MWC.velocityControlActive;
            
            this.Main.plotType.Value = this.plotType;
            
            this.Main.MName.String = this.MWC.name;
           
            this.Main.state.String = this.MWC.printStatus;
            
            this.Main.currentX.String = this.MWC.currentPosition(1);
            this.Main.currentY.String = this.MWC.currentPosition(2);
            
            this.Main.startT.String = this.MWC.start_t;
            this.Main.deltaT.String = this.MWC.delta_t;
            this.Main.samples.String = this.MWC.no_samples;
            
            this.Main.notes.String = this.MWC.notes;
            
            p = this.MWC.pressure_current;
            
            if this.Main.absolute.Value
                this.Main.moveX.String = round(this.MWC.targetPosition(1),2);
                this.Main.moveY.String = round(this.MWC.targetPosition(2),2);
            else
                this.Main.moveX.String = round(this.MWC.targetPosition(1)-this.MWC.currentPosition(1),2);
                this.Main.moveY.String = round(this.MWC.targetPosition(2)-this.MWC.currentPosition(2),2);
            end
            
            this.Main.p1.String = p(1);
            this.Main.p2.String = p(2);
            this.Main.p3.String = p(3);
            this.Main.p4.String = p(4);
            this.Main.p5.String = p(5);
            this.Main.p8.String = p(8);
            this.Main.p9.String = p(9);
            
            this.Main.p1p2.String = p(1) - p(3);
            this.Main.p3p4.String = p(2) - p(4);
            
            this.Main.yaw.String    = this.MWC.currentAngles(1);
            this.Main.pitch.String  = this.MWC.currentAngles(2);
            
            this.Main.velocity.String = this.MWC.velocity;
            
            if this.MWC.calibrated 
                this.Main.startMeasurement.Visible = 'on';
                this.Main.move.Visible = 'on';
            else
                this.Main.startMeasurement.Visible = 'off';
                this.Main.move.Visible = 'off';
            end
            
                k = 0;
                for a = this.MWC.points'
                    k = k + 1;
                    stringData{k} = sprintf('% 10.2f, % 10.2f', a(1), a(2)); %#ok
                end
                
                if k > 0
                    this.Main.points.String = stringData;
                    this.Main.lengthPoints.String = sprintf('%i',k);
                end    
        end
        
        function updateMeasure(this)
            this.Measure.state.String = this.MWC.printStatus;
            this.Measure.plotType.Value = this.plotType;
            if this.MWC.status == 6
                this.Measure.stopMeasurement.String = 'Skip Startup';
            else
                this.Measure.stopMeasurement.String = 'Stop Measurement';
            end
            
            this.Measure.currentX.String = this.MWC.currentPosition(1);
            this.Measure.currentY.String = this.MWC.currentPosition(2);
            
            this.Measure.MName.String = this.MWC.name;
        end
        
        function positionPlot(this)
            switch this.MWC.measurementDefined
                case 1
                    H = this.Main.positionDisplay;
                case 2
                    H = this.Measure.positionDisplay;  
                otherwise 
                    return;
            end
            
            try
                plot(H, this.MWC.points(:,1), this.MWC.points(:,2), 'p', 'Color',[0.5 0.5 0.5]);
            catch
                plot(H, 0, 0, 'blackx');
            end
            hold(H,'on');
            try
                plot(H, this.MWC.measuredPoints(:,1), this.MWC.measuredPoints(:,2),'p', 'Color',[0.2 0.8 0.4]);
            catch
            end
            plot(H, this.MWC.currentPosition(1), this.MWC.currentPosition(2),'ro');
            hold(H,'off');
            H.XLim = [0 200];
            H.YLim = [0 800];
            H.YGrid = 'on';
            H.XGrid = 'on';
        end
         
        function dataPlot(this)
            if this.plotType == 2 || this.plotType == 3
                    try
                        plot(this.loss.CurrentAxes,this.MWC.measuredPoints(:,this.plotType-1),this.MWC.measuredLossC,'black');
                        this.loss.CurrentAxes.Title.String = 'Loss Coefficient';
                        this.loss.CurrentAxes.XGrid = 'on';
                        this.loss.CurrentAxes.YGrid = 'on';

                        plot(this.velo.CurrentAxes,this.MWC.measuredPoints(:,this.plotType-1),this.MWC.measuredW2w1,'black');
                        this.velo.CurrentAxes.Title.String = 'Velocity Ratio';
                        this.velo.CurrentAxes.XGrid = 'on';
                        this.velo.CurrentAxes.YGrid = 'on';

                        plot(this.axialV.CurrentAxes,this.MWC.measuredPoints(:,this.plotType-1),real(this.MWC.measuredVelocity),'black');
                        this.axialV.CurrentAxes.Title.String = 'Velocity of Axial Compressor';
                        this.axialV.CurrentAxes.XGrid = 'on';
                        this.axialV.CurrentAxes.YGrid = 'on';
                        
                        plot(this.beta.CurrentAxes,this.MWC.measuredPoints(:,this.plotType-1),this.MWC.measuredAngles(:,2),'black');
                        this.beta.CurrentAxes.Title.String = 'Pitch Angle';
                        this.beta.CurrentAxes.XGrid = 'on';
                        this.beta.CurrentAxes.YGrid = 'on';
                    catch
                    end
            end

            if this.plotType == 4
                try
                    xv = sortrows(this.MWC.points,2);
                    yv = sortrows(this.MWC.points,1);

                    xl = find(xv(:,2) - min(xv(:,2)),1)  - 1;
                        if ~xl
                            xl = 1;
                        end
                    yl = find(yv(:,1) - min(yv(:,1)),1)  - 1;
                        if ~yl
                            yl = 1;
                        end

                    x = xv(1:xl,1);
                    y = yv(1:yl,2);

                    data = this.MWC.measuredLossC;
                    data(xl*yl) = 0;
                    contourf(this.loss.CurrentAxes,x,y,reshape(data,xl,yl)');

                    data = this.MWC.measuredW2w1;
                    data(xl*yl) = 0;
                    contourf(this.velo.CurrentAxes,x,y,reshape(data,xl,yl)');

                    data = real(this.MWC.measuredVelocity);
                    data(xl*yl) = 0;
                    contourf(this.axialV.CurrentAxes,x,y,reshape(data,xl,yl)'); 
                    
                    data = this.MWC.measuredAngles(:,2);
                    data(xl*yl) = 0;
                    contourf(this.beta.CurrentAxes,x,y,reshape(data,xl,yl)'); 
                catch
                    warning('could not plot')
                end
            end
            
            if this.plotType == 5
                try
                    xv = sortrows(this.MWC.points,2);
                    yv = sortrows(this.MWC.points,1);

                    xl = find(xv(:,2) - min(xv(:,2)),1)  - 1;
                        if ~xl
                            xl = 1;
                        end
                    yl = find(yv(:,1) - min(yv(:,1)),1)  - 1;
                        if ~yl
                            yl = 1;
                        end

                    x = xv(1:xl,1);
                    y = yv(1:yl,2);

                    data = this.MWC.measuredLossC;
                    %data(xl*yl) = 0;
                    surf(this.loss.CurrentAxes,x,y,reshape(data,xl,yl)');

                    data = this.MWC.measuredW2w1;
                    %data(xl*yl) = 0;
                    surf(this.velo.CurrentAxes,x,y,reshape(data,xl,yl)');

                    data = real(this.MWC.measuredVelocity);
                    %data(xl*yl) = 0;
                    surf(this.axialV.CurrentAxes,x,y,reshape(data,xl,yl)'); 
                    
                    data = this.MWC.measuredAngles(:,2);
                    %data(xl*yl) = 0;
                    surf(this.beta.CurrentAxes,x,y,reshape(data,xl,yl)'); 
                catch
                    warning('could not plot')
                end
            end
            
            if this.plotType == 6
                try
                    x = this.MWC.measuredPoints(:,1);
                    y = this.MWC.measuredPoints(:,2);
                    
                    plot3(this.loss.CurrentAxes,x,y,this.MWC.measuredLossC,'blackx');                
                    plot3(this.velo.CurrentAxes,x,y,this.MWC.measuredW2w1,'blackx');
                    plot3(this.axialV.CurrentAxes,x,y,real(this.MWC.measuredVelocity),'blackx'); 
                    plot3(this.beta.CurrentAxes,x,y,this.MWC.measuredAngles(:,2),'blackx'); 
                catch
                    warning('could not plot')
                end
            end
        end
    end
end

