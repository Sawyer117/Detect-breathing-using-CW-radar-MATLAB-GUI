%% Extracting breathing, second harmonic, and heart rate from CW radar data
% Author: Zach Baird
% Institution: Carleton University
% Date: June 9, 2016
% Description: This code starts by importing xlsx files of radar data and bio capture
% data (ECG in channel 1, breathing belt in channel 2). After importing,
% the radar data is filtered using a 3rd order bandpass butterworth filter with
% passband of 0.1-2Hz. The target is localized by finding the zone where
% the skewness value is at its lowest. The data in the zone containing the
% human is selected for further processing. A 1024 point chirp transform is
% applied between the frequency bounds of 0-2Hz. Breathing is then
% estimated by sliding two harmonically spaced windows of width 0.0391Hz
% (20 sample points) across the breathing range of the chirp transform, the 
% sum of all points in both windows is recorded in a vector and the maximum value 
% is taken as the fundamental breathing frequency. The second harmonic of breathing is
% found by searching for a peak near twice the fundamental frequency. The heart rate 
% is estimated similarly to the breathing rate; it is expected that there will be 
% intermodulation products between the heart beat and breathing movement,
% so three windows of 0.0391Hz width are slid across the chirp transform
% data, the windows are spaced according to the heart beat and
% intermodulation products of the heart beat and (known) breathing rate.
% Thus, the windows are placed at fh-fb, fh, fh+fb, where fh is heart beat
% frequency, fb is fundamental breathing rate. Once the estimate is found,
% the peak nearest to the estimate is chosen for the heart rate estimate.
% *Note: This code is intended only for data recorded with a stationary
% target. 
function [breathing, breathing2, heart]=june9CW(radarData,beltData,recordingtime)
%% Import Recorded Data

% Radar Data
%filename1='C:\Users\WEN\Desktop\GUI\Modified GUI\TestingData\AK_SIT_3MIN.csv';
%filename1='C:\Users\Zach\Desktop\CW_MAY25\IN_LY_3MIN.xlsx'
%Data = xlsread(filename1);
%Data = csvread(filename1,1,0);
recording_time=recordingtime; % Must enter the value of recording time in seconds
Data=radarData;

% Belt Data
%filename2='C:\Users\WEN\Desktop\GUI\Modified GUI\TestingData\AK_SIT_3MIN_BELT.csv';
%filename2='C:\Users\Zach\Desktop\CW_MAY25\IN_LY_3MIN_belt.xlsx'
%belt = csvread(filename2,1,1);
belt=beltData;
%% Filter Data
%global fs
%fs=fix(fs);
fs=length(Data(:,1))/recording_time; % sampling rate in slow time
% time=linspace(0,recording_time,length(Data(:,1)));
% fs_b=256; % sampling rate of belt

% figure(1)
for i=1:length(Data(1,:))
    
[~,~] = butter(4,0.35/fs,'high'); % 0.1Hz highpass
%Data(:,i) = filter(b,a,(Data(:,i))); 
Data(:,i)=detrend(Data(:,i));
[b,a] = butter(5,8/fs,'low'); % 4Hz lowpass
Data(:,i) = filter(b,a,(Data(:,i))); 

% subplot(3,3,i) %plot of data in each zone
% plot(time,Data(:,i))

end

%% Partition Data

div=fix(recording_time/20); % Number of 10 second segments
% recording_time=20;
num=1; % Which 10 second segment to look at (min number =1)
Data = Data((num-1)*floor(length(Data(:,1))/div)+1:num*floor(length(Data(:,1))/div),:);


belt = belt((num-1)*floor(length(belt(:,1))/div)+1:num*floor(length(belt(:,1))/div),:);
% belt_H= belt(:,1); % ECG
% belt_B= belt(:,2); % breathing

%% Choose zone that breathing lies in based on lowest skewness
skew=skewness(Data);
[~, ind]=min(abs(skew)); % skewness will be lowest where non-random signal is present
breathing=Data(:,ind);

breathing=breathing/max(abs(breathing)); % Normalize data
win = blackman(length(breathing));
breathing=breathing.*win;

% figure(2)
% time=linspace(0,recording_time,length(Data(:,1)));
% plot(time,breathing)
% title('Normalized breathing signal extracted from data')
% xlabel('time (s)')
% ylabel('magnitude')

%% Perform chirp transform on Radar Data

m=2048; % number of sample points to calculate for chirp transform 
f1 = 0; % lower frequency bound of chirp transform
f2 = 4; % upper frequency bound of chirp transform
w = exp(-1i*2*pi*(f2-f1)/(m*fs)); % arc in unit circle of z domain is defined by w and a
a = exp(1i*2*pi*f1/fs);
z = czt(breathing,m,w,a); % chirp transform
fn = (0:m-1)'/m; % normalized frequency vector
fy = fs*fn; % un-normalized frequency vector
fz = (f2-f1)*fn + f1; % adding back f1 (in case f1 is not zero)

