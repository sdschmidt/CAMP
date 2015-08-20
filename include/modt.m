function message = modt()
%modt Message of the day
%returns the message of the day
% first draft. Separate content from programmation
% Add MODT database to load from, which gets updated with the update
% function
    switch datestr(now,'ddd')
        case 'Mon'
            message = sprintf('Heute ist Montag. \nIch w?nsche pers?nlich einen guten Start in die Woche!');
        case 'Tue'
            message = sprintf('Heute ist Dienstag. Wer Montage hasst, wird Dienstage m?gen!');
        case 'Wed'
            message = sprintf('Heute ist Mittwoch. Dies bedeutet Halbzeit!');
        case 'Thu'
            message = sprintf('Donnerstag. Der Tag der Studentenfeiern. \nHeute ist Happy Hour von 21.00 bis 22.00 Uhr!');
        case 'Fri'
            message = sprintf('Heute ist Freitag. Und das bedeutet morgen ist Wochenende!');
        case 'Sat'
            message = sprintf('Samstag. F?r viele Leute ein Arbeitstag. Aber dennoch Wochenende!');
        case 'Sun'
            message = sprintf('Sonntag. Der Tag der Ruhe und Besinnlichlkeit.\nG?nnen auch Sie sich ein bisschen Ruhe! \nOder Ich empfehle: ');
    end
end

