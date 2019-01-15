function varargout = PlotAllZone1(varargin)
% PLOTALLZONE1 MATLAB code for PlotAllZone1.fig
%      PLOTALLZONE1, by itself, creates a new PLOTALLZONE1 or raises the existing
%      singleton*.
%
%      H = PLOTALLZONE1 returns the handle to a new PLOTALLZONE1 or the handle to
%      the existing singleton*.
%
%      PLOTALLZONE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTALLZONE1.M with the given input arguments.
%
%      PLOTALLZONE1('Property','Value',...) creates a new PLOTALLZONE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlotAllZone1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlotAllZone1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlotAllZone1

% Last Modified by GUIDE v2.5 12-Apr-2016 00:00:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlotAllZone1_OpeningFcn, ...
                   'gui_OutputFcn',  @PlotAllZone1_OutputFcn, ...
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


% --- Executes just before PlotAllZone1 is made visible.
function PlotAllZone1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlotAllZone1 (see VARARGIN)
%%
global rd1
global fs;

[~,col]=size(rd1);
A=[200,100,480,650];
B=[0,0,700,700];
set(handles.figure1,'units','pixels','position',A);
handles.uipanel1=uipanel(handles.figure1,'units','pixels','position',B ,'title','','bordertype','none');
labelTitle1 = uicontrol(gcf,'Style', 'text', 'String', 'Zone',...  
    'Position',[10,580, 40,45]);  
set(handles.slider1,'units','pixels','position',[450, 65, 20, 550], 'value',1,'parent',handles.figure1);
handles.axes = cell(col,1);
 for i=1:col
    
   % handles.axes{i} = uicontrol(handles.uipanel1,'units','pixels','position',[100,520-50*i, 80,40],'style','axes','string',['axes ',num2str(i)],'backgroundcolor',[0.3,0.3,0.3],...
%'foregroundcolor',[1,1,1],'fontsize',20);

 handles.axes{i} = axes('Units','pixels','Position', [70,650-65*i, 340,40]);

%60 should be replaced as 600/zonenumber
%handles.axes{i} = uicontrol(handles.uipanel1,'units','normalized','position',[100,520-60*i, 340,40],...    
    %'tag','axes1','backgroundcolor',[1,1,1],'foregroundcolor',[1,1,1],'fontsize',20);
    
    set(handles.axes{i},'Parent', handles.uipanel1);
%       hc2 = findobj(allchild(handles.axes{i}), 'Type', 'text');
%     %YtickPo=[70,650-60*lo,340];
% set(hc2(4), 'Position', [0 0 0]);
    
end
%%  To plot into the drawed axes
    %fs=830;%T=1/fs;
%t1=0.0012;t2=90;                %%%Initialization
%p1=t1*fs;p2=t2*fs;
%[~,col]=size(rd1);
for lo=1:col
%zoneNum=1;                       %%%Initialization of zoneNum,need to be deleted
zone=lo;
L1=rd1(:,zone);
%L=L1(p1:p2);
L=L1;
s1=L(1:length(L));
t=0:1/fs:(length(s1)-1)/fs;

s1=s1/100;
%m=s1;
axes(handles.axes{lo});
plot(t(1:length(s1)),s1);
scale=max(t(1:length(s1)));


name=num2str(lo);
    ylabel(name,'FontName','Times New Roman','FontSize',11,'Rotation',0) 
    set(handles.axes{lo},'YTick', []);
  
        % hc2 = findobj(allchild(handles.axes{lo}), 'Type', 'text');
    %YtickPo=[70,650-60*lo,340];
%set(hc2(4), 'Position', [0 0 0]);
end


%%
% Choose default command line output for PlotAllZone1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PlotAllZone1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PlotAllZone1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
