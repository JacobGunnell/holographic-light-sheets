function SLM = pr_gerchberg_saxton(field, lambda, pixel_pitch, axicon_max, iterations, power_factor, mask_scale_factor)
%PR_GERCHBERG_SAXTON Performs phase retrieval using the Gerchberg-Saxton
%technique
%   Detailed explanation goes here

[height, width] = size(field);
x = linspace(1,width);
y = linspace(1,height);
[X, Y] = meshgrid(x, y);

% amplitude of illuminating beam
amplitude_SLM = ones(size(field));
% maximize the total power delivered to the goal field by setting the initial
% guess to the ifft2 of the goal field, AKA phase-only
phase_SLM = angle(field);
goal_Fourier = fftshift(fft2(field));

offset_angle = 0;
center = [height width] * sin(offset_angle / sqrt(2)) / (lambda * pixel_pitch) + 0.5;
width = [height width] * mask_scale_factor * sin(axicon_max) / (lambda * pixel_pitch);
mask = double( (X-center(2))^2 / width(2)^2 + (Y-center(1))^2 / width(1)^2 <= 1);

for i = 1:iterations
    actual_Fourier = fftshift(fft2(amplitude_SLM * phase_SLM));
    corrected_Fourier = goal_Fourier .* mask * power_factor + actual_Fourier .* (1 - mask);
    phase_SLM = angle(ifft2(ifftshift(corrected_Fourier)));
end

SLM = phase_SLM;

end

