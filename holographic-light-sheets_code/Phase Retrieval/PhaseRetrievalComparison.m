%% Ideal Field (full-complex SLM)
disp('Propagating ideal field...');
tic
ideal = propagate_field(Psi1, 532e-9, 8e-6, zz);
toc

figure;
surf(XX*1e3,ZZ*1e3,permute(abs(ideal(600,600:900,:)).^2, [3 2 1]));
shading flat;
colormap(cmap);
colorbar;
xlabel('x (mm)');
ylabel('z (mm)');
zlabel('U^2');
title('Propagated field intensity');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
set(gca,'FontSize',10,'FontWeight','bold');
view([-270 90]);

%% Arrizon
% TODO: add spatial filter simulation and apply blazed grating. Cause
% otherwise it's trash
disp('Propagating Arrizon PR field...');
tic
arrizon = propagate_field(exp(1j*SLM0), lambda, pixel_pitch, zz);
toc

figure;
surf(XX*1e3,ZZ*1e3,permute(abs(arrizon(600,600:900,:)).^2, [3 2 1]));
shading flat;
colormap(cmap);
colorbar;
xlabel('x (mm)');
ylabel('z (mm)');
zlabel('U^2');
title('Propagated field intensity');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([Zmin*1e3 Zmax*1e3]);
set(gca,'FontSize',10,'FontWeight','bold');
view([-270 90]);


