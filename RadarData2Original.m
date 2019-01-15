function varargout = RadarData2(varargin)
% RadarData2 MATLAB code for RadarData2.fig
%      RadarData2, by itself, creates a new RadarData2 or raises the existing
%      singleton*.
%
%      H = RadarData2 returns the handle to a new RadarData2 or the handle to
%      the existing singleton*.
%
%      RadarData2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RadarData2.M with the given input arguments.
%
%      RadarData2('Property','Value',...) creates a new RadarData2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RadarData2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RadarData2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RadarData2

% Last Modified by GUIDE v2.5 12-Jun-2016 05:55:02

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RadarData2_OpeningFcn, ...
                   'gui_OutputFcn',  @RadarData2_OutputFcn, ...
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


% --- Executes just before RadarData2 is made visible.
function RadarData2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RadarData2 (see VARARGIN)
global zoneNum
zoneNum=1;
global ifload
ifload=0;
global selectedBreathing;
selectedBreathing=0;
axes(handles.axes1)
grid on
axes(handles.axes2)
grid on
axes(handles.axes3)
grid on
axes(handles.axes4)
grid on
axes(handles.axes5)
grid on
axes(handles.axes6)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.axes6)
str1=['PictureNeeded/A3Z0.png'];
zonepic=imread(str1);
imshow(zonepic);
% Choose default command line output for RadarData2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RadarData2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RadarData2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global ifload
ifload=0;

%%
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To anyone who's reading this,thanks for reading my code!
% The real functional part of code starts from here and
% the detailed explanation will be given,dont worry!
% The code is roughly written,if you can make any optimization,
% Don't hesitate to contact wensyaustin@foxmail.com!
%                                      Austin(wen) 3/24/2016 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global v;          %global v:an indicator of play/pause the video/data                 
global ifload;     %global ifload:an indicator of whether the data is loaded correctly
v=0;    
%ifload=0;
state2=('Importing data...');     
set(handles.text18,'string',state2);   %when button is clicked,text18 will be set
set(handles.text33,'string','');
set(handles.text36,'string','');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
[filename, pathname] = uigetfile( '*.avi;*.mp4', '开始');
%[filename, pathname] = uigetfile( '*.csv', '开始');
 namestr=(filename);            %Importing the file,extract the filename and pathname
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global h;
h=actxcontrol('WMPlayer.OCX.7', [48 404 255 215]); %start ActiveX control,the position matrix is found by testing 
h.URL=[pathname filename];                                                    
%pause(0.03);
%h.controls.pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state1=namestr(1:length(namestr)-4);       %This step wipes off the suffix(.avi)

BELT=('_BELT.csv');
radar=('.csv');
beltfile1=strcat(state1,BELT);             %
R1file1=strcat(state1,radar);              %These two steps find the BELT and Radar Signal  
 
 set(handles.text10,'string',state1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Now the part below plots the Radar signal 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global selectedBreathing;
global st2;
global rd1;
global t;
global s1;
global s2;
global s3;
global m;
global zoneNum;
global timestem;
global zoneIneed;
global Radar_Br;
global Radar_FFT;
R1file=strcat(pathname,R1file1);
rd1=csvread(R1file,1,0);
%fs1 = size(rd1)/70;%%%%the frequency should be later modified with this equation
zoneIneed=psd1(rd1);
fs=902; %it was 830;%T=1/fs;

if zoneNum==0
zoneNum=1;                       %%%Initialization of zoneNum,need to be deleted later
end

zone=zoneNum;
L1 =signal_from_multiple_zones(rd1,zoneIneed);


L=L1-mean(L1);
s1=L(1:length(L));
t=0:1/fs:(length(s1)-1)/fs;

s1=s1/100;
m=s1;
axes(handles.axes2);
plot(t(1:length(s1)),m);
grid on
%plotting finishes......

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The code below plots the Extracted Breathing signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global extractedBreath;
axes(handles.axes5);


t1=length(L1)/902;
zoneplotratio=t1/60;
for i1=1:floor(t1/3)-10
    s1chunk=L1(floor((length(L1)*(i1)/60)):floor((length(L1)*(i1+2)/60-1)),:);
    s1chunk=s1chunk-mean(s1chunk);
    [FFT_R, Breathing_rate,filtered,extracT] =Breathing1(s1chunk,2);
    Radar_Br(i1)=Breathing_rate;
    Radar_FFT(i1,:)=FFT_R;
end
[Breathing_rate_energy_sum_squared,Breathing_rate_energy_sum_window,Breathing_rate_Log_entropy,breathing_rate_moving_average,Breathing_rate_energy_Shannon_squared,Breathing_rate_notch,filtered,extracT] =Breathing(L1);
extractedBreath=filtered(300:length(filtered));
timestem=extracT(300:length(filtered))

k=(fs/2^16)*[0:(2^16-1)];
plot(k,Radar_FFT(1,:));xlabel('frequency(Hz.)');
ylabel('Normalized magnitude');xlim([0 2]);
grid on



handles.Breathing_rate_energy_sum_window=Breathing_rate_energy_sum_window;
handles.Breathing_rate_Log_entropy=Breathing_rate_Log_entropy;
handles.Breathing_rate_energy_sum_squared=Breathing_rate_energy_sum_squared;
handles.breathing_rate_moving_average=breathing_rate_moving_average;
handles.Breathing_rate_energy_Shannon_squared=Breathing_rate_energy_Shannon_squared;
handles.Breathing_rate_notch=Breathing_rate_notch;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.axes5);

