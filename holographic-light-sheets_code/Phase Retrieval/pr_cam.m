function [SLM0,Energy] = pr_cam(Psi1,nx,ny,X,Y,gain)
%PR_CAM Performs phase retrieval on target field using the Complex Amplitude Modulation method
%   Detailed explanation goes here
[height,width] = size(Psi1);

ph = angle(Psi1);
mag = abs(Psi1);

SLM0 = mod(gain*mag.*cos(ph) + pi, 2*pi);
Energy = 0;
end

