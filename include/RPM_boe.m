
function RPM_boe(percentage, FU, arduinoObject)
%FUNCTION WRITTEN BY PROF. BOEHLE ON APRIL 28th, 2015
    % adjusted by Simon Schmidt on May 15th, 2015
ledPin42 = 42;       %  arduinoObject.pinMode(ledPin42,'output'); is done in 
ledPin44 = 44;       %  arduinoObject.pinMode(ledPin44,'output');
ledPin46 = 46;       %  arduinoObject.pinMode(ledPin46,'output');

ledPin51 = 51;       %  arduinoObject.pinMode(ledPin51,'output');
ledPin52 = 52;       %  arduinoObject.pinMode(ledPin52,'output');


V_req_4095 = round( percentage * 4095);

str = dec2bin(V_req_4095);
n_str = numel( str );

%COMPLETING THE BIT SERIE
for i = 1:12
    if( 12 >= n_str + i )
        str_new(i) = '0';
    else
        str_new(i) = str( i + n_str - 12 );
    end
end

%GENERATION OF THE BIT SERIE
for i=1:12
    if( str_new(i) == '1' )
        n_bit(i) = 1;
    else
        n_bit(i) = 0;
    end
end

arduinoObject.digitalWrite(ledPin52, 1);

switch FU     % Switch ca. 34us
    case 1
        arduinoObject.digitalWrite(ledPin42, 1);
        arduinoObject.digitalWrite(ledPin42, 0);
    case 2
        arduinoObject.digitalWrite(ledPin44, 1);
        arduinoObject.digitalWrite(ledPin44, 0);
    case 3
        arduinoObject.digitalWrite(ledPin46, 1);
        arduinoObject.digitalWrite(ledPin46, 0);
end

for i=1:16   
    if( i == 1)
        arduinoObject.digitalWrite(ledPin51, 0);
        arduinoObject.digitalWrite(ledPin52, 0); %% why write it double? think this can be ommited since line 36 ...
        arduinoObject.digitalWrite(ledPin52, 1);
        pause(0.1);
        arduinoObject.digitalWrite(ledPin52, 0);
        continue;
    end
    
    if( i == 2)
        arduinoObject.digitalWrite(ledPin51, 0);
        arduinoObject.digitalWrite(ledPin52, 1);
        pause(0.1);
        arduinoObject.digitalWrite(ledPin52, 0);
        continue;
    end
    
    if( i == 3)
        arduinoObject.digitalWrite(ledPin51, 1);
        arduinoObject.digitalWrite(ledPin52, 1);
        pause(0.1);
        arduinoObject.digitalWrite(ledPin52, 0);
        continue;
    end
    
    if( i == 4)
        arduinoObject.digitalWrite(ledPin51, 1);
        arduinoObject.digitalWrite(ledPin52, 1);
        pause(0.1);
        arduinoObject.digitalWrite(ledPin52, 0);
        continue;
    end
    
    if( i > 4 )
        arduinoObject.digitalWrite(ledPin51, n_bit(i-4));
        arduinoObject.digitalWrite(ledPin52, 1);
        pause(0.1);
        arduinoObject.digitalWrite(ledPin52, 0);
        continue;
    end 
end

switch FU     % Switch ca. 34us
    case 1
        digitalWrite(arduinoObject, ledPin42, 1);
    case 2
        digitalWrite(arduinoObject, ledPin44, 1);
    case 3
        digitalWrite(arduinoObject, ledPin46, 1);
end