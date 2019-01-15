 global selectedBreathing;
 global fs

 global rd1;

 global zoneNum;
load parameter WinSizeOverlap
WinSize=WinSizeOverlap(1);

pathname=handles.pathname;
filename=handles.filename;
%zoneNum=handles.zoneNum;
global zoneIneed
%% decide which part of belt file should be plotted
beltfile=strcat(pathname,beltfile1);                    %
st2=csvread(beltfile,1,1);                              %

fs1=256;                                                %load belt file    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R1file=strcat(pathname,R1file1);                        %
rd1=csvread(R1file,1,0);                                %load radar file

Timelength=size(st2)/256;                               %and calculate
fs = size(rd1)/Timelength;                              %frequency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting BELT signal 
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
L3=st2(:,BELTzone1);  %%L3 is breathing signal
s3=L3(1:length(L3));
tBELT=0:1/fs1:(length(s3)-1)/fs1;
axes(handles.axes3);
plot(tBELT(1:length(s3)),s3);
grid on
%xlabel('T/s','FontName','Times New Roman','FontSize',14);


L2=st2(:,BELTzone2);   %%L2 is ECG signal
%L=L1(p1:p2);
L2=L2-mean(L2);
s2=L2(1:length(L2));
axes(handles.axes4);
plot(tBELT(1:length(s2)),s2);
grid on



zoneIneed=psd1(rd1,fs); % get the exact zone where people is (psd.m is written by Susie)

if zoneNum==0
zoneNum=1;                       %%%Initialization of zoneNum,need to be deleted later
end

zone=zoneNum;
L1 =signal_from_multiple_zones(rd1,zoneIneed,fs);


L=L1-mean(L1);
s1=L(1:length(L));
tRadar=0:1/fs:(length(s1)-1)/fs;

s1=s1/100;
m=s1;
axes(handles.axes2);
plot(tRadar(1:length(s1)),m);
grid on
%plotting finishes......

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The code below plots the Extracted Breathing rate by different methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


axes(handles.axes5);


t1=length(L1)/fs;
zoneplotratio=t1/60;
% for i1=1:floor(t1/3)-2
%     s1chunk=L1(floor((length(L1)*(i1)/60)):floor((length(L1)*(i1+2)/60-1)),:);
%     s1chunk=s1chunk-mean(s1chunk);
%     [FFT_R, Breathing_rate,filtered,extracT,Method] =Breathing1(s1chunk,selectedBreathing,fs,WinSize);
%     Radar_Br(i1)=Breathing_rate;
%     Radar_FFT(i1,:)=FFT_R;
% end
[m1,n11]=size(rd1);
% for i1=1:floor(t1/3)-2
%     s1chunk=L1(floor((length(L1)*(i1)/60)):floor((length(L1)*(i1+2)/60-1)),:);
%     s1chunk=s1chunk-mean(s1chunk);
%     if i1+20<floor(t1/3)
%     rd1chunck=rd1(1+20*(i1-1)*length(rd1)/(t1*n11):20*i1*length(rd1)/(t1*n11),1:n11);
%     end
%     if i1+20>=floor(t1/3)
%         rd1chunck=rd1(20*(floor(t1/3)-1)*length(rd1)/(t1*n11):20*(floor(t1/3))*length(rd1)/(t1*n11),1:n11);
%     end
% %     if selectedBreathing~=7
% %     [FFT_R, Breathing_rate,~,filtered,~,Method] =Breathing1(s1chunk,selectedBreathing,fs,WinSize);
% %     end
% %     if selectedBreathing==7
% %         [FFT_R, Breathing_rate,heart,filtered,~,Method] =Breathing1(rd1chunck,selectedBreathing,fs,WinSize);
% %         Radar_Hr(i1)=heart;
% %     end
% %     Radar_Br(i1)=Breathing_rate;
% %     %Radar_Hr(i1)=heart;
% %     Radar_FFT(i1,:)=FFT_R;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The code here reads the labelling from Zach
labelfile1='Specifications - Sheet1.csv';
labelfile=strcat(pathname,labelfile1);
label=csvread(labelfile,1,0);

subject=filename(1:2);

if filename(6)=='_'
    posture=filename(4:5);
elseif filename(7)=='_'
    posture=filename(4:6);
elseif filename(8)=='_'
    posture=filename(4:7);
end

if strcmp(subject,'AK')
    subjectNum=1;
elseif strcmp(subject,'IN')
    subjectNum=2;
elseif strcmp(subject,'SW')
    subjectNum=3;
elseif strcmp(subject,'XZ')
    subjectNum=4;
elseif strcmp(subject,'ZB')
    subjectNum=5;
end

if strcmp(posture,'SIT')
    postureNum=1;
    WalkIndicator=0;
elseif strcmp(posture,'LY')
    postureNum=2;
    WalkIndicator=0;
elseif strcmp(posture,'ST')
    postureNum=3;
    WalkIndicator=0;
elseif strcmp(posture,'WALK')
    postureNum=3;
    WalkIndicator=1;
end
if WalkIndicator==0
K=find(label(:,7)==postureNum&label(:,1)==subjectNum);
end
if WalkIndicator==1
K=find(label(:,8)==4&label(:,1)==subjectNum);
end
K=K+1;
K1=min(K);
K2=max(K);
ref_Breath=label(K1:K2,11);
ref_Heart=label(K1:K2,12);
activity=label(K1:K2,8);
handles.ref_Breath=ref_Breath;
handles.ref_Heart=ref_Heart;
handles.activity=activity;







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The code below plots the BELT signal(Ecg in channel 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state3=('Import complete!');
set(handles.text18,'string',state3);
ifload=1; %set the global variable =1,to show that the loading process is completed
pause(0.7);
h.controls.pause;
%After all the process is done,variable 'ifload' is set
%the h.controls.pause here is added because activeX will automatically
%plays the video after video be loaded.
handles.fs=fs;
handles.s1=s1;
handles.s2=s2;
handles.s3=s3;
global belt;
belt=st2;

handles.Belt=st2;
handles.rd1=rd1;
handles.tBELT=tBELT;
handles.tRadar=tRadar;
guidata(hObject,handles);
varargout{1} = handles.output;