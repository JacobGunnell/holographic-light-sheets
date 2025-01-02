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

arrizon_lpf = spatial_filter(exp(1j*arrizon_phase), pixel_pitch, 2.5e4, [grating_freq grating_freq]);
arrizon = propagate_field(arrizon_lpf, lambda, pixel_pitch, zz);

%% CAM
cam_gain = 4;
cam_phase = pr_cam(Psi1, cam_gain);
cam = propagate_field(U1*exp(1j*cam_phase), lambda, pixel_pitch, zz);

%% 2x2 Macroblock
macroblock_gain = 0.7; % lower gain -> higher fidelity, higher gain -> higher power
macroblock_phase = pr_macroblock2x2(Psi1, macroblock_gain);
macroblock_lpf = spatial_filter(U1*exp(1j*macroblock_phase), pixel_pitch, 28e3, [0 0]);
macroblock = propagate_field(macroblock_lpf, lambda, pixel_pitch, zz);
%macroblock_no_lpf = propagate_field(exp(1j*macroblock_phase), lambda, pixel_pitch, zz);

%% UERD
uerd_gain = 0.5;
uerd_phase = pr_uerd(Psi1, uerd_gain);
uerd = propagate_field(U1*exp(1j*uerd_phase), lambda, pixel_pitch, zz);

%% Phase-only
phaseonly_phase = angle(Psi1);
phaseonly = propagate_field(U1*exp(1j*phaseonly_phase), lambda, pixel_pitch, zz);

%% Figure 1: Phase retrieval algorithms comparison

colorscale = 'log';

fig = figure(1);
t = tiledlayout(6,2, 'TileSpacing', 'compact', 'Padding', 'tight'); % Create tiled layout
t.OuterPosition = [0 0 0.85 1];

% Target
%nexttile(1);
%target_profile = sqrt(u1*1e5+1e-3);
%target = zeros(size(ideal));
%target(600,:) = target_profile;
%display_thread(target, xx, zz);
%title('Target Distribution');
%nexttile(3);
%semilogy(zz*1e3, target_profile.^2, 'r');
%xlabel('z (mm)');
%ylabel('Intensity (W/m^2)');
%xlim([zz(1)*1e3 zz(end)*1e3]);

% Ideal
ax_ideal_top = nexttile(1);
display_thread(ideal, xx, zz);
title('Ideal Field (full-complex SLM)');
nexttile(3);
semilogy(zz*1e3, abs(ideal(600,:)').^2, zz*1e3, u1*1e5+1e-3, 'r');
xlabel('z (mm)');
ylabel('Intensity (W/m^2)');
xlim([zz(1)*1e3 zz(end)*1e3]);
l = legend('Ideal Reconstruction \psi(\rho=0,\phi=0,z)', 'Target Distribution F(z)', 'Location', 'southeast');
l.Direction = 'reverse';

% Arrizon
nexttile(2);
display_thread(arrizon, xx, zz);
title('Arrizon');
nexttile(4);
display_thread_profile(arrizon, zz);

% 2x2 Macroblock
nexttile(5);
display_thread(macroblock, xx, zz);
title(['2x2 Macroblock, gain=' num2str(macroblock_gain)]);
nexttile(7);
display_thread_profile(macroblock, zz);

% UERD
nexttile(6);
display_thread(uerd, xx, zz);
title(['Unidirectional Error Diffusion (UERD), gain=' num2str(uerd_gain)]);
nexttile(8);
display_thread_profile(uerd, zz);

% CAM
nexttile(9);
display_thread(cam, xx, zz);
title(['Complex Amplitude Modulation (CAM), gain=' num2str(cam_gain)]);
nexttile(11);
display_thread_profile(cam, zz);

% Phase-only
nexttile(10);
display_thread(phaseonly, xx, zz);
title('Phase-only');
nexttile(12);
display_thread_profile(phaseonly, zz);

% Apply same y-axis limit to all line plots
all_lines = findall(fig, 'type', 'line');
umin = 1e-3;
umax = -inf;
for line = all_lines'
    % Get the YLim of the current axis
    curr_ylim = get(line.Parent, 'ylim'); % YLim is a [min, max] vector
    umax = max(umax, curr_ylim(2)); % Update the global max
end
for line = all_lines'
    set(line.Parent, 'ylim', [umin umax]);
end

% Apply same colorbar limit to all surf plots
all_surfaces = findall(fig, 'type', 'surface');
cmin = 1e-2;
cmax = -inf;
for surf = all_surfaces'
    % Get the CLim of the current axis
    curr_clim = get(surf.Parent, 'clim'); % CLim is a [min, max] vector
    cmax = max(cmax, curr_clim(2)); % Update the global max
end
for surface = all_surfaces'
    set(surface.Parent, 'clim', [cmin cmax]);
    set(surface.Parent, 'ColorScale', colorscale);
end

% Add a shared colorbar
% Use a hidden axis to create a global colorbar
cb_ax = axes(fig, 'Visible', 'off'); % Hidden axis
cb = colorbar(cb_ax, 'Position', [0.9 0.1 0.02 0.8]); % Manual position on the right
colormap('jet');
clim([cmin cmax]);
set(gca,'ColorScale',colorscale);
cb.Label.String = 'Intensity (W/m^2)';

% Use light theme
set(gcf, "Theme", "light");

%% Save for SLM
%save Variables\single_thread_phase.mat cam_phase uerd_phase arrizon_phase macroblock_phase

%% Save Simulation Data
save Variables\thread_2mm_pr.mat u1 pixel_pitch U0 U1 lambda xx zz Psi1 ideal n arrizon_phase X Y grating_freq arrizon_lpf arrizon cam_gain cam_phase cam macroblock_gain macroblock_phase macroblock_lpf macroblock uerd_gain uerd_phase uerd phaseonly_phase phaseonly 
