function SLM = pr_cam(Psi1,gain)
%PR_CAM Performs phase retrieval on target field using the Complex Amplitude Modulation method
%   Detailed explanation goes here

ph = angle(Psi1);
mag = abs(Psi1);

if length(gain) > 1
    gain_reshaped = reshape(gain, 1, 1, []); % if gain is a 1d array with multiple gains, apply each gain in a separate slice of the resulting array
    SLM = mod(gain_reshaped .* mag .* cos(ph) + pi, 2*pi);
else
    SLM = mod(gain * mag .* cos(ph) + pi, 2*pi);
end
end

