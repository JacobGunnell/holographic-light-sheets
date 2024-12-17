function output_field = spatial_filter(input_field, pixel_pitch, cutoff_radius, cutoff_shift)
% SIMULATE_4F_LOWPASS Simulate a 4f optical system with a low-pass filter.
%
% Parameters:
% input_field   - 2D complex field at the input plane
% wavelength    - Wavelength of light (m)
% pixel_pitch   - Pixel size in spatial domain (m)
% cutoff_radius - Cutoff frequency radius for low-pass filtering (1/m)
% cutoff_shift  - Passband center coordinates (y,x)
%
% Returns:
% output_field  - 2D complex field at the output plane

% Get the size of the input field
[n_y, n_x] = size(input_field);

% Define spatial frequency coordinates
fy0 = cutoff_shift(1);
fx0 = cutoff_shift(2);
fx = linspace(-1/(2*pixel_pitch)-fx0, 1/(2*pixel_pitch)-fx0, n_x);
fy = linspace(-1/(2*pixel_pitch)-fy0, 1/(2*pixel_pitch)-fy0, n_y);
[FX, FY] = meshgrid(fx, fy); % Shifted frequency grid

% Create the low-pass filter: a circular aperture in the Fourier domain
frequency_radius = sqrt(FX.^2 + FY.^2); % Radial spatial frequency
filter = double(frequency_radius <= cutoff_radius); % 1 inside cutoff, 0 outside

% Step 1: Fourier transform the input field
input_field_fft = fftshift(fft2(input_field));

% Step 2: Apply the low-pass filter
filtered_field_fft = input_field_fft .* filter;

% Step 3: Inverse Fourier transform to get the output field
output_field = ifft2(ifftshift(filtered_field_fft));

end
