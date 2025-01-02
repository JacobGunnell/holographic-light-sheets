function [SLM] = pr_uerd(field, gain)
%PR_UERD Perform phase retrieval using Unidirectional Error Diffusion
%(UERD) algorithm.
%   Detailed explanation goes here

[height, width] = size(field);

% normalize field such that average amplitude is 1, then multilply by gain
a_avg = sum(sum(abs(field))) / numel(field);
field_scaled = gain * field / a_avg;

% Floyd-Steinberg error diffusion coefficients
w1 = 7/16;
w2 = 3/16;
w3 = 5/16;
w4 = 1/16;

for row = 1:height-1
    for col = 2:width-1
        % target value
        psi0 = field_scaled(row,col);

        % normalize current pixel
        field_scaled(row,col) = psi0 / abs(psi0);

        % calculate error
        err = field_scaled(row,col) - psi0;

        % diffuse error
        field_scaled(row,col+1) = field_scaled(row,col+1) + w1*err;
        field_scaled(row+1,col-1) = field_scaled(row+1,col-1) + w2*err;
        field_scaled(row+1,col) = field_scaled(row+1,col) + w3*err;
        field_scaled(row+1,col+1) = field_scaled(row+1,col+1) + w4*err;
    end
end

SLM = angle(field_scaled);

end

