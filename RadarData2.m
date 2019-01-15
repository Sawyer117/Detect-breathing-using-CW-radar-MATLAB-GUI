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

% Last Modified by GUIDE v2.5 07-Sep-2016 13:37:13

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
load parameter selectedBreathing

 if selectedBreathing==0
selectedBreathing=3;
 end
 

axes(handles.axes1)
grid on
axes(handles.axes2)
grid on
axes(handles.axes3)
grid on
axes(handles.axes4)
grid on
% axes(handles.axes5)
% grid on
axes(handles.axes6)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.axes6)
% currentfold=pwd;
% str1=('/PictureNeeded/A3Z0.png');
% str2=strcat(currentfold,str1);
str1=('PictureNeeded/A3Z0.png');
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
%%
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To anyone who's reading this,thanks for reading my code!
% The real functional part of code starts from here and
% the detailed explanation will be given,dont worry!
% The code is roughly written,if you can make any(there are many!) 
% optimization,Don't hesitate to contact wensyaustin@foxmail.com!
%                                       Austin(wen) 3/24/2016 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run('ImportingFile');

run('Preprocessing1');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The code below analyze the breathing and ecg signal from radar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization
global selectedBreathing
global zoneplotratio
global Radar_Br

load parameter WinSizeOverlap
WinSize=WinSizeOverlap(1);
% axes(handles.axes5);
fs=handles.fs;
L1=handles.s1;
rd1=handles.rd1;
t1=length(L1)/fs;
zoneplotratio=t1/60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Giving breathing rate estimation with the code from Prof.Bolic
Radar_Br=zeros(1,floor(t1/3)-2);
[m1,n11]=size(rd1);
%rd1chunck=rd1(1:20*length(Data)/(t1*n11),1:n11);
for i1=1:floor(t1/3)-2
    s1chunk=L1(floor((length(L1)*(i1)/60)):floor((length(L1)*(i1+2)/60-1)),:);
    s1chunk=s1chunk-mean(s1chunk);
    rd1chunck=rd1(1+20*(i1-1)*length(rd1)/(t1*n11):20*i1*length(rd1)/(t1*n11),1:n11);
    if selectedBreathing~=7
    [FFT_R, Breathing_rate,~,filtered,~,Method] =Breathing1(s1chunk,selectedBreathing,fs,WinSize);
    end
    if selectedBreathing==7
        [FFT_R, Breathing_rate,heart,filtered,~,Method] =Breathing1(rd1chunck,selectedBreathing,fs,WinSize);
        Radar_Hr(i1)=heart;
    end
    Radar_Br(i1)=Breathing_rate;
    %Radar_Hr(i1)=heart;
    Radar_FFT(i1,:)=FFT_R;
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[filtered,extracT] =Breathing(L1,selectedBreathing);
extractedBreath=filtered(300:length(filtered));
%timestem=extracT(300:length(filtered));




set(handles.text45,'string',Method);
set(handles.edit4,'string',num2str(extractedBreath));
 %set(handles.text45,'string',Methodtype );