switch(selectedBreathing)
    case 0
        selectedBreathing=Breathing_rate_notch;
set(handles.edit4,'string',num2str(selectedBreathing));
set(handles.text45,'string',('notch') );
case 1
        selectedBreathing=Breathing_rate_notch;
set(handles.edit4,'string',num2str(selectedBreathing));
set(handles.text45,'string',('notch') );
case 2
        selectedBreathing=Breathing_rate_Log_entropy;
        set(handles.edit4,'string',num2str(selectedBreathing));
set(handles.text45,'string',['Log' char(10) 'entropy'] );
case 3
        selectedBreathing=breathing_rate_moving_average;
set(handles.edit4,'string',num2str(selectedBreathing));
set(handles.text45,'string',['moving' char(10) 'average'] );
case 4
        selectedBreathing=Breathing_rate_energy_Shannon_squared;
set(handles.edit4,'string',num2str(selectedBreathing));
set(handles.text45,'string',['shannon' char(10) 'squared'] );
case 5
        selectedBreathing=Breathing_rate_energy_sum_squared;
set(handles.edit4,'string',num2str(selectedBreathing));
set(handles.text45,'string',['sum' char(10) 'squared'] );
case 6
        selectedBreathing=Breathing_rate_energy_sum_window;
set(handles.edit4,'string',num2str(selectedBreathing));
set(handles.text45,'string',['sum' char(10) 'window'] );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The code below plots the BELT signal(Ecg in channel 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beltfile=strcat(pathname,beltfile1);
st2=csvread(beltfile,1,1);

fs1=256;%T1=1/fs1; %%%%%%%%% Bug here:The frequency of belt fs1 should be calculated.


%% decide which part of belt file should be plotted
[~,col]=size(st2);
if col==2
    st2=csvread(beltfile,1,0);
BELTzone1=2;
BELTzone2=1;
end
if col==3
    BELTzone1=2;
    BELTzone2=1;
end
%%

L3=st2(:,BELTzone1);
%L=L1(p1:p2);
%L=L1;
s3=L3(1:length(L3));
t2=0:1/fs1:(length(s3)-1)/fs1;
axes(handles.axes3);
plot(t2(1:length(s3)),s3);
grid on
%xlabel('T/s','FontName','Times New Roman','FontSize',14);
%%%%%%%%%%%

L2=st2(:,BELTzone2);
%L=L1(p1:p2);
L2=L2-mean(L2);
s2=L2(1:length(L2));
t2=0:1/fs1:(length(s2)-1)/fs1;
axes(handles.axes4);
plot(t2(1:length(s2)),s2);
grid on
%xlabel('T/s','FontName','Times New Roman','FontSize',14);
%Plotting finishes.....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state3=('Import complete!');
set(handles.text18,'string',state3);
ifload=1; %set the global variable =1,to show that the loading process is completed
pause(0.7);
h.controls.pause;
%After all the process is done,variable 'ifload' is set
%the h.controls.pause here is added because activeX will automatically
%plays the video after video be loaded.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global v;
global t;   
global s1;
global s2;%%%%%%%%%%%%% s2:ECG;s3:Breathing;s1:Radar
global s3;
global ifload;
global h;
global x;
global extractedBreath;
global zoneIneed;
global timestem;
global Radar_Br;
global Radar_FFT;
%Initializing all global variables....
%%%%%%%%%%%%%%%%%%%%%%%%%%
mins1=min(s1);
maxs1=max(s1);
mins2=min(s2);
mins3=min(s3);
maxs2=max(s2);
maxs3=max(s3);
maxs4=max(extractedBreath);
mins4=min(extractedBreath);

fs=902;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

state4=('Data Loaded/Playing..');
set(handles.text18,'string',state4);
v=1-v;%v here is a indicator whether the video/data is playing or not
%e.g. when v==0 the playing will be stopped
if ifload==0;
    v=0; %When ifload is 0(Data is not loaded properly,)
end;
x=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
if v==1
    h.controls.stop;
h.controls.play;
else
    h.controls.pause;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% To get frequency by fft
% FFT_R=abs(fft(s3(1:length(s3)),2^16)); 
% [hh ll]=max(FFT_R);
% peakfreqBr=ll*50/2^16
global zoneplotratio;
%t1=fix(max(t(1:length(s3))))
t1=length(s3)/256;
zoneplotratio=t1/60
s_fftBr=abs(fft(s3));
tnow=0:1/256:(length(s3)-1)/256;
k=(256/2^16)*[0:(2^16-1)]; %fft 
for i1=1:floor(t1/3)-2
    %s1_fft=s_fftBr(i1:(i1+length(s_fftBr)*(i1+10)/t1),:);
    %s1chunk=s3(length(s3)*(i1)/t1:(length(s3)*(i1+10)/t1),:);
    s1chunk=s3(floor((length(s3)*(i1)/60)):floor((length(s3)*(i1+2)/60)-1),:);
    s1chunk=s1chunk-mean(s1chunk);
    s1_fft=abs(fft(s1chunk,2^16));
    [M,I]=max(s1_fft);
    peakfreqBr=I*256*(1/2^16);
    F_Br(i1)=peakfreqBr;
end

 %t1=fix(max(t(1:length(s2))));
 s_fftHr=abs(fft(s2));
 
 for i1=1:floor(t1/3)-2
    %s1_fft=s_fftBr(i1:(i1+length(s_fftBr)*(i1+10)/t1),:);
    %s1chunk=s3(length(s3)*(i1)/t1:(length(s3)*(i1+10)/t1),:);
    s1chunk=s2(floor((length(s2)*(i1)/60)):floor((length(s2)*(i1+2)/60)-1),:);
    s1chunk=s1chunk-mean(s1chunk);
    %s1_fft=abs(fft(s1chunk,2^16));
    %[M,I]=max(s1_fft);
    [peaks,mn,r] = PeakDetection3(s1chunk,256,s2(1:200),0.45,50)
    %peakfreqBr=I*256*(1/2^16);
    F_Hr(i1)=length(find(peaks>0))/6;
end
 

% tnow=0:1/256:(length(s2)-1)/256;
% for i1=1:(t1-11)
%     s1_fft=s_fftHr(i1:(i1+length(s_fftHr)*(i1+10)/t1),:);
%     [M,I]=max(s1_fft);
%     peakfreqHr=I*256*(1/(length(tnow)))
%     F_Hr(i1)=peakfreqHr;
% end

%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pastime=0;

% switch(v)
%     case 0
%         axes(handles.axes2);
% plot(t(1:length(s1)),m);grid on;
%         axes(handles.axes5);
%         plot(timestem,extractedBreath);grid on;
% axes(handles.axes3);
% plot(t2(1:length(s3)),s3);grid on
% axes(handles.axes4);
% plot(t2(1:length(s2)),s2);grid on
% 
%     case 1  
k=(fs/2^16)*[0:(2^16-1)];
while (v)
    
    tic
if x+3>t1
break;
end

x=x+pastime;

% state33=[(num2str(peakfreqBr)),' Hz'];
% state34=[(num2str(peakfreqHr)),' Hz'];
% set(handles.text33,'string',state33);
% set(handles.text36,'string',state34);
%if x>=1
if x>=1&&x<=(t1-11)
%if x-fix(x)<=0.1
    a=fix(x);



axes(handles.axes6);
%if mod(a,zoneplotratio)==0
if mod(a,3)==0 % it was if mod(a,4)==0 
   

try
Test=zoneIneed;
str1=['PictureNeeded/A3Z' num2str(Test(floor(a/3))) '.png'];
zonepic=imread(str1);
imshow(zonepic);

    state33=[(num2str(F_Br(floor(a/3)))),' Times/sec'];
    state34=[(num2str(F_Hr(floor(a/3)))),' Beats/sec'];
    set(handles.text33,'string',state33);
set(handles.text36,'string',state34);


axes(handles.axes5);
plot(k,Radar_FFT(floor(a/3),:));xlabel('frequency(Hz.)');
ylabel('Normalized magnitude');xlim([0 2]);
grid on
%state33=[(num2str(Radar_Br(floor(a/3)))),' Times/sec'];
%set(handles.text33,'string',state33);

set(handles.edit4,'string',num2str(Radar_Br(floor(a/3))));

%set(handles.text36,'string',state34);
set(handles.text50,'string',Test(floor(a/3)));
set(handles.text51,'string',a);%'Antenna 3');
catch
    nomeaning=1;
