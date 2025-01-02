function SLM = pr_cam(field,gain)
%PR_CAM Performs phase retrieval on target field using the Complex Amplitude Modulation method
%   Detailed explanation goes here

% normalize field such that average amplitude is 1, then multilply by gain
a_avg = sum(sum(abs(field))) / numel(field);
field_scaled = gain * field / a_avg;

ph = angle(field_scaled);
mag = abs(field_scaled);

SLM = mag .* cos(ph);

end

