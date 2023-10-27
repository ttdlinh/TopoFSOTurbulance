function BER_FSO=BER_FSO(L)
%%
% Function for calculating BER
% P      transmitting power (dBm)
% L      distance (m)
% R_b    Bit rate (bps)
%% Receiver parameter
r = 0.1;            %(m)          %radius receiver aperture
sigma_s = 0.1;                    %the pointing error displacement standard deviation (jitter) at the receiver
%% Transmittion parameter
R_b = 10^9;              % bit rate 1 Gbps
P = 0;                  % 0 dBm
Pt = 10^((P/10)-3);      %(W)
omega_z = 2.5*L/1000;    %(m)          %the beam waist
v=(sqrt(pi)*r)/(sqrt(2)*omega_z);
omega_zeq=sqrt((omega_z^(2)*sqrt(pi)*erf(v))/(2*v*exp(-v^2))); %the equivalent beam width
%% channel parameter
Cn2 = 10^-14;            %tubulence strength 
lamda = 1550*10^-9;               %wavelength (m)
sigma_n = 10^(-16)*R_b;  %(A/Hz)  %nosie standard deviation

%%
a_l = 0.1;                         %attenuation coefficient
h_l = exp(-a_l*L/1000);     %attenuation of optical power through the atmospheric

sigma_R = 1.23*(2*pi/lamda)^(7/6)*Cn2*L^(11/6);                              %the Rytov variance
alpha = (exp((0.49*sigma_R)/(1+1.11*(sigma_R)^(6/5))^(7/6))-1)^-1;           %strong turbulence fading parameter
beta = (exp((0.51*sigma_R)/(1+0.69*(sigma_R)^(6/5))^(5/6))-1)^-1;            %weak turbulence fading parameter

gamma_alpha = gamma(alpha);     %denotes Gamma function (when anpha >0 the effective numbers of small-scale eddies of scattering environment, respectively)
gamma_beta = gamma(beta);
%%
% 
%   for x = 1:10
%       disp(x)
%   end
% 
gamma_p = omega_zeq/(2*sigma_s);        %the ratio between the equivalent beam radius at the receiver and the pointing error displacement standard deviation at the receiver)
Ao=(erf(v))^2;                 %the fraction of the collected power at the poiting error =0
% Meijer function
a1=(2-gamma_p^2)/2;
a2=(1-alpha)/2;
a3=(2-alpha)/2;
a4=(1-beta)/2;
a5=(2-beta)/2;
a6=1;
b1=0;

b2=1/2;
b3=(-gamma_p^2)/2;
z=(16*Pt^2*Ao^2*h_l^2)/(sigma_n^2*alpha^2*beta^2); % parameter of meijer
BER_FSO = (((2^(alpha+beta-3)*gamma_p^2)/sqrt(pi^3)/gamma_beta/gamma_alpha)*MeijerG({[a1,a2,a3,a4,a5],[a6]},{[b1,b2], [b3]},z));                %bit error rate

