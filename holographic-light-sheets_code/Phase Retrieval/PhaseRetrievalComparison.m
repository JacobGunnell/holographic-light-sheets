%% Simulate propagation
pixel_pitch = 8e-6;
cmax = 2.5;

% Ideal Field (full-complex SLM)
ideal = propagate_field(Psi1, lambda, pixel_pitch, zz);

%% Arrizon
n = 300; % blazed grating angle in Dorrah units
n_real = 2 * n / (1.17*pi*pixel_pitch*1200); % convert to lp/m
arrizon_phase = pr_arrizon(Psi1, n, n, X, Y);
arrizon_lpf = spatial_filter(exp(1j*arrizon_phase), pixel_pitch, 2e4, [n_real n_real]);
arrizon = propagate_field(arrizon_lpf, lambda, pixel_pitch, zz);

%% CAM
beta = 1.7;
cam_phase = pr_cam(Psi1, beta);
cam = propagate_field(exp(1j*cam_phase), lambda, pixel_pitch, zz);

%% 2x2 Macroblock
macroblock_phase = pr_macroblock2x2(Psi1);
macroblock_lpf = spatial_filter(exp(1j*macroblock_phase), pixel_pitch, 20e3, [0 0]);
macroblock = propagate_field(macroblock_lpf, lambda, pixel_pitch, zz);

%% UERD
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
surf(XX*1e3, ZZ*1e3, permute(abs(ideal(600,600:900,:)).^2, [3 2 1]));
shading flat;
xlabel('x (mm)');
ylabel('z (mm)');
title('Ideal Field (full-complex SLM)');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
view([-270 90]);

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
surf(XX*1e3, ZZ*1e3, permute(abs(arrizon(600,600:900,:)).^2, [3 2 1]));
shading flat;
xlabel('x (mm)');
ylabel('z (mm)');
title('Arrizon');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
view([-270 90]);

% CAM
nexttile;
surf(XX*1e3, ZZ*1e3, permute(abs(cam(600,600:900,:)).^2, [3 2 1]));
shading flat;
xlabel('x (mm)');
ylabel('z (mm)');
title(['CAM, \beta=' num2str(beta)]);
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
view([-270 90]);

% 2x2 Macroblock
nexttile;
surf(XX*1e3, ZZ*1e3, permute(abs(macroblock(600,600:900,:)).^2, [3 2 1]));
shading flat;
xlabel('x (mm)');
ylabel('z (mm)');
title('2x2 Macroblock with 4f LPF');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
view([-270 90]);

% UERD
nexttile;
surf(XX*1e3, ZZ*1e3, permute(abs(uerd(600,600:900,:)).^2, [3 2 1]));
shading flat;
xlabel('x (mm)');
ylabel('z (mm)');
title('Unidirectional Error Diffusion (UERD)');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
view([-270 90]);

% Add a shared colorbar
% Use a hidden axis to create a global colorbar
cb_ax = axes(fig, 'Visible', 'off'); % Hidden axis
cb = colorbar(cb_ax, 'Position', [0.92 0.1 0.02 0.8]); % Manual position on the right
colormap('jet');
clim([0 cmax]);
cb.Label.String = 'Intensity |U|^2';