end
%end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %移动??Moving the axis
%axes(handles.axes2);   %This command in loop is very low-effcient.
%axes(handles.axes3);
%axes(handles.axes4);


if (x<8 & x>0)
   axes(handles.axes2);
    axis(handles.axes4,[0,x,1.7*mins2,1.7*maxs2]);
    axis(handles.axes3,[0,x,mins3,maxs3]);
    axis(handles.axes2,[0,x,mins1,maxs1]); 
elseif(x>=8)
    axes(handles.axes2);
    axis(handles.axes4,[x-8,x,1.7*mins2,1.7*maxs2]);
    axis(handles.axes3,[x-8,x,mins3,maxs3]);
    axis(handles.axes2,[x-8,x,mins1,maxs1]);
end
%axis(handles.axes5,[x,x+8,mins4,maxs4]);
pause(0.09)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%recover from here
%for i=1:1
    
    %I1=read(readerobj,(i+n));
    %%%%%I1=imrotate(I,180);
    %%%%%axes(handles.axes1);
   %imshow(I1,'parent',handles.axes1);
   %%%%%pause(0.0013);
%end
%n=n+1;
%if n>=numFrames
   % break;

%end
toc;
pastime=toc;
end
if ifload==1
state3=('Finish playing...');
set(handles.text18,'string',state3);
else
    state3=('Loading error...');
