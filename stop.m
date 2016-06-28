
try
    CAMP.MWC.stopAll;
catch
end
try 
    close(CAMP.Main.mainMain)
catch
end
try 
    close(CAMP.Greeter.greeterMain)
catch
end
try 
    close(CAMP.Measure.measureMain)
catch
end
close all; 
clear CAMP.MWC;
clear CAMP;
clear all;
path(pathdef);