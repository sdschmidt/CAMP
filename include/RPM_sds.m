function RPM_sds(percentage, machine, arduinoObject)
%RPM_sds Summary of this function goes here
%   Detailed explanation goes here
    pinAxial = 42;       %  arduinoObject.pinMode(ledPin42,'output'); is done in 
    pinSide1 = 46;       %  arduinoObject.pinMode(ledPin44,'output');
    pinSide2 = 44;       %  arduinoObject.pinMode(ledPin46,'output');

    pinWrite1 = 51;      %  arduinoObject.pinMode(ledPin51,'output');
    pinWrite2 = 52;      %  arduinoObject.pinMode(ledPin52,'output');
    
    bits = ['0011',dec2bin(percentage * 4095, 12)];
    arduinoObject.digitalWrite(pinWrite2, 1);

    switch machine     
        case 1
            arduinoObject.digitalWrite(pinAxial, 1);
            arduinoObject.digitalWrite(pinAxial, 0);
        case 2
            arduinoObject.digitalWrite(pinSide1, 1);
            arduinoObject.digitalWrite(pinSide1, 0);
        case 3
            arduinoObject.digitalWrite(pinSide2, 1);
            arduinoObject.digitalWrite(pinSide2, 0);
    end

    first = 1;
    for bit = bits
        arduinoObject.digitalWrite(pinWrite1, 0);
        if first
            arduinoObject.digitalWrite(pinWrite2, 1); first = 0;
        end
        arduinoObject.digitalWrite(pinWrite2, 1);
        pause(0.1);
        arduinoObject.digitalWrite(pinWrite2, 0);
    end

    switch machine    
        case 1
            digitalWrite(arduinoObject, pinAxial, 1);
        case 2
            digitalWrite(arduinoObject, pinSide1, 1);
        case 3
            digitalWrite(arduinoObject, pinSide2, 1);
    end
end

