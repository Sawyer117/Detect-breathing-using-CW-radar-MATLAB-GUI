%% UWB Radar Breathing Extraction Using FFT of Maximum Power
% Zach Baird
% May 18, 2016
% Carleton University


% clear
% clc
% %% Code Supplied by Flat Earth for real time data
% % Copyright Flat Earth Inc. 2015
% %Create the radar object
% radar = radarWrapper('192.168.7.2', 1);
% % Get a list of the connected modules
% modules = radar.ConnectedModules;
% % Open a connection to the radar module
% radar.Open(modules{1});
%     % radar.getEnumItems('Gain')
% % Calibrate the radar module
% tic
% result = radar.ExecuteAction('MeasureAll');
% toc
% % Set the TX voltage on the Ancho Module
%     % radar.SetVoltage(1.1);
% % Get some register values
% IterationsDefaultValue = radar.Item('Iterations');
% offsetdistance = radar.Item('OffsetDistanceFromReference');
% samplers = radar.Item('SamplersPerFrame');
% % Get the CDF
%     % cdf = radar.getCDF();
% % Set some register values
% radar.TryUpdateChip('SampleDelayToReference',2.9e-9);
% radar.TryUpdateChip('Iterations','50');
% radar.TryUpdateChip('DACMin','0');
% radar.TryUpdateChip('DACMax','8191');
% radar.TryUpdateChip('DACStep','4');
% radar.TryUpdateChip('PulsesPerStep','16');
% radar.TryUpdateChip('FrameStitch','1');
% % Check that it set the value for the iterations value by re-reading it
% IterationsSetValue = radar.Item('Iterations')
% % Collect a bunch of raw frames and compute the average FPS
% tic;
% t1=toc;
% subplot(1,1,1)
% plotTime = 60;      %Run the plot for this many seconds
% fpsFrames = 0;      %Number of frames collected in the time period
% % Record Clutter for removal
% clutter = double(radar.GetFrameRaw);
% while (1)
%     fpsFrames= fpsFrames+1;
%     newFrame1 = double(radar.GetFrameRaw);
%     % Create Matrix of Data
%     matrix(fpsFrames, 1:length(newFrame1))=newFrame1-clutter;
%     plot(abs(newFrame1-clutter)) % For more intuitive display
%     drawnow
% %     disp(fpsFrames)
%     if (toc>plotTime)
%         break
%     end
% t2=toc;
% FPS_RAW = fpsFrames/(t2-t1); 
% end

%% Record Data
% filename='C:\Users\Zach\Desktop\ZB_May18.xlsx';
% xlswrite(filename,matrix);

%% Import Data
%filename1='C:\Users\Zach\Desktop\ZB_May18.xlsx'
%Data = xlsread(filename1);

%% Analyzing Data
%Data = matrix;  Need to be recovered ?“¾?Œ´
function BreathExtract(Data)

N=length(Data(:,1));
t=linspace(0,60,N);
% Find distance to peak received power
for i=1:N
    [M I]=max(Data(i,:));
    d(i)=I;
end
% Filter Out high frequency noise
[b,a] = butter(3,1/(N/60),'low'); 
dataOut = filter(b,a,detrend(d)); % Remove Mean so DC sidelobes don't obscure data

figure(1)
plot(t,dataOut)
figure(2)
for z=1:6
% Perform FFT with zero padded segment of data
y=[dataOut(1+floor(N/6)*(z-1):floor(z*N/6)) , zeros(2^16-length(dataOut(1+floor(N/6)*(z-1):floor(z*N/6))),1)'];
Y=fft(y);
L=length(Y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
Fs=N/60;
f = Fs*(0:(L/2))/L;
subplot(2,3,z);
plot(f,P1)
xlim([0 3])
end
% axis([0 5 0 1])
% title('Single-Sided Amplitude Spectrum of S(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
