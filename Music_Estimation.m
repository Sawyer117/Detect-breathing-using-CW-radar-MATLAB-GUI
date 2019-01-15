% This code detects the subject in zones and estimates vital signs
% through MUSIC for each 20 seconds


% reading the data
%FN = ['AK_WALK_3MIN.mat'];

%load(FN)
%Radar = AKWALK3MIN;

% The code is devoloped for scanning zones 6-10 of radar
% In this data zones 4-12 are scanned so I pick zones 6-10
Radar = Radar(:,3:7);


% sampling frequency
fs = fix(size(Radar,1)/180);

% The threshold that identifies presence of the subject

treshold = 0.2;

%prealocation of Estimates
Hr = zeros(1,9);
Br = zeros(1,9);


% Each segment is 20 seconds. There are 9 segmnets in 3 minutes
for Segnum=1:9
    
    Segnum
    start = (Segnum-1)*20;  % start of the segment in seconds
    stop = Segnum*20; % end of the segment in seconds
    Data = Radar(start*fs+1:stop*fs,:);  %The signal in time duration of interest
    
    TargetFmax_matrix = [];  %Matrix of Observations to be filled for this 20 seconds
    
    ind=[];  %indices of start and end of presence of teh subject in each zone
    
    
    %%%%%% Scanning the zones in 20 seconds %%%%%%%%%%%
    for zoneNumber =1:5
        
        
        %%%% the segment of ineterst from zone of interst
        
        Signal_thisZone = Data(:,zoneNumber);
        
        % normalizing
        
        Signal = (Signal_thisZone-mean(Signal_thisZone))/(max(Signal_thisZone) - min(Signal_thisZone));
        
        L = size(Signal,1);
        t =(0:(L-1))/fs;
        
        
        
        %%%%% Detection  %%%%%
        
        %finding the upper envolop
        [YUPPER,YLOWER] = envelope(Signal,floor(fs/2),'peaks');  % getting the envelope
        
        %moving average 
        W_Len = floor(2*fs);  %length of moving average
        vout = tsmovavg(YUPPER', 's', W_Len);
        vout(1: fix(W_Len/2)-1)=[];  %assigning the output of moving average to the middel point
        vout(end+1:end+fix(W_Len/2)-1)=NaN;
        
        % finding the cross between treshold and the output of moving average
        [ind,t0] = crossing(vout,t,treshold);
        
        % if the first index is end of a segment add begining of the
        % segment to indices
        if vout(ind(1))-vout(ind(1)+1)>0
            ind= [1 ind];
        end
        
        %if the last index is start of a segment add end of signal to the
        %indices
        if vout(ind(end))-vout(ind(end)-1)>0
            ind=[ind length(Signal)];
        end
        
        % take all the observations where the subject was in this zone for more than 3 seconds.
        for mm = 1:length(ind)/2
            
            if  (ind(mm*2)-ind((mm-1)*2+1))>3*fs
               
                St = Signal(ind((mm-1)*2+1):ind((mm-1)*2+1)+3*fs);
                L_St = length(St);
                t_St = (0:(L_St-1))/fs;
                
                % calculating TFR of the detected signal
                %
                WT =[];
                freq = [];
                wopt = [];
                [WT,freq,wopt]=wft(St,fs,'f0',0.1,'fmax', 150,'Plot','off','Display','off');
                
                %%% Find instantanious frequencies related to maximum amplitude
                Fmax = [];
                for nn = 1:length(t_St)
                    [a,b(nn)]= max(abs(WT(:,nn)));
                    Fmax(nn) = freq(b(nn));
                end
                Fmax = Fmax-mean(Fmax);  % Remove DC
                
                %add the observed instantanious frequency to the Observation matrix
                TargetFmax_matrix= [TargetFmax_matrix ;Fmax];
               
            end
           
        end
    end
    
    % calculate MUSIC spectrum
    [S,w]= pmusic(TargetFmax_matrix,4,2^16,fs);
    
    % Finding Breathing rate
    [p,loc] = findpeaks(S(w<0.4));
    
    Breathing_rate = w (loc(1))*60
    
    Br(Segnum) = Breathing_rate;
    
    % Finding Heart rate
    [p,loc] = findpeaks(S(w>0.6  & w<1.1));
    
    if ~length(loc)
        % there is not enough resolution in MUSIC to see the intermodualtion
        % peak, therefore the second peak is heart rate
        [p,loc] = findpeaks(S(w>0.6 ));
        Heartrate = (w (loc(1)+44)*60)
    else
        % Heart rate is intermodulation plus twice of breathing rate
        Heartrate = (w (loc(1)+44)*60)+ 2*Br(Segnum)
        
    end
    
    Hr(Segnum) = Heartrate;
end


save('MUSIC_Results.mat','Hr','Br')

