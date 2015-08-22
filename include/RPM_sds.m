function RPM_sds(percentage, pinMachine, pinWrite1, pinWrite2,  arduinoObject)
%RPM_sds writes Percentage to machine using arduino
bits = ['0011',dec2bin(round( percentage * 4095),12)];

arduinoObject.digitalWrite(pinMachine, 1);
arduinoObject.digitalWrite(pinMachine, 0);
fprintf('M%2iW%2iW%2i: ', pinMachine, pinWrite1, pinWrite2);
for bit = bits;
    fprintf('%s',bit);
    arduinoObject.digitalWrite(pinWrite1, str2double(bit));
    arduinoObject.digitalWrite(pinWrite2, 1);
    arduinoObject.digitalWrite(pinWrite2, 0);
end
fprintf('\n');
arduinoObject.digitalWrite(pinMachine, 1);