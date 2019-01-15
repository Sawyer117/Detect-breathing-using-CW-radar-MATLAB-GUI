function [zoneIneed] =psd1(x,frequency)
%x = csvread('AK_WALK_3MIN.csv',1); 
%x = csvread('AK_A3_NB_W_R1.csv',1); 
%fs=902;
fs = frequency;

T = 1/fs;   
zz = length(x(1,:));
nn = 60;
zoneIneed = zeros(1,11);
for i = 1:zz;
    zone = i;
    xx = x(:,zone);
    t = 0:1/fs:length(xx)/fs;
    %figure(1);
    %subplot(zz,1,i);
    %plot(t(1:length(xx)),xx);
    %ylabel('Amplitude (v)');
    %if (i==1)
         %title('Time domain signal in different zone 6-12: '); 
    %end
%     xlim([0 70]);
%     ylim([-1*10^4 1*10^4]);
    %grid on;
end
    %xlabel('Time(s)');
    
    p = zeros(zz,nn);
    f = zeros(zz,nn);
for i = 1:zz
    zone = i;
    xx = x(:,zone);
    for j = 1:nn
        xxx = xx((1+(length(xx)/nn)*(j-1)):((length(xx)/nn)*j),1);
        xxx = xxx-mean(xxx);
        nfft = length(xxx);
        window = hamming(length(xxx));        
        [p1,~] = periodogram(xxx,window,nfft,fs);
       %figure(j+1);
        %subplot(zz,1,(i));
        %plot(f1,p1);
        %axis([0.1 2 0 1e5]);
        %grid on;
        %if (i==zz)
           % xlabel('f(Hz)');
           % ylabel('PSD');
        %end
        E = sum(p1.^2);
        p(i,j) = E;
    end
end
zone = zeros(1,nn);
for j = 1:nn
    [~, q] = max(p(:,j));
    zoneIneed(1,j) = q;
end
