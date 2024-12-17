function SLM = pr_macroblock2x2(field)
%PR_MACROBLOCK2X2 Performs phase retrieval on target field using 2x2
%macroblock method
%   Detailed explanation goes here

t1 = angle(field);
t2 = acos(abs(field));
r1 = t1 + t2;
r2 = t1 - t2;

SLM = zeros(size(field));
SLM(1:2:end,1:2:end) = r1(1:2:end,1:2:end);
SLM(2:2:end,2:2:end) = r1(2:2:end,2:2:end);
SLM(2:2:end,1:2:end) = r2(2:2:end,1:2:end);
SLM(1:2:end,2:2:end) = r2(1:2:end,2:2:end);

end

