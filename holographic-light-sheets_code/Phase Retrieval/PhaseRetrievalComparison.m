%% Simulate propagation
pixel_pitch = 8e-6; % dimensions of each pixel in meters
[height, width] = size(Psi1); % dimensions of utilized SLM aperture in pixels
slm_power = 6e-3; % Power of (simulated) laser source in watts

% Normalize input field such that total field power matches slm_power
U0 = sqrt(slm_power / (pixel_pitch^2 * sum(sum(abs(Psi1).^2)))); % coefficient of Psi1
U1 = sqrt(slm_power / (pixel_pitch^2 * height * width)); % coefficient of exp(1j*phase)

% Ideal Field (full-complex SLM)
ideal = propagate_field(U0*Psi1, lambda, pixel_pitch, zz);

%% Arrizon
n = 300; % blazed grating angle in Dorrah units
arrizon_phase = pr_arrizon(Psi1, n, n, X, Y);

grating_freq = 1.17 * n / (2 * pixel_pitch * 1200); % blazed grating frequency in lp/m

arrizon_lpf = spatial_filter(U1*exp(1j*arrizon_phase), pixel_pitch, 2e4, [grating_freq grating_freq]);
arrizon = propagate_field(arrizon_lpf, lambda, pixel_pitch, zz);

%% CAM
cam_gain = 0.4;
cam_phase = pr_cam(Psi1, cam_gain);
cam = propagate_field(U1*exp(1j*cam_phase), lambda, pixel_pitch, zz);

%% 2x2 Macroblock
macroblock_gain = 0.7;
macroblock_phase = pr_macroblock2x2(Psi1, macroblock_gain);
macroblock_lpf = spatial_filter(U1*exp(1j*macroblock_phase), pixel_pitch, 28e3, [0 0]);
macroblock = propagate_field(macroblock_lpf, lambda, pixel_pitch, zz);

%% UERD
uerd_gain = 0.1;
uerd_phase = pr_uerd(Psi1, uerd_gain);
uerd = propagate_field(U1*exp(1j*uerd_phase), lambda, pixel_pitch, zz);

%% GS
gs = uerd;

%% Phase-only
phaseonly_phase = angle(Psi1);
phaseonly = propagate_field(U1*exp(1j*phaseonly_phase), lambda, pixel_pitch, zz);

%% Figure 2: Phase retrieval algorithms comparison

colorscale = 'log';

fig = figure(2);
t = tiledlayout(3, 3, 'TileSpacing', 'compact', 'Padding', 'tight'); % Create tiled layout
t.OuterPosition = [0 0 0.85 1];

% Target image
nexttile(2);
target_image = imread('Figures/sailor_cougar.jpg');
imshow(target_image);
title('Target Image');

% Ideal field
nexttile(4);
display_sheet(ideal, xx, zz);
title('Ideal Field (full-complex SLM)');

% Arrizon
nexttile(5);
display_sheet(arrizon, xx, zz);
title('Arrizon');

% 2x2 Macroblock
nexttile(6);
display_sheet(macroblock, xx, zz);
title(['2x2 Macroblock, gain=' num2str(macroblock_gain)]);

% UERD
nexttile(7);
display_sheet(uerd, xx, zz);
title(['Unidirectional Error Diffusion (UERD), gain=' num2str(uerd_gain)]);

% CAM
nexttile(8);
display_sheet(cam, xx, zz);
title(['Complex Amplitude Modulation (CAM), gain=' num2str(cam_gain)]);

% Phase-only
nexttile(9);
display_sheet(phaseonly, xx, zz);
title('Phase-only');

% Apply same colorbar limit to all surf plots
all_surfaces = findall(fig, 'type', 'surface');
cmin = 1e-1;
cmax = -inf;
for surf = all_surfaces'
    % Get the CLim of the current axis
    curr_clim = get(surf.Parent, 'clim'); % CLim is a [min, max] vector
    cmax = max(cmax, curr_clim(2)); % Update the global max
end
%cmax = 2500;
for surface = all_surfaces'
    set(surface.Parent, 'clim', [cmin cmax]);
    set(surface.Parent,'ColorScale',colorscale);
end

% Add a shared colorbar
% Use a hidden axis to create a global colorbar
cb_ax = axes(fig, 'Visible', 'off'); % Hidden axis
cb = colorbar(cb_ax, 'Position', [0.9 0.1 0.02 0.8]); % Manual position on the right
colormap('jet');
clim([cmin cmax]);
cb.Label.String = 'Intensity (W/m^2)';
set(cb_ax,'ColorScale',colorscale);

% Use light theme
set(gcf, "Theme", "light");

%% Save Simulation Data
%save Variables\sailor_cougar_pr.mat pixel_pitch U0 U1 lambda xx zz Psi1 ideal n arrizon_phase X Y grating_freq arrizon_lpf arrizon cam_gain cam_phase cam macroblock_gain macroblock_phase macroblock_lpf macroblock uerd_gain uerd_phase uerd phaseonly_phase phaseonly gs 
