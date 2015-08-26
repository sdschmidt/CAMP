try
    sds.MWC.stopAll;
catch
end
try 
    close(sds.Main.mainMain)
catch
end
try 
    close(sds.Greeter.greeterMain)
catch
end
try 
    close(sds.Measure.measureMain)
catch
end
close all; 
clear sds; 
path(pathdef);