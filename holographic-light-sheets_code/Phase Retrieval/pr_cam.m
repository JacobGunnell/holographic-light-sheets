function [SLM0,Energy] = pr_cam(Psi1,nx,ny,X,Y,gain)
%PR_CAM Performs complex amplitude modulation-based phase retrieval on
%provided target waveform
%   Detailed explanation goes here
[height,width] = size(Psi1);

ph = angle(Psi1);
mag = abs(Psi1);

SLM0 = mod(gain*mag.*cos(ph) + pi, 2*pi);
Energy = 0;
end

