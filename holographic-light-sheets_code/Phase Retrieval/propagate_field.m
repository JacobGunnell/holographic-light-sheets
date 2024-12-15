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
[FX, FY, Z] = meshgrid(fx, fy, z);

% Free-space transfer function (3d complex array)
H = exp(-1j * k * Z .* sqrt(1 - (wavelength*FX).^2 - (wavelength*FY).^2));

% Apply transfer function in the Fourier domain
field_xy_fft = fftshift(fft2(field_xy)); % Fourier transform of the field
input_xyz_fft = repmat(field_xy_fft, [1 1 length(z)]); % extend Fourier transform of input field to match size of H
field_xyz_fft = input_xyz_fft .* H; % Multiply by transfer function
field_xyz = ifft2(ifftshift(field_xyz_fft)); % Inverse Fourier transform

