function varargout = BreathingRateEstimation(varargin)
% BREATHINGRATEESTIMATION MATLAB code for BreathingRateEstimation.fig
%      BREATHINGRATEESTIMATION, by itself, creates a new BREATHINGRATEESTIMATION or raises the existing
%      singleton*.
%
%      H = BREATHINGRATEESTIMATION returns the handle to a new BREATHINGRATEESTIMATION or the handle to
%      the existing singleton*.
%
%      BREATHINGRATEESTIMATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BREATHINGRATEESTIMATION.M with the given input arguments.
%
%      BREATHINGRATEESTIMATION('Property','Value',...) creates a new BREATHINGRATEESTIMATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BreathingRateEstimation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BreathingRateEstimation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BreathingRateEstimation

% Last Modified by GUIDE v2.5 20-Jul-2016 21:12:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BreathingRateEstimation_OpeningFcn, ...
                   'gui_OutputFcn',  @BreathingRateEstimation_OutputFcn, ...
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


% --- Executes just before BreathingRateEstimation is made visible.
function BreathingRateEstimation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BreathingRateEstimation (see VARARGIN)
global selectedBreathing;

switch(selectedBreathing)
    case 0
set(handles.radiobutton1,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);

    case 1
set(handles.radiobutton1,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);

case 2
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',1);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);

case 3
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',1);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);


case 4
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',1);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);



case 5
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',1);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);

case 6
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',1);
set(handles.radiobutton7,'value',0);

    case 7
        set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',1);


end

% 
load Breathparam WinSize
set(handles.edit1,'string',num2str(WinSize));


% Choose default command line output for BreathingRateEstimation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BreathingRateEstimation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BreathingRateEstimation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global guding;
guding=1;

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
set(handles.radiobutton1,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.text3,'string','None');
set(handles.edit1,'string','None');
global selectedBreathing;
global state45
selectedBreathing=1;
state45=('Notch');
load parameter WinSizeOverlap
save parameter selectedBreathing WinSizeOverlap

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',1);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
%set(handles.text3,'string','Window Size');
%set(handles.text4,'string','Enter an interger');
global selectedBreathing;
global state45
selectedBreathing=2;
state45=('Sum_Window');
load parameter WinSizeOverlap
save parameter selectedBreathing WinSizeOverlap

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',1);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
global selectedBreathing;
global state45
selectedBreathing=3;
state45=('Sum_Squared');
load parameter WinSizeOverlap
save parameter selectedBreathing WinSizeOverlap

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',1);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
global selectedBreathing;
global state45
selectedBreathing=4;
state45=('Shannon Squared');
load parameter WinSizeOverlap
save parameter selectedBreathing WinSizeOverlap 

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',1);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
global selectedBreathing;
global state45
selectedBreathing=5;
state45=('Log entropy');
load parameter WinSizeOverlap
save parameter selectedBreathing WinSizeOverlap

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',1);
set(handles.radiobutton7,'value',0);
global selectedBreathing;
global state45
selectedBreathing=6;
state45=('Subspace method');
load parameter WinSizeOverlap
save parameter selectedBreathing WinSizeOverlap

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DLGNAME=('About Breathing Esimation');
HELPSTRING={'The Breathing Esimation algorithms here are the implementation of the papaer:' char(10) 'M. Mabrouk, S. Rajan, M. Bolic, M. Forouzanfar, H. R. Dajani and I. Batkin,"Human breathing rate estimation from radar returns using harmonically related filters," Journal of Sensors, Hindawi Publishing Corporation, Article ID 9891852, Vol. 2016, 2016.' char(10) 'Check the papaer for detail description of the algorithm,the default algorithm is notch-filter based'};

 HANDLE = helpdlg(HELPSTRING,DLGNAME);
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state45

hand=RadarData2(handles.figure1);
gui1Handle=guihandles(hand);
handles.gui2handles=gui1Handle;




set(gui1Handle.text45,'string',state45);   %when button is clicked,text18 will be set


hand=BreathingRateEstimation(handles.figure1);
gui1Handle=guihandles(hand);
%uiresume(RadarData2(handles.figure1))
close(hand);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WinSize = str2double(get(handles.edit1,'String'));
save Breathparam WinSize


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',1);
%set(handles.text3,'string','Window Size');
%set(handles.text4,'string','Enter an interger');
global selectedBreathing;
global state45
selectedBreathing=7;
state45=('Chirp trans');
load parameter WinSizeOverlap
save parameter selectedBreathing WinSizeOverlap
