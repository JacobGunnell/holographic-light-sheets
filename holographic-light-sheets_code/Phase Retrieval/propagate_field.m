function [field_xyz] = propagate_field(field_xy, wavelength, pixel_pitch, z)
%PROPAGATE_AND_DISPLAY Simulate free-space propagation of a complex field
%   Uses angular spectrum method
%   Parameters:
%   * field_xy: complex field in xy-plane
%   * wavelength: wavelength of light in m
%   * pixel_pitch: pixel size in m
%   * z: array or linspace of z positions in m to propagate to

k = 2*pi / wavelength; % Wave number
[n_y, n_x] = size(field_xy);
dy = pixel_pitch;
dx = pixel_pitch;

% Spatial frequency coordinates
fx = linspace(-1/(2*dx), 1/(2*dx), n_x); 
fy = linspace(-1/(2*dy), 1/(2*dy), n_y);
[FX, FY] = meshgrid(fx, fy);

% Apply transfer function in the Fourier domain
field_xyz = zeros(n_y, n_x, length(z)); % allocate array to store output field
field_xy_fft = fftshift(fft2(field_xy)); % Fourier transform of the field
parfor i=1:length(z)
    H = exp(-1j * k * z(i) * sqrt(1 - (wavelength*FX).^2 - (wavelength*FY).^2)); % transfer function at current z position
    field_xyz(:,:,i) = ifft2(ifftshift(field_xy_fft .* H)); % Multiply by inverse Fourier transform
end

