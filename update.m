function updateETS(installpath)
        disp(installpath)

        disp('getting new files ...')
        tempfile = [tempdir,'newversion.zip'];
        urlwrite('http://www.sidash.de/ETS/newversion.zip',tempfile);
        disp('extracting ...')
        
        includedir = [installpath,'/include/'];
        % clean up
        rmdir(includedir,'s');
        delete([installpath,'/start.p']);    
        
        % unzip
        unzip(tempfile,installpath);
        
        % compile
        pcode([installpath,'/start.m'],'-inplace');
        delete([installpath,'/start.m']);  
        
        pcode([installpath,'/include/WindClass.m'],'-inplace');
        pcode([installpath,'/include/MeasureWindClass.m'],'-inplace');
        pcode([installpath,'/include/MeasureWindClass_GUI.m'],'-inplace');
        
        delete([installpath,'/include/WindClass.m'])
        delete([installpath,'/include/MeasureWindClass.m']);
        delete([installpath,'/include/MeasureWindClass_GUI.m']);
        
        disp('complete ...')
        %delete(tempfile);
end
