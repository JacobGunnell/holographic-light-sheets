function SLM = pr_macroblock2x2(field, gain)
%PR_MACROBLOCK2X2 Performs phase retrieval on target field using 2x2
%macroblock method
%   Detailed explanation goes here

% normalize field such that average amplitude is 1, then multilply by gain
a_avg = sum(sum(abs(field))) / numel(field);
field_scaled = gain * field / a_avg;

t1 = angle(field_scaled);
t2 = acos(min(abs(field_scaled),1)); % truncate values greater than 1
r1 = t1 + t2;
r2 = t1 - t2;

SLM = zeros(size(field));
SLM(1:2:end,1:2:end) = r1(1:2:end,1:2:end);
SLM(2:2:end,2:2:end) = r1(2:2:end,2:2:end);
SLM(2:2:end,1:2:end) = r2(2:2:end,1:2:end);
SLM(1:2:end,2:2:end) = r2(1:2:end,2:2:end);

end