set(handles.text18,'string',state3);
end


pause(0.1)
%%
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global v;
v=0;
clear global;
delete(hObject);
close(gcf);

%%
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
%%
function Untitled_3_Callback(~, ~, ~)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DLGNAME=('How to run');
HELPSTRING={'Import Subject:Please select a video file';'';'Plot Data:Please run it after import is complete';'';'Three files are needed:';'.avi video file;radar signal file;and _BELT file ';'';'Notice:The Files should have the same path'};

 HANDLE = helpdlg(HELPSTRING,DLGNAME);


% -------------------------------------------------------------------
%%
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(~, ~, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h;
global v;
global x;
global s2;
global s3;
global s1;
global t;
global extractedBreath;
%global ifload;

v=1-v;
mins1=min(s1);
maxs1=max(s1);
mins2=min(s2);
mins3=min(s3);
maxs2=max(s2);
maxs3=max(s3);
maxs4=max(extractedBreath);
mins4=min(extractedBreath);

switch(v)
    case 0
axes(handles.axes4);   %This command in loop is very low-effcient.
axis(handles.axes4,[x,x+8,1.7*mins2,1.7*maxs2]);
axis(handles.axes3,[x,x+8,mins3,maxs3]);
axis(handles.axes2,[x,x+8,mins1,maxs1]);
axis(handles.axes5,[x,x+8,mins4,maxs4]);
h.controls.pause;
state3=('Data Loaded/Paused');
set(handles.text18,'string',state3);
    case 1
        h.controls.play;
        state3=('Data Loaded/Playing...');
 set(handles.text18,'string',state3);
 pastime=0;
while (v)
    tic
if x+3>max(t)
break;
end
x=x+pastime;

if x-fix(x)<=0.1
    a=fix(x);
   
   % state33=[(num2str(60*F_Br(a))),' Times/sec'];
    %state34=[(num2str(60*F_Hr(a))),' Beats/sec'];
%set(handles.text33,'string',state33);
%set(handles.text36,'string',state34);



axes(handles.axes6);
%if mod(a,zoneplotratio)==0
if mod(a,4)==0
   

try
Test=zoneIneed;
str1=['PictureNeeded/A3Z' num2str(Test(a)) '.png'];
zonepic=imread(str1);
imshow(zonepic);

%set(handles.text36,'string',state34);
set(handles.text50,'string',Test(a));
set(handles.text51,'string','Antenna 3');
catch
    nomeaning=1;
end

end
end
%x=x+0.079813;%This stepping parameter controls the speed of moving the axis
%This value is simply found by doing test multiple times
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %移动??Moving the axis
axes(handles.axes2);   %This command in loop is very low-effcient.
axis(handles.axes4,[x,x+8,1.7*mins2,1.7*maxs2]);
axis(handles.axes3,[x,x+8,mins3,maxs3]);
axis(handles.axes2,[x,x+8,mins1,maxs1]);
axis(handles.axes5,[x,x+8,mins4,maxs4]);
%axis([handles.axes2 handles.axes3 handles.axes4],[x,x+8,mins3,maxs3]);
pause(0.09)
toc
pastime=toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
% if ifload==1
% state3=('Finish playing...');
% set(handles.text18,'string',state3);
% else
%     state3=('Loading error...');
% set(handles.text18,'string',state3);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 end

%%
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
%%
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global zoneNum;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    zoneNum=1;
end

%%
% --------------------------------------------------------------------
function PlotRadarZone_Callback(hObject, eventdata, handles)
% hObject    handle to PlotRadarZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
%%
function PlotAllZone_Callback(hObject, eventdata, handles)
% hObject    handle to PlotAllZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

run('PlotAllZone1');

% --------------------------------------------------------------------
%%
function SelectZone_Callback(hObject, eventdata, handles)
% hObject    handle to SelectZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global selectedBreathing;
global rd1;
global ZoneNum;
global s1;
global t;
global m;
[~,col]=size(rd1);
dlg_title=['Please Select Zone'];
MaxZone=[' ',num2str(col)];
dlg_title1=('Avaliable Zone is from 1 to');
prompt=strcat(dlg_title1,MaxZone);
num_lines=1;
ZoneNum1 = inputdlg(prompt,dlg_title,num_lines);
ZoneNum=str2double(ZoneNum1{1});

L1=rd1(:,ZoneNum);
fs=902; %it was 850
%L=L1(p1:p2);
L=L1-mean(L1);
s1=L(1:length(L));
t=0:1/fs:(length(s1)-1)/fs;

s1=s1/100;
m=s1;
axes(handles.axes2);
plot(t(1:length(s1)),m);
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Breathing_rate_energy_sum_squared,Breathing_rate_energy_sum_window,Breathing_rate_Log_entropy,breathing_rate_moving_average,Breathing_rate_energy_Shannon_squared,Breathing_rate_notch,filtered,extracT] =Breathing(L1);
axes(handles.axes5);
plot(extracT(300:length(filtered)),filtered(300:length(filtered)));
grid on