% figure(3)
% subplot(3,1,1)
% plot(fz,abs(z))
% title('Chirp transform of breathing signal')
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% hold on
%% Search for breathing peak + harmonic

for i=80:175 % only need to search in small range (1 sample point = 2/1024 = 0.002Hz)
    mag_b(i)=sum(abs(z(i:i+20)))+0.5*sum(abs(z(2*i:2*i+20)))+0.5*sum(abs(z(3*i:3*i+20))); % harmonically spaced windows of width =20 samples
end

[~, index_b]=max(mag_b); % find index with largest power
breathing_ind=index_b+10; % offset by half the window length (to find center)

[~, I]=max(abs(z(breathing_ind-25:breathing_ind+25))); % search for peak near estimate
breathing_ind=I+breathing_ind-26; % offset by window offset
breathing=fz(breathing_ind); % find actual frequency
feature_vector(1)=fz(breathing_ind);
feature_vector(2)=abs(z(breathing_ind));

[~, I]=max(abs(z(2*breathing_ind-25:2*breathing_ind+25))); % search for peak near estimate
breathing2_ind=I+2*breathing_ind-26; % offset by window offset
breathing2=fz(breathing2_ind); % find actual frequency
feature_vector(3)=fz(breathing2_ind);
feature_vector(4)=abs(z(breathing2_ind));

feature_vector(5)=feature_vector(2)/feature_vector(4);

%% Search for Heart Rate

for i=450:800 %window corresponding to 0.78-1.5625Hz
    interm=(index_b+10); % breathing rate (for finding intermodulation components)
    mag_h(i)=0.5*sum(abs(z(i:i+20)))+sum(abs(z(i-interm-10:i-interm+30)))+sum(abs(z(i+interm-10:i+interm+30)));%+0.5*sum(abs(z(i-2*interm-10:i-2*interm+30)))+0.5*sum(abs(z(i+2*interm-10:i+2*interm+30))); % three 20 sample wide windows centered at fh-fb, fh, fh+fb
end

[~, index]=max(mag_h); % find index with largest power
heart_ind=index+10; % offset by half the window length (to find center)


%[M I]=max(abs(z(heart_ind-25:heart_ind+25))); % search for peak near estimate
%heart_ind=I+heart_ind-26; % offset by window offset
heart=fz(heart_ind); % find actual frequency
feature_vector(6)=fz(heart_ind);
feature_vector(7)=abs(z(heart_ind));

feature_vector(8)=feature_vector(2)/feature_vector(7);

% plot(fz(breathing_ind),abs(z(breathing_ind)),'r*')
% plot(fz(breathing2_ind),abs(z(breathing2_ind)),'r*')
% plot(fz(heart_ind),abs(z(heart_ind)),'r*')


%% Perform chirp transform on Belt Data

% Breathing- Channel 2
% m=2048; % number of sample points to calculate for chirp transform 
% f1 = 0; % lower frequency bound of chirp transform
% f2 = 4; % upper frequency bound of chirp transform
% w = exp(-1i*2*pi*(f2-f1)/(m*fs_b)); % arc in unit circle of z domain is defined by w and a
% a = exp(1i*2*pi*f1/fs_b);
% z = czt(belt_B,m,w,a); % chirp transform
% fn = (0:m-1)'/m; % normalized frequency vector
% fy = fs_b*fn; % un-normalized frequency vector
% fz = (f2-f1)*fn + f1; % adding back f1 (in case f1 is not zero)
% 
% % subplot(3,1,2)
% % plot(fz,abs(z))
% % title('Chirp transform of breathing signal (Belt)')
% % xlabel('Frequency (Hz)')
% % ylabel('Magnitude')
% 
% % ECG- Channel 1
% m=2048; % number of sample points to calculate for chirp transform 
% f1 = 0; % lower frequency bound of chirp transform
% f2 = 4; % upper frequency bound of chirp transform
% w = exp(-1i*2*pi*(f2-f1)/(m*fs_b)); % arc in unit circle of z domain is defined by w and a
% a = exp(1i*2*pi*f1/fs_b);
% z = czt(belt_H,m,w,a); % chirp transform
% fn = (0:m-1)'/m; % normalized frequency vector
% fy = fs*fn; % un-normalized frequency vector
% fz = (f2-f1)*fn + f1; % adding back f1 (in case f1 is not zero)
% % 
% % subplot(3,1,3)
% % plot(fz,abs(z))
% % title('Chirp transform of breathing signal (ECG)')
% % xlabel('Frequency (Hz)')
% % ylabel('Magnitude')
% % 
% % figure(4)
% % [b,a] = butter(4,0.2/fs,'high'); % 0.1Hz highpass
% % [h,w] = freqz(b,a,100000);
% % plot(fs*w/pi,20*log10(abs(h)))
% % axis([0 4 -50 10])
