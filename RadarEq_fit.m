function [param,CI]=RadarEq_fit(x,y,fixed_params,initial_params,plot_flag)
% Optimization of parameters of the radr equation function to time series
%
% Syntax:
%       [param]=RadarEq_fit(x,y)       
%
% param = [chest maximum movement, frequency, phaseshift]
%
% if fixed_params=[NaN, NaN , NaN ]        % or fixed_params=[]
% optimization of chest maximum movement, frequency, phaseshift(default)
%

% Example:

% Signal should be normalized 
% %% generate data vectors (x and y)
% f_Radar = @(param,timeval) cos( param(3) + 4*pi/Landa *param(1) * sin( 2*pi*param(2)*timeval );
% param=[1e-3 0.2 0];  % offset, amplitude, phaseshift, frequency
% timevec=0:1/fs:10;
% x=timevec;
% y=f_Radar(param,timevec) + 0.1*randn(size(x));
%
% %% standard parameter estimation
% [estimated_params]=RadarEq_fit(x,y)


% warning off


if nargin<=1 %fail
    disp('fail')   
    return
end

automatic_initial_params=NaN(1,4);
automatic_initial_params(1)=median(y);
automatic_initial_params(2)=mean(minmax(y));
automatic_initial_params(3)=0;
[~,pos]=findpeaks(smooth(y,10));
automatic_initial_params(4)=1/max(diff(x(pos)));

% phas_shift estimator, not working...
% [~,pos]=max(y);
% automatic_initial_params(3)=mod(x(pos),automatic_initial_params(4));

if nargin==2 %simplest valid input
    fixed_params=NaN(1,4);
    initial_params=automatic_initial_params;
    plot_flag=1;    
end
if nargin==3
    initial_params=automatic_initial_params;
    plot_flag=1;    
end
if nargin==4
    plot_flag=1;    
end

if exist('fixed_params','var')
    if isempty(fixed_params)
        fixed_params=NaN(1,4);
    end
end
if exist('initial_params','var')
    if isempty(initial_params)
        initial_params=automatic_initial_params;
    end
end
if exist('plot_flag','var')
    if isempty(plot_flag)
        plot_flag=1;
    end
end

c = 3e8;
f = 24.125e9;
Landa = c/f;

% f_str='f = @(param,timeval)';
% free_param_count=0;
bool_vec=[1 1 1 ];;
% for i=1:4;
%     if isnan(fixed_params(i))
%         free_param_count=free_param_count+1;
%         f_str=[f_str ' param(' num2str(free_param_count) ')'];
%         bool_vec(i)=1;
%     else
%         f_str=[f_str ' ' num2str(fixed_params(i))];
%         bool_vec(i)=0;
%     end
%     if i==1; f_str=[f_str ' +']; end
%     if i==2; f_str=[f_str ' * cos(4*pi/Landa*sin(']; end
%     if i==3; f_str=[f_str ' + 2*pi*']; end
%     if i==4; f_str=[f_str '*timeval ));']; end
% end
f_str = 'f = @(param,timeval)   cos(param(3)+4*pi/Landa*param(1)*sin(  2*pi* param(2)*timeval ));';
eval(f_str)

[BETA,RESID,J,COVB,MSE,ErrorModelInfo] = nlinfit(x,y,f,initial_params(bool_vec==1));

free_param_count=0;
for i=1:3; 
    if isnan(fixed_params(i))
        free_param_count=free_param_count+1;
        param(i)=BETA(free_param_count);
    else
        param(i)=fixed_params(i);
    end    
end

% [ypred,delta] = nlpredci(f,x,BETA,RESID,'Jacobian',J,'Covar',COVB);
% CI = coefCI(f);  
CI = sqrt(diag(COVB));
if plot_flag==1 
    x_vector=min(x):mean(diff(x))/2:max(x);
    plot(x,y,'k-',x_vector,f(BETA,x_vector),'r-')
      xlabel('time (sec)')
    ylabel('Signal')
    legend('Radar','Fitted Radar Equation')
    xlim(minmax(x_vector))
end