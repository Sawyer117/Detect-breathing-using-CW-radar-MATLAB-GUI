global v;          %global v:an indicator of play/pause the video/data                 
global ifload;     %global ifload:an indicator of whether the data is loaded correctly(abandoned in 6/26/2016)
v=0;    
ifload=0;
hand=RadarData2(handles.figure1);
gui1Handle=guihandles(hand);
handles.gui2handles=gui1Handle;


axes(gui1Handle.axes1);

state2=('Importing data...');     
set(gui1Handle.text18,'string',state2);   %when button is clicked,text18 will be set
% set(gui1Handle.text33,'string','');
% set(gui1Handle.text36,'string','');
set(gui1Handle.edit21,'string','');
set(gui1Handle.edit22,'string','');
set(handles.edit5,'string','');
set(handles.edit6,'string','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
[filename, pathname] = uigetfile( '*.avi;*.mp4', 'start');
namestr=(filename);            %Importing the file,extract the filename and pathname
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global h
h=actxcontrol('WMPlayer.OCX.7', [48 164 255 225]); %start ActiveX control,the position matrix is found by testing 
h.URL=[pathname filename];                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state1=namestr(1:length(namestr)-4);       %This step wipes off the suffix(.avi)

BELT=('_BELT.csv');
radar=('.csv');
beltfile1=strcat(state1,BELT);             %
R1file1=strcat(state1,radar);              %These two steps find the BELT and Radar Signal  
 
set(handles.text10,'string',state1);
R1file=strcat(pathname,R1file1);

handles.pathname=pathname;
handles.filename=filename;

guidata(hObject,handles);


