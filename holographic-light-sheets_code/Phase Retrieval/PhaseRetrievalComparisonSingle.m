%% Simulate propagation
pixel_pitch = 8e-6;
cmax = 1;

% Ideal Field (full-complex SLM)
ideal = propagate_field(Psi1, lambda, pixel_pitch, zz);

%% Arrizon
n = 300; % blazed grating angle in Dorrah units
arrizon_phase = pr_arrizon(Psi1, n, n, X, Y);
arrizon_fft = fftshift(fft2(exp(1j*100*arrizon_phase)));
figure;
fx = linspace(-1/(2*pixel_pitch), 1/(2*pixel_pitch), 1200);
fy = linspace(-1/(2*pixel_pitch), 1/(2*pixel_pitch), 1200);
[FX,FY] = meshgrid(fx, fy);
surf(FX, FY, abs(arrizon_fft).^2);
shading flat;
colormap jet;
colorbar;
set(gca,'ColorScale','log');
view([-270 90]);

%%
grating_freq = 1.17 * n / (2 * pixel_pitch * 1200); % blazed grating frequency in lp/m
freq_radius = grating_freq*sqrt(2)-1000;
arrizon_lpf = spatial_filter(exp(1j*arrizon_phase), pixel_pitch, 1e4, [-grating_freq grating_freq]);
arrizon = propagate_field(arrizon_lpf, lambda, pixel_pitch, zz);
figure;
display_thread(arrizon,xx,zz);
colormap jet;
colorbar;
set(gca,'ColorScale','log');
%%
% CAM
beta = 0.5;
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
t = tiledlayout(fig, 2, 1, 'TileSpacing', 'compact', 'Padding', 'tight'); % Create tiled layout
t.OuterPosition = [0 0 0.85 1];

nexttile;
display_thread(ideal, xx, zz);
title('Ideal Field (full-complex SLM)');
nexttile;
display_thread_profile(ideal, zz);

% Add a shared colorbar
% Use a hidden axis to create a global colorbar
cb_ax = axes(fig, 'Visible', 'off'); % Hidden axis
cb = colorbar(cb_ax, 'Position', [0.92 0.1 0.02 0.8]); % Manual position on the right
colormap('jet');
clim([0 cmax]);
cb.Label.String = 'Intensity |U|^2';

%% Figure 2: Phase retrieval algorithms comparison

fig = figure(2);
t = tiledlayout(4,2, 'TileSpacing', 'compact', 'Padding', 'tight'); % Create tiled layout
t.OuterPosition = [0 0 0.85 1];

% Arrizon
nexttile(1);
display_thread(arrizon, xx, zz);
title('Arrizon');
nexttile(3);
display_thread_profile(arrizon, zz);

% CAM
nexttile(2);
display_thread(cam, xx, zz);
title(['CAM, \beta=' num2str(beta)]);
nexttile(4);
display_thread_profile(cam, zz);

% 2x2 Macroblock
nexttile(5);
display_thread(macroblock, xx, zz);
title('2x2 Macroblock')
nexttile(7);
display_thread_profile(macroblock, zz);

% UERD
nexttile(6);
display_thread(uerd, xx, zz);
title('Unidirectional Error Diffusion (UERD)');
nexttile(8);
display_thread_profile(uerd, zz);

% Add a shared colorbar
% Use a hidden axis to create a global colorbar
cb_ax = axes(fig, 'Visible', 'off'); % Hidden axis
cb = colorbar(cb_ax, 'Position', [0.92 0.1 0.02 0.8]); % Manual position on the right
colormap('jet');
clim([0 cmax]);
cb.Label.String = 'Intensity |U|^2';

%% Save for SLM
save Variables\single_thread_phase.mat cam_phase uerd_phase arrizon_phase macroblock_phase
