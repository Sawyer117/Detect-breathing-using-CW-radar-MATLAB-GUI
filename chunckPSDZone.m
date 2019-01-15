FN = ['AK_WALK_3MIN.mat'];

load(FN)
rd1 = AKWALK3MIN;
fs=902;


[m,n]=size(rd1);
%rd1=rd1(:,1);
%rd1=rd1(1:fs*60,1:n)
piece=fix(length(rd1)/(fs*60));
zoneIneed=zeros(1);

for i=1:piece
    rd2=rd1((piece-1)*fs*60+1:piece*fs*60,1:n);
    zone=psd1(rd2);
   
    zoneIneed=[zoneIneed zone];
    
end
zone11221=zeros(1);

