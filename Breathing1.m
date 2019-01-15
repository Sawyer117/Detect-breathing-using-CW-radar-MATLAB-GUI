function [FFT_R, Breathing_rate,heart,filtered,t,Method] =Breathing1(L,method,f,~)
%x=csvread('AK_WALK_3MIN.csv',1);
%prompt = 'In which zone you are looking? ';
%zone = 4; %input(prompt);
%prompt2 = 'What is the acual sampling frequency? ';
%fs2=1750; %input(prompt2);
global selectedBreathing
tic
fs2=f;
Fs=f;
%prompt1 = 'What is the desired sampling frequency? ';
fs=50;%fs=50; %input(prompt1);
load Breathparam WinSize
WinSize1=WinSize;
%L=x(:,zone);
%signal1=L(15000:110000);
signal1=L(1:length(L));
%signal1=L;
%signal=downsample(signal,fs);
signal=decimate(signal1,fix(fs2/fs));
t=0:1/fs:length(signal)/fs;
% plot(t(1:length(signal)),signal);xlabel('Time (s)');ylabel('Amplitude (v)');
% %xlim([0 120]);
% grid;title('Time domain signal');
k=(fs/2^16)*[0:(2^16-1)]; %fft 
%Apply Highpass filter
a=[1, -1];% x(n)-x(n-1)=x(n)
b=1;
filtered1 = filter(a,b,signal);
filtered1=filtered1-mean(filtered1);
%Apply IIR Butterworth bandpass filter (cutoff=0.1~1 Hz)
%%using BPF applied for every range bin
nn=3;
s1=(0.2)/fs;%normalized pass frequency %Note: 0.2 is the low pass multiplied by 2 (means f_l=0.1 Hz)
s2=1*(2)/fs;%normalized pass frequency
[b11,a11] = butter(nn,[s1 s2],'bandpass');%escond bandpass butter worth filter from 0.3-0.8 hz
filtered = filter(b11,a11,(filtered1 ));


% figure;
% plot(t(300:length(filtered))plo,filtered(300:length(filtered)));xlabel('Time (s)');ylabel('Amplitude (v)');
% %xlim([0 240]);
% grid;title('the BP filtered signal');


FFT_R=abs(fft(signal(1:length(filtered)),2^16)); % change number of fft freq. points
FFT_R=FFT_R/max(FFT_R);
% % figure;plot(k,FFT_R/max(FFT_R));xlabel('frequency(Hz.)');grid;
% % ylabel('Normalized magnitude');xlim([0 2]);title('FFT of BPF of breathing signal ');
% [hh ll]=max(FFT_R);
% breathing_rate_without_processing=ll*50/2^16
% moving average
if selectedBreathing~=7
c=filtered;
%c1 = smooth(c,75);%tsmovavg(c,'s',75,1);
c4=zeros(length(filtered),1);
c4(75:length(filtered))=c4(75:length(filtered));
c3=filtered-c4;
end
%c3=signal/max(signal);
%tic
%for i=1:100
% FFT_R=abs(fft(c3(1:length(c3)),2^16));
% [hhh lll]=max(FFT_R);
% breathing_rate_moving_average=lll*fs/2^16
%figure;plot(k,FFT_R/max(FFT_R));xlabel('frequency(Hz.)');grid;
%ylabel('Normalized magnitude');xlim([0 2]);title('FFT of BPF of breathing signat + MA (2 sec.)');
%end
%toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% This is the notch-based algorithm. 
if (method==1)
Fs = fs;
%D=1000;%number of the FFT points in the human breathing range
%E=zeros(1,D);% the summation of the energy

%i=1;

%for i=1:100

triad=Fs/2^16:Fs/2^16:Fs/25;
E=zeros(1,length(triad));
%for i=Fs/2^16:Fs/2^16: Fs/25
for i=1:length(triad)
Fc = [ triad(i)*1 triad(i)*2 triad(i)*3];
Wc = Fc/(Fs/2); % the band wieth of 3 db at notch filter fc
BW = Wc/100;% Fc(3)
mycomb = zeros(3,6);
[b1,a1] = iirnotch(Wc(1),BW(1));
mycomb(1,:) = [b1,a1];
[b2,a2] = iirnotch(Wc(2),BW(2));
mycomb(2,:) = [b2,a2];
[b3,a3] = iirnotch(Wc(3),BW(3));
mycomb(3,:) = [b3,a3];
Y = sosfilt(mycomb,c3);
Y_fft=abs(fft(Y)).^2;
%figure;plot(k,Y_fft);xlim([0 2]);
E(1,i)=sum(Y_fft); % signal-(notch filter at three freq. harmonic), so the minimal one is the breathing rate 

end
[E1 I]=min(E);
Breathing_rate_notch=triad(I);%I*0.001
Breathing_rate=Breathing_rate_notch;
heart=0;
Method=('notch');
%end