switch(selectedBreathing)
    case 0
        %selectedBreath=notch;
set(handles.edit4,'string',num2str(Breathing_rate_notch));
set(handles.text45,'string',('notch') );
case 1
        %selectedBreath=notch;
set(handles.edit4,'string',num2str(Breathing_rate_notch));
set(handles.text45,'string',('notch') );
case 2
        selectedBreath=Breathing_rate_Log_entropy;
        set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['Log' char(10) 'entropy'] );
case 3
        selectedBreath=breathing_rate_moving_average;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['moving' char(10) 'average'] );
case 4
        selectedBreath=Breathing_rate_energy_Shannon_squared;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['shannon' char(10) 'squared'] );
case 5
        selectedBreath=Breathing_rate_energy_sum_squared;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['sum' char(10) 'squared'] );
case 6
        selectedBreath=Breathing_rate_energy_sum_window;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['sum' char(10) 'window'] );
end

%%
% --------------------------------------------------------------------
function Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ifload
global ZoneNum
if ifload==1
      dlg_title=['Please start_Time'];
prompt=['Please start_Time'];
num_lines=1;
ZoneNum1 = inputdlg(prompt,dlg_title,num_lines);
start_Time=str2double(ZoneNum1{1});

dlg_title1=['Please stop_Time'];
prompt1=['Please stop_Time'];
num_lines=1;
ZoneNum2 = inputdlg(prompt1,dlg_title1,num_lines);
stop_Time=str2double(ZoneNum2{1});
    run('main');
