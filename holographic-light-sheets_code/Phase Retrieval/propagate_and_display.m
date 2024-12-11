function [outputArg1,outputArg2] = propagate_and_display(inputArg1,inputArg2)
%PROPAGATE_AND_DISPLAY Summary of this function goes here
%   Detailed explanation goes here
% Simulate free-space propagation
% Parameters for free-space propagation
z_prop = 100e-3; % Propagation distance (e.g., 10 mm)
lambda = 532e-9; % Wavelength of the light
k = 2*pi / lambda; % Wave number
dx = 8e-6; % Pixel size
n_x = 1200; % Number of pixels in x
n_y = 1200; % Number of pixels in y

% Fourier transform of the field
U0 = exp(1i*SLM0); % Complex field, phase-modulated by SLM0

% Spatial frequency coordinates
fx = linspace(-1/(2*dx), 1/(2*dx), n_x); 
fy = linspace(-1/(2*dx), 1/(2*dx), n_y);
[FX, FY] = meshgrid(fx, fy);

% Transfer function (Angular Spectrum)
H = exp(1i*k*z_prop*sqrt(1 - (lambda*FX).^2 - (lambda*FY).^2)); % Transfer function for free-space propagation

% Apply transfer function in the Fourier domain
U_prop = fftshift(fft2(U0)); % Fourier transform of the field
U_prop = U_prop .* H; % Multiply by transfer function
U_prop = ifft2(ifftshift(U_prop)); % Inverse Fourier transform

% Select a slice at a specific Y position for the XZ plane
% For simplicity, we can use the middle of the Y dimension
y_slice = round(n_y / 2); % Middle of the Y dimension
U_prop_xz = U_prop(:, y_slice); % Take the slice along X at this Y position

% Z values (distance along the propagation axis)
z_vals = linspace(0, z_prop, n_x); % Assuming the distance is evenly spaced across X

% For plotting intensity as a function of X and Z (cross-section in XZ plane)
U_prop_xz_all = abs(U_prop).^2; % All points in XZ plane for intensity
end

