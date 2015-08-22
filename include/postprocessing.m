function [ zeta, w2_w1, gamma, beta ] = postprocessing( pRaw, k_gamma_n, k_beta_n, gamma_n, beta_n, k_pt_n, k_p_n)
%postprocessing calculates the loss coefficient zeta and the velocity
%ration w2_w1, as well as further values such as the angles gamma and beta.
%input are the raw pressures in pascal and the the calibration data
%use this function in order to evalutate mesured raw pressures pRaw
%can be adapted to a 7 hole probe, since the input vector pRaw specifies
%contains all pressures.
%
%written by Simon D. Schmidt on May 2015

p1 = pRaw(1);
p2 = pRaw(2);
p3 = pRaw(3);
p4 = pRaw(4);

p0 = pRaw(5); % center hole

pTot = pRaw(8);
pStat = -pRaw(9);

p = [p1 p2 p3 p4 p0]; % probe pressures

sum1 = rms(p(1:5) - mean(p(1:5))) + p0 - mean(p(1:4)); % sum_1 %checked
k_gamma = (p(3) - p(1) )/sum1; % k parameters
k_beta = (p(4) - p(2) )/sum1;

    %out %out
[gamma, beta, k_pt, kp] = interpoly( gamma_n, beta_n, k_gamma_n, k_beta_n, k_pt_n, k_p_n, k_gamma, k_beta );
        
dp = p0 - pStat - kp * sum1;
delta_p_tot = pTot - p0 - k_pt * sum1;
q1 = pTot - pStat;

% out
zeta = delta_p_tot/q1; 

q2_q1 = 1. - zeta - dp/q1;

% out
w2_w1 = real(sqrt(q2_q1));

% out out out
%w2_w1_x = w2_w1 * cos( gamma * pi/180. ) * cos( beta * pi/180. );
%w2_w1_y = w2_w1 * sin( gamma * pi/180. );
%w2_w1_z = w2_w1 * cos( gamma * pi/180. ) * sin( beta * pi/180. );
end

