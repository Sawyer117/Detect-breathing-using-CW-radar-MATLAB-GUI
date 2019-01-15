function L =signal_from_multiple_zones(x,detectedZone,f)
%x = csvread('AK_WALK_3MIN.csv',1); 
%x = csvread('AK_A3_NB_W_R1.csv',1); 

fs = f;

T = 1/fs;   
zz = 8;
nn = 60;


L=0;
    
    for j = 1:nn
        xx = x(:,detectedZone(j));
        xxx = xx((1+(length(xx)/nn)*(j-1)):((length(xx)/nn)*j),1);
        xxx = xxx-mean(xxx);
        nfft = length(xxx);
        L=[L;xxx];

    end