% Update handles structure
guidata(hObject, handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global v;
   
global ifload;
global h;
global x;

global zoneIneed;
global selectedBreathing;


global BreErrReport;
global HrtErrReport;
global aveBreath;
global aveHeart;
%Initializing all global variables....
BreErrReport=[];
HrtErrReport=[];
aveBreath=0;
aveHeart=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s1=handles.s1;
s2=handles.s2;
s3=handles.s3;% s2:ECG;s3:Breathing;s1:Radar
fs=handles.fs;% fs:Radar frequency
rd1=handles.rd1;% rd1:radar signals from all zones
belt=handles.Belt%Belt data from all zones
%tBELT=handles.tBELT;%timestem of belt signal
%tRadar=handles.tRadar;%timestem of radar signal
ref_Breath=handles.ref_Breath;
ref_Heart=handles.ref_Heart;
activity=handles.activity;
%tensecIndicator=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mins1=min(s1);
maxs1=max(s1);
mins2=min(s2);
mins3=min(s3);
maxs2=max(s2);
maxs3=max(s3);
% maxs4=max(extractedBreath);
% mins4=min(extractedBreath);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computing the Breathing frequency and heart rate
global zoneplotratio;

t1=length(s3)/256;
zoneplotratio=fix(t1/60);
% 
% F_Br=zeros(fix(t1/3));
% F_Hr=zeros(fix(t1/3));
%% pre-calculate the Breathing and Heart rate
%for i1=1:floor(t1/3)-2
load parameter WinSizeOverlap
WinSize=WinSizeOverlap(1);
Overlap=WinSizeOverlap(2);
% for i1=1:(t1-WinSize)/Overlap+1
%     %s1_fft=s_fftBr(i1:(i1+length(s_fftBr)*(i1+10)/t1),:);
%     %s1chunk=s3(length(s3)*(i1)/t1:(length(s3)*(i1+10)/t1),:);
%     %s1chunk=s3(floor((length(s3)*(i1)/60)):floor((length(s3)*(i1+2)/60)-1),:);
%     s1chunk=s3((i1-1)*256+1:(i1+WinSize-1)*256);
%     s1chunk=s1chunk-mean(s1chunk);
%     s1_fft=abs(fft(s1chunk,2^16));
%     [~,I]=max(s1_fft);
%     peakfreqBr=I*256*(1/2^16);
%     F_Br(i1)=peakfreqBr;
% end
% 
% 
%  
%  %for i1=1:floor(t1/3)-2
% for i1=1:(t1-WinSize)/Overlap+1
%     %s1chunk=s2(floor((length(s2)*(i1)/60)):floor((length(s2)*(i1+2)/60)-1),:);
%     s1chunk=s3((i1-1)*256+1:(i1+WinSize-1)*256);
%     %s1chunk=s3((i1-1)*256+1:(i1+19)*256);
%     s1chunk=s1chunk-mean(s1chunk);
%     %s1_fft=abs(fft(s1chunk,2^16));
%     %[M,I]=max(s1_fft);
%     [peaks,~,~] = PeakDetection3(s1chunk,256,s2(1:200),0.45,50);
%     %peakfreqBr=I*256*(1/2^16);
%     F_Hr(i1)=length(find(peaks>0))/WinSize;
%  end

%% Plotting
% Radar_FFT1=Radar_FFT;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   initializing the parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pastime=0.01;


k=(fs/2^16)*(0:(2^16-1));


state4=('Data Loaded/Playing..');
set(handles.text18,'string',state4);
v=1-v;%v here is a indicator whether the video/data is playing or not
%e.g. when v==0 the playing will be stopped
if ifload==0;
    v=0; %When ifload is 0(Data is not loaded properly,)
end;
x=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if v==1
    h.controls.stop;
h.controls.play;
else
    h.controls.pause;

end
%%%%%%%%%%%%%%%%%%%%% playing/plotting begins here%%%%%%%%%%%%%%%%%%%
TimeIndicator=0;
while (v)
    
    tic
if x-1>t1
break;
end

x=x+pastime;
if x>=1 && x<=(t1-WinSize)
    a=fix(x);

axes(handles.axes6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
tensecIndicator=1;
set(handles.edit21,'string',[(num2str(ref_Breath(tensecIndicator))),' bpm']);
set(handles.edit22,'string',[(num2str(ref_Heart(tensecIndicator))),' bpm']);
 if mod(x,10)<=0.2 
 if a==TimeIndicator
   continue;
 end
  tensecIndicator=tensecIndicator+1;
 temp1=ref_Breath(tensecIndicator);
temp2=ref_Heart(tensecIndicator);


    state33=[(num2str(temp1)),' bpm'];
    state34=[(num2str(temp2)),' bpm'];
    activity1=activity(tensecIndicator);
% Stationary + Still- 1
% Stationary + No Breathing- 2
% Stationary + Movement- 3
% Walking- 4
if activity1==1
    activitystate=('Stationary&Still');
 elseif activity1==2
    activitystate=('Stationary&No Breathing');
elseif activity1==3
    activitystate=('Stationary&Movement');
elseif activity1==4
    activitystate=('Walking');
end
 
set(handles.edit5,'string',activitystate);
set(handles.edit21,'string',state33);
set(handles.edit22,'string',state34);

 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mod(x,Overlap)<=0.2
    
 if a==TimeIndicator
   continue;
 end
%%%%%%%%%%%%

%%%%%%%%%%%%
% try
Test=zoneIneed;


str1=['PictureNeeded/A3Z' num2str(Test(floor(a/3+1))) '.png']; %to test the accuracy
%str1=['PictureNeeded/A3Z' num2str(Test(floor(a/3))) '.png'];

zonepic=imread(str1);
imshow(zonepic);
% % temp1=F_Br(floor(a/Overlap));
% temp2=F_Hr(floor(a/Overlap));
% 
% 
%     state33=[(num2str(temp1*60,3)),' bpm'];
%     state34=[(num2str(temp2*60)),' bpm'];
% 
% set(handles.edit21,'string',state33);
% set(handles.edit22,'string',state34);


set(handles.text50,'string',Test(floor(a/Overlap)));
set(handles.text51,'string',a);%'Antenna 3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Showing Extracted breathing and heart rate 
selectedBreathing;
if a+WinSize<=t1
%sRadar=s1((a-1)*fs:(a+19)*fs);  %%% sRadar is the chunck of (winsize) seconds
fs=905;

sRadar=s1(round((a-1)*fs):round((a+WinSize-1)*fs)); 


[~,n11]=size(rd1);
 rd1chunck=rd1(round(1+WinSize*(a-1)*length(rd1)/(t1*n11)):round(WinSize*a*length(rd1)/(t1*n11)),1:n11);
 %rd1chunck=rd1(1+19*(a-1)*length(rd1)/(t1*n11):19*a*length(rd1)/(t1*n11),1:n11);
 %[~, Breathing_rate,heart,~,~,Method] =Breathing1(sRadar,selectedBreathing,fs,WinSize);
if selectedBreathing ~= 7
    [~, Breathing_rate,~,~,~,Method] =Breathing1(sRadar,selectedBreathing,fs,WinSize);
[peaks,~,~] = PeakDetection3(sRadarHr,256,s2(1:100),0.45,50);%not sure about chunck length here
Heart_rate=length(find(peaks>0))/WinSize; %here 6 is the window of 6 seconds and we average over 6 seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%保留有效数字 input:Breathing_rate Heart_rate; Output:temp3 temp4 state33 state34
% temp3=num2str(Breathing_rate);
% temp3=temp3(1:3);
% temp3=str2num(temp3);
% temp4=num2str(Heart_rate);
% temp4=temp4(1:4);
% temp4=str2num(temp4);
% state33=[(num2str(temp3*60,3)),' bpm'];
%     state34=[(num2str(temp4*60,3)),' bpm'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state33=[(num2str(Breathing_rate*60,3)),' bpm'];
    state34=[(num2str(Heart_rate*60,3)),' bpm'];
  set(handles.edit4,'string',state33);
  set(handles.edit6,'string',state34);
%   set(handles.text45,'string',Method );
if activity1~=4
 y = downsample(sRadar(52:end),10);
fs111 = 900/10;

y = 2*(y-mean(y))/(max(y)-min(y));
 y = tsmovavg(y, 's', 100);
  y(1:99)=[];
        t222 = 0:1/fs111:10-1/fs111;
        t222(1:99)=[];
[param,CI] = RadarEq_fit(t222,y,[NaN,NaN,NaN],[1e-3,0.25,0]); 
   state33=[num2str(param(2)*60),' Isar_bpm'];
    state34=[  '   '];
    
    save('test.mat' ,'sRadar','param','CI' )
  set(handles.edit4,'string',state33);
  set(handles.edit6,'string',state34);
end
end

if selectedBreathing == 7
    [~, Breathing_rate,heart,~,~,Method] =Breathing1(rd1chunck,selectedBreathing,fs,WinSize);
    Heart_rate=heart;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%保留有效数字 input:Breathing_rate Heart_rate; Output:temp3 temp4 state33 state34
% temp3=num2str(Breathing_rate);
% temp3=temp3(1:4);
% temp3=str2num(temp3);
% temp4=num2str(Heart_rate);
% temp4=temp4(1:4);
% temp4=str2num(temp4);
% state33=[(num2str(temp3*60,3)),' bpm'];
%     state34=[(num2str(temp4*60,3)),' bpm'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state33=[(num2str(Breathing_rate*60,3)),' bpm'];
    state34=[(num2str(Heart_rate*60,3)),' bpm'];
%   set(handles.edit4,'string',state33);
%   set(handles.edit6,'string',state34);
%   set(handles.text45,'string',Method );
%   set(handles.text60,'string','Zach' );

%if activity1~=4

 y = downsample(sRadar(52:end),10);
fs111 = 900/10;

y = 2*(y-mean(y))/(max(y)-min(y));
 y = tsmovavg(y, 's', 10);
  y(1:9)=[];
        t222 = 0:1/fs111:10-1/fs111;
        t222(1:9)=[];
        %save('test.mat' ,'sRadar','param','CI' )
%         save('test.mat' )
[param,CI] = RadarEq_fit(t222,y,[NaN,NaN,NaN],[1e-3,0.25,0]); 
assignin(WS,'name',param)
   state33=[num2str(param(2)*60),' Isar_bpm'];
    state34=[  ' Go  '];
  set(handles.edit4,'string',state33);
  set(handles.edit6,'string',state34);
%end

 
  
end


end
% catch
%     nomeaning=1;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert your code here(the code here are called every 3 seconds)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% error part
%Breathing Error
% absoluteBreErr=abs(F_Br(floor(a/Overlap))-Breathing_rate);
% percentBreErr=abs((Breathing_rate-F_Br(floor(a/Overlap)))/F_Br(floor(a/Overlap)));
% set(handles.edit13,'string',num2str(absoluteBreErr));
% set(handles.edit14,'string',num2str(percentBreErr*100));
% if BreErrReport==0
%     BreErrReport=percentBreErr;
% end
% BreErrReport=[BreErrReport percentBreErr];
% %Heart rate error
% absoluteHeartErr=abs(F_Hr(floor(a/Overlap))-Heart_rate);
% percentHeartErr=abs((Heart_rate-F_Hr(floor(a/Overlap)))/F_Hr(floor(a/Overlap)));
% set(handles.edit15,'string',num2str(absoluteHeartErr));
% set(handles.edit16,'string',num2str(percentHeartErr*100));
% if HrtErrReport==0
%     HrtErrReport=percentHeartErr;
% end
% HrtErrReport=[HrtErrReport percentHeartErr];
% %averange error
% aveBreath=aveBreath+percentBreErr;
% aveHeart=aveHeart+percentHeartErr;
% %aveBreath=aveBreath/floor(a/Overlap);
% %aveHeart=aveHeart/floor(a/Overlap);
% set(handles.edit17,'string',num2str(aveBreath*100/floor(a/Overlap)));
% set(handles.edit18,'string',num2str(aveHeart*100/floor(a/Overlap)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


TimeIndicator=a;

% catch
%     nomeaning=1;
% end

end
end




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
pause(0.05)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% axis(handles.axes5,[x,x+8,mins4,maxs4]);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes(handles.axes2);   %This command in loop is very low-effcient.
axis(handles.axes4,[x,x+8,1.7*mins2,1.7*maxs2]);
axis(handles.axes3,[x,x+8,mins3,maxs3]);
axis(handles.axes2,[x,x+8,mins1,maxs1]);
% axis(handles.axes5,[x,x+8,mins4,maxs4]);
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

[filtered,extracT] =Breathing(L1);
% axes(handles.axes5);
% plot(extracT(300:length(filtered)),filtered(300:length(filtered)));
% grid on




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
rd1=handles.rd1;
    BreathExtract(rd1)
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

run('BreathingRateEstimation');
uiwait



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



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedBreathing
load parameter WinSizeOverlap
param1=WinSizeOverlap(1);
param2=WinSizeOverlap(2);
param=inputdlg({['Window size, Current: ',num2str(param1),'s'],['Overlap(Update time),Current: ',num2str(param2),'s']},'Setting',1,{num2str(param1),num2str(param2)}); 
param1=str2num(param{1});
param2=str2num(param{2});
WinSizeOverlap=[param1,param2];
save parameter selectedBreathing WinSizeOverlap



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BreErrReport
global HrtErrReport
global aveBreath
global aveHeart
load parameter WinSizeOverlap
WinSize=WinSizeOverlap(1);
size1=size(BreErrReport);
Timestem=[];
BreErrReport=[BreErrReport aveBreath]
HrtErrReport=[HrtErrReport aveHeart]
for i=1:size1(1)
    Timestem=[Timestem size1(1)*WinSize]
end
Timestem=[Timestem 0];
Totalreport=[Timestem' BreErrReport' HrtErrReport']
csvwrite('errorReport.csv',Totalreport,1,1)



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
