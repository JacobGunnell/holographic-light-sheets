%% Simulate propagation
pixel_pitch = 8e-6;
cmax = 2.5;

% Ideal Field (full-complex SLM)
ideal = propagate_field(Psi1, lambda, pixel_pitch, zz);

% Arrizon
n = 300; % blazed grating angle in Dorrah units
arrizon_phase = pr_arrizon(Psi1, n, n, X, Y);
arrizon_fft = fftshift(fft2(exp(1j*arrizon_phase)));
%figure;
%surf(X, Y, abs(arrizon_fft).^2);
%colormap jet;
arrizon_lpf = spatial_filter(exp(1j*arrizon_phase), pixel_pitch, 2e4, [70e3 70e3]);
arrizon = propagate_field(arrizon_lpf, lambda, pixel_pitch, zz);

% CAM
beta = 1.7;
cam_phase = pr_cam(Psi1, beta);
cam = propagate_field(exp(1j*cam_phase), lambda, pixel_pitch, zz);

% 2x2 Macroblock
macroblock_phase = pr_macroblock2x2(Psi1);
macroblock_lpf = spatial_filter(exp(1j*macroblock_phase), pixel_pitch, 20e3, [0 0]);
macroblock = propagate_field(macroblock_lpf, lambda, pixel_pitch, zz);

% UERD
uerd_phase = pr_uerd(Psi1);
uerd = propagate_field(exp(1j*uerd_phase), lambda, pixel_pitch, zz);

%% Figure 1: Ideal
fig = figure(1);
t = tiledlayout(1,2, 'TileSpacing', 'compact', 'Padding', 'tight'); % Create tiled layout
t.OuterPosition = [0 0 0.85 1];

% Target image
nexttile;
target_image = imread('Pictures/sailor_cougar.jpg');
imshow(target_image);
title('Target Image');

% Ideal field
nexttile;
display_sheet(ideal, xx, zz);
title('Ideal Field (full-complex SLM)');

% Add a shared colorbar
% Use a hidden axis to create a global colorbar
cb_ax = axes(fig, 'Visible', 'off'); % Hidden axis
cb = colorbar(cb_ax, 'Position', [0.92 0.1 0.02 0.8]); % Manual position on the right
colormap('jet');
clim([0 cmax]);
cb.Label.String = 'Intensity |U|^2';

%% Figure 2: Phase retrieval algorithms comparison

fig = figure(2);
t = tiledlayout(2,2, 'TileSpacing', 'compact', 'Padding', 'tight'); % Create tiled layout
t.OuterPosition = [0 0 0.85 1];

% Arrizon
nexttile;
display_sheet(arrizon, xx, zz);
title('Arrizon');

% CAM
nexttile;
display_sheet(cam, xx, zz);
title(['CAM, \beta=' num2str(beta)]);

% 2x2 Macroblock
nexttile;
display_sheet(macroblock, xx, zz);
title('2x2 Macroblock');

% UERD
nexttile;
display_sheet(uerd, xx, zz);
title('Unidirectional Error Diffusion (UERD)');

% Add a shared colorbar
% Use a hidden axis to create a global colorbar
cb_ax = axes(fig, 'Visible', 'off'); % Hidden axis
cb = colorbar(cb_ax, 'Position', [0.92 0.1 0.02 0.8]); % Manual position on the right
colormap('jet');
clim([0 cmax]);
cb.Label.String = 'Intensity |U|^2';
