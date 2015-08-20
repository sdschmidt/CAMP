
function varargout = greeter(varargin)
% GREETER MATLAB code for greeter.fig
%      GREETER, by itself, creates a new GREETER or raises the existing
%      singleton*.
%
%      H = GREETER returns the handle to a new GREETER or the handle to
%      the existing singleton*.
%
%      GREETER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GREETER.M with the given input arguments.
%
%      GREETER('Property','Value',...) creates a new GREETER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before greeter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to greeter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help greeter

% Last Modified by GUIDE v2.5 18-Aug-2015 21:08:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @greeter_OpeningFcn, ...
                   'gui_OutputFcn',  @greeter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
     gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before greeter is made visible.
function greeter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to greeter (see VARARGIN)

% Choose default command line output for greeter
handles.output = handles;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes greeter wait for user response (see UIRESUME)
% uiwait(handles.greeterMain);


% --- Outputs from this function are returned to the command line.
function varargout = greeter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in MeasurementList.
function MeasurementList_Callback(hObject, eventdata, handles)
% hObject    handle to MeasurementList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MeasurementList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MeasurementList
handles.greeterMain.UserData.MWC.name = handles.MeasurementList.String...
    {handles.MeasurementList.Value};
handles.greeterMain.UserData.MWC.loadData;
handles.greeterMain.UserData.MWC.loadNotes;
handles.greeterMain.UserData.updateGUI;


% --- Executes during object creation, after setting all properties.
function MeasurementList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MeasurementList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadMeasurement.
function loadMeasurement_Callback(hObject, eventdata, handles)
% hObject    handle to loadMeasurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.greeterMain.UserData.MWC.loadMeasurement(handles.MeasurementList.String...
    {handles.MeasurementList.Value})


% --- Executes on button press in newMeasurement.
function newMeasurement_Callback(hObject, eventdata, handles)
% hObject    handle to newMeasurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.greeterMain.UserData.MWC.newMeasurement(handles.MName.String,handles.timestamp.Value);


function MName_Callback(hObject, eventdata, handles)
% hObject    handle to MName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MName as text
%        str2double(get(hObject,'String')) returns contents of MName as a double

disp('changed')

% --- Executes during object creation, after setting all properties.
function MName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in timestamp.
function timestamp_Callback(hObject, eventdata, handles)
% hObject    handle to timestamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timestamp


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over loadMeasurement.
function loadMeasurement_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to loadMeasurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close greeterMain.
function greeterMain_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to greeterMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

function greeterMain_DeleteFcn(hObject, eventdata, handles)

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.greeterMain.UserData.MWC.interrupt = hObject.Value;


% --- Executes on button press in openConfigFile.
function openConfigFile_Callback(hObject, eventdata, handles)
% hObject    handle to openConfigFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit(handles.greeterMain.UserData.configFile);



function notes_Callback(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notes as text
%        str2double(get(hObject,'String')) returns contents of notes as a double
handles.greeterMain.UserData.MWC.notes = cellstr(hObject.String);

% --- Executes during object creation, after setting all properties.
function notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savenotes.
function savenotes_Callback(hObject, eventdata, handles)
% hObject    handle to savenotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.greeterMain.UserData.MWC.saveNotes;