%figure;plot([0.001:0.001:1],E);grid;title('Energy after applying Notch filter');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the rectangular moving window algorithm where the size of the window is winsize samples
elseif (method ==2)
winsize=WinSize1;
w=fix(winsize./2);

C3_fft=abs(fft(c3, 2^16));
D_c3=floor(2^16/3);
E_c3=zeros(1,D_c3-w);
for i=1+w:D_c3-2
        E_c3(i)=sum(C3_fft(i-w:i+w).^1)+sum(C3_fft(2*i-w:2*i+w).^1)+sum(C3_fft(3*i-w:3*i+w).^1);
end
[~, I_c3]=max(E_c3);
Breathing_rate_energy_sum_window=k(I_c3);
Breathing_rate=Breathing_rate_energy_sum_window;
Method=('Sum_window');
heart=0;

% figure;plot(k(1:D_c3-2),E_c3);grid;title('Energy after applying 3 windows');
% xlim([0.1 2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the algorithm based on the sum on squared values of 3 frequency harmoonics
elseif(method==3)

C3_fft=abs(fft(c3, 2^16));
D_c3=floor(2^16/3);
%%%%%%%%%%%%%%%%%%%%%%%
%inserted,otherwise won't work
winsize=WinSize1;
w=fix(winsize./2);
E_c3=zeros(1,D_c3-w);
%%%%%%%%%%%%%%%%%%%%%%%
E_c3=zeros(1,length(E_c3));
for i=1:D_c3
        E_c3(i)=C3_fft(i)^2+C3_fft(2*i)^2+C3_fft(3*i)^2;
end
[~, I_c3]=max(E_c3);
Breathing_rate_energy_sum_squared=k(I_c3);
Breathing_rate=Breathing_rate_energy_sum_squared;
Method=('Sum_squared');
heart=0;

% figure;plot(k(1:D_c3),E_c3);grid;title('Energy after applying summation of 3 squared elements');
% xlim([0.1 2]);
%**********************************************************************************
% Calculate the Shannon Energy
elseif(method==4)

C3_fft=abs(fft(c3, 2^16));
D_c3=floor(2^16/3);
%%%%%%%%%%%%%%%%%%%%%%%
%inserted,otherwise won't work
winsize=WinSize1;
w=fix(winsize./2);
E_c3=zeros(1,D_c3-w);
%%%%%%%%%%%%%%%%%%%%%%%
E_c3=zeros(1,length(E_c3));
for i=1:D_c3
        E_c3(i)=-(C3_fft(i))^2*log(C3_fft(i))^2+(-1)*(C3_fft(2*i))^2*log(C3_fft(2*i))^2+(-1)*C3_fft(3*i)^2*log(C3_fft(3*i))^2;
end
[~, I_c3]=min(E_c3);
Breathing_rate_energy_Shannon_squared=k(I_c3);
Breathing_rate=Breathing_rate_energy_Shannon_squared;
Method=('Shannon_squared');
heart=0;

% figure;plot(k(1:D_c3),E_c3);grid;title('Energy after applying summation of 3 Shannon Energy elements');
% xlim([0.1 2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Calculate Log entropy
elseif(method==5)

C3_fft=abs(fft(c3, 2^16));
D_c3=floor(2^16/3);
%%%%%%%%%%%%%%%%%%%%%%%
%inserted,otherwise won't work
winsize=WinSize1;
w=fix(winsize./2);
E_c3=zeros(1,D_c3-w);
%%%%%%%%%%%%%%%%%%%%%%%
E_c3=zeros(1,length(E_c3));
for i=1:D_c3
        E_c3(i)=log(C3_fft(i))^2+log(C3_fft(2*i))^2+log(C3_fft(3*i))^2;
end
[~, I_c3]=max(E_c3);
Breathing_rate_Log_entropy=k(I_c3);
Breathing_rate=Breathing_rate_Log_entropy;
Method=('Log_entropy');
heart=0;

%%figure;plot(k(1:D_c3),E_c3);grid;title('Energy after applying summation of 3 log entropy elements');
%%xlim([0.1 2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use subspace methods
elseif (method==6)
[C3,~]=pmusic(c3,32,2^16,Fs,256,128);
[vals,locs,width,prom]=findpeaks(C3,Fs);
Breathing_rate=locs(1);
Method=('Subspace method');
heart=0;

elseif (method==7)
    global rd1
    global belt
    
%     rd1=handles.rd1;% rd1:radar signals from all zones
% belt=handles.Belt;%Belt data from all zones

    [Breathing_rate1, Breathing_rate2, heart1]=june9CWSourceCode(L,belt);
    Breathing_rate=Breathing_rate1;
    heart=heart1;
    Method=('Chirp trans');
end
toc
timecost=toc;