else
    DLGNAME=('Error');
HELPSTRING={'No Data Loaded'};

 HANDLE = helpdlg(HELPSTRING,DLGNAME);
end

%%
% --------------------------------------------------------------------
function BreathingExtract_Callback(hObject, eventdata, handles)
% hObject    handle to BreathingExtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ifload
if ifload==1
%% 
    run('wavetest');
else
    DLGNAME=('Error');
HELPSTRING={'No Data Loaded'};

 HANDLE = helpdlg(HELPSTRING,DLGNAME);
end


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Reference_Callback(hObject, eventdata, handles)
% hObject    handle to Reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function VideoProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to VideoProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BreathingSignal_Callback(hObject, eventdata, handles)
% hObject    handle to BreathingSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ECGheartrate_Callback(hObject, eventdata, handles)
% hObject    handle to ECGheartrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function RadarSetup_Callback(hObject, eventdata, handles)
% hObject    handle to RadarSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BreathingEstimate_Callback(hObject, eventdata, handles)
% hObject    handle to BreathingEstimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Breathing_rate_energy_sum_window=handles.Breathing_rate_energy_sum_window;
Breathing_rate_Log_entropy=handles.Breathing_rate_Log_entropy;
Breathing_rate_energy_sum_squared=handles.Breathing_rate_energy_sum_squared;
breathing_rate_moving_average=handles.breathing_rate_moving_average;
Breathing_rate_energy_Shannon_squared=handles.Breathing_rate_energy_Shannon_squared;
Breathing_rate_notch=handles.Breathing_rate_notch;
 global selectedBreathing;


run('BreathingRateEstimation');
uiwait

    switch(selectedBreathing)
    case 0
        selectedBreath=Breathing_rate_notch;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',('notch') );
case 1
        selectedBreath=Breathing_rate_notch;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',('notch') );
case 2
        selectedBreath=Breathing_rate_Log_entropy;
        set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['Log' char(10) 'entropy'] );
case 3
        selectedBreath=breathing_rate_moving_average;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['moving' char(10) 'average'] );
case 4
        selectedBreath=Breathing_rate_energy_Shannon_squared;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['shannon' char(10) 'squared'] );
case 5
        selectedBreath=Breathing_rate_energy_sum_squared;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['sum' char(10) 'squared'] );
case 6
        selectedBreath=Breathing_rate_energy_sum_window;
set(handles.edit4,'string',num2str(selectedBreath));
set(handles.text45,'string',['sum' char(10) 'window'] );

    end

% --------------------------------------------------------------------
function HeartEstimate_Callback(hObject, eventdata, handles)
% hObject    handle to HeartEstimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ActivityClassification_Callback(hObject, eventdata, handles)
% hObject    handle to ActivityClassification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PostureClassification_Callback(hObject, eventdata, handles)
% hObject    handle to PostureClassification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function EstimatingZone_Callback(hObject, eventdata, handles)
% hObject    handle to EstimatingZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ErrorSetup_Callback(hObject, eventdata, handles)
% hObject    handle to ErrorSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
