function display_field_fft(field, pixel_pitch)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

field_fft = fftshift(fft2(field));
figure;
fx = linspace(-1/(2*pixel_pitch), 1/(2*pixel_pitch), 1200);
fy = linspace(-1/(2*pixel_pitch), 1/(2*pixel_pitch), 1200);
[FX,FY] = meshgrid(fx, fy);
surf(FX, FY, abs(field_fft).^2);
shading flat;
colormap jet;
colorbar;
axis equal;
set(gca,'ColorScale','log');
view([-270 90]);

end
