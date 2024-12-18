function output_field = spatial_filter(input_field, pixel_pitch, cutoff_radius, passband_shift)
% SPATIAL_FILTER Simulate a 4f optical system for spatial filtering.
%   Will additionally align the center frequency of the output waveform to
%   passband_shift, as if you used a spatial filter and aligned to the
%   passband order.
%
% Parameters:
% input_field   - 2D complex field at the input plane
% wavelength    - Wavelength of light (m)
% pixel_pitch   - Pixel size in spatial domain (m)
% cutoff_radius - Cutoff frequency radius for low-pass filtering (1/m)
% passband_shift  - Passband center coordinates (y,x)
%
% Returns:
% output_field  - 2D complex field at the output plane

% Get the size of the input field
[n_y, n_x] = size(input_field);

% Define spatial frequency coordinates
fy0 = passband_shift(1);
fx0 = passband_shift(2);
fx = linspace(-1/(2*pixel_pitch), 1/(2*pixel_pitch), n_x);
fy = linspace(-1/(2*pixel_pitch), 1/(2*pixel_pitch), n_y);
[FX, FY] = meshgrid(fx, fy); % Frequency grid

% Create the low-pass filter: a circular aperture in the Fourier domain
frequency_radius = sqrt((FX-fx0).^2 + (FY-fy0).^2); % Radial spatial frequency
filter = double(frequency_radius <= cutoff_radius); % 1 inside cutoff, 0 outside

% Fourier transform the input field and apply filter
input_field_fft = fftshift(fft2(input_field));
filtered_field_fft = input_field_fft .* filter;

% Shift the passband center to the origin
% Multiply by a phase factor to shift frequencies in the Fourier domain
phase_shift = exp(-1j * 2 * pi * (fx0 * FX + fy0 * FY));
aligned_filtered_field_fft = filtered_field_fft .* phase_shift;

% Step 3: Inverse Fourier transform to get the output field
output_field = ifft2(ifftshift(aligned_filtered_field_fft));

end
