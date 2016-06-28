function message = modt()
%modt placeholder for a Message of the Day function
    switch datestr(now,'ddd')
        case 'Mon'
            message = sprintf('Heute ist Montag. \nIch wünsche persönlich einen guten Start in die Woche!');
        case 'Tue'
            message = sprintf('Heute ist Dienstag. Wer Montage hasst, wird Dienstage mögen!');
        case 'Wed'
            message = sprintf('Heute ist Mittwoch. Dies bedeutet Halbzeit!');
        case 'Thu'
            message = sprintf('Donnerstag. Der Tag der Studentenfeiern. \nHeute ist Happy Hour von 21.00 bis 22.00 Uhr!');
        case 'Fri'
            message = sprintf('Heute ist Freitag. Und das bedeutet morgen ist Wochenende!');
        case 'Sat'
            message = sprintf('Samstag. F?r viele Leute ein Arbeitstag. Aber dennoch Wochenende!');
        case 'Sun'
            message = sprintf('Sonntag. Der Tag der Ruhe und Besinnlichlkeit.\nGönnen auch Sie sich ein bisschen Ruhe! \nOder Ich empfehle: http://xkcd.com');
    end
end

