function varargout = measure(varargin)
% MEASURE MATLAB code for measure.fig
%      MEASURE, by itself, creates a new MEASURE or raises the existing
%      singleton*.
%
%      H = MEASURE returns the handle to a new MEASURE or the handle to
%      the existing singleton*.
%
%      MEASURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASURE.M with the given input arguments.
%
%      MEASURE('Property','Value',...) creates a new MEASURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before measure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to measure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help measure

% Last Modified by GUIDE v2.5 18-Aug-2015 20:45:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @measure_OpeningFcn, ...
                   'gui_OutputFcn',  @measure_OutputFcn, ...
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


% --- Executes just before measure is made visible.
function measure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to measure (see VARARGIN)

% Choose default command line output for measure
handles.output = handles;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes measure wait for user response (see UIRESUME)
% uiwait(handles.measureMain);


% --- Outputs from this function are returned to the command line.
function varargout = measure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in stopMeasurement.
function stopMeasurement_Callback(hObject, eventdata, handles)
% hObject    handle to stopMeasurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.measureMain.UserData.MWC.interrupt = 1;
disp('stopCallback');


% --- Executes on button press in emergency_stop.
function emergency_stop_Callback(hObject, eventdata, handles)
% hObject    handle to emergency_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.measureMain.UserData.MWC.emergencyStop;


% --- Executes on selection change in plotType.
function plotType_Callback(hObject, eventdata, handles)
% hObject    handle to plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotType
handles.measureMain.UserData.plotType = hObject.Value;
handles.measureMain.UserData.dataPlot;

% --- Executes during object creation, after setting all properties.
function plotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function measureMain_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to measureMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
