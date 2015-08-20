clear;
percentage = 0.4;

V_req_4095 = round(percentage * 4095);

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

%%

percentage = 0.3;
bits = ['0011',dec2bin(percentage * 4095, 12)];

arduinoObject.digitalWrite(ledPin52, 1);

switch FU     
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

for bit = bits
    arduinoObject.digitalWrite(ledPin51, 0);
    arduinoObject.digitalWrite(ledPin52, 1);
    %pause(0.1);
    arduinoObject.digitalWrite(ledPin52, 0);
end

switch FU    
    case 1
        digitalWrite(arduinoObject, ledPin42, 1);
    case 2
        digitalWrite(arduinoObject, ledPin44, 1);
    case 3
        digitalWrite(arduinoObject, ledPin46, 1);
end
%%












