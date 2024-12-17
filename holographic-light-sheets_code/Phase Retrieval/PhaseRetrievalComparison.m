%% Ideal Field (full-complex SLM)
% Parameters
pixel_pitch = 8e-6;

disp('Propagating ideal field...');
ideal = propagate_field(Psi1, lambda, pixel_pitch, zz);

figure;
surf(XX*1e3,ZZ*1e3,permute(abs(ideal(600,600:900,:)).^2, [3 2 1]));
shading flat;
colormap('jet');
colorbar;
xlabel('x (mm)');
ylabel('z (mm)');
zlabel('U^2');
title('Ideal Field (full-complex SLM)');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
set(gca,'FontSize',10,'FontWeight','bold');
view([-270 90]);

%% Arrizon
disp('Computing Arrizon PR field...');
arrizon_phase = pr_arrizon(Psi1, 300, 300, X, Y);
arrizon_lpf = spatial_filter(exp(1j*arrizon_phase), pixel_pitch, 100e3, [70e3, 70e3]);
arrizon = propagate_field(arrizon_lpf, lambda, pixel_pitch, zz);

figure;
surf(XX*1e3,ZZ*1e3,permute(abs(arrizon(600,600:900,:)).^2, [3 2 1]));
shading flat;
colormap('jet');
colorbar;
xlabel('x (mm)');
ylabel('z (mm)');
zlabel('U^2');
title('Arrizon');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
set(gca,'FontSize',10,'FontWeight','bold');
view([-270 90]);

%% CAM
cam_phase = pr_cam(Psi1, 5);
cam = propagate_field(exp(1j*cam_phase), lambda, pixel_pitch, zz);

figure;
surf(XX*1e3,ZZ*1e3,permute(abs(cam(600,600:900,:)).^2, [3 2 1]));
shading flat;
colormap('jet');
colorbar;
xlabel('x (mm)');
ylabel('z (mm)');
zlabel('U^2');
title('CAM');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
set(gca,'FontSize',10,'FontWeight','bold');
view([-270 90]);

%% 2x2 Macroblock
macroblock_phase = pr_macroblock2x2(Psi1);
macroblock_lpf = spatial_filter(exp(1j*macroblock_phase), pixel_pitch, 20e3, [0 0]); % Apply lowpass filter
macroblock = propagate_field(macroblock_lpf, lambda, pixel_pitch, zz);

figure;
surf(XX*1e3,ZZ*1e3,permute(abs(macroblock(600,600:900,:)).^2, [3 2 1]));
shading flat;
colormap('jet');
colorbar;
xlabel('x (mm)');
ylabel('z (mm)');
zlabel('U^2');
title('2x2 Macroblock with 4f LPF');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
set(gca,'FontSize',10,'FontWeight','bold');
%set(gca,'ColorScale','log');
view([-270 90]);

%% Phase-only
phase_only_phase = angle(Psi1);
phase_only = propagate_field(phase_only_phase, lambda, pixel_pitch, zz);

figure;
surf(XX*1e3,ZZ*1e3,permute(abs(macroblock(600,600:900,:)).^2, [3 2 1]));
shading flat;
colormap('jet');
colorbar;
xlabel('x (mm)');
ylabel('z (mm)');
zlabel('U^2');
title('Phase-only :\');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
set(gca,'FontSize',10,'FontWeight','bold');
%set(gca,'ColorScale','log');
view([-270 90]);
