
backend = CAMP.MWC;
backend.connectArduino;

total = numel(backend.getMeasurementList);
n = 0;
for measurement = backend.getMeasurementList
    n = n + 1;
    clc;
    fprintf('%i/%i: %s \n',n,total,measurement{1});
    backend.name = measurement{1};
    backend.loadData;
    CAMP.updateGUI;
    backend.recalculate;
    backend.saveData;
end