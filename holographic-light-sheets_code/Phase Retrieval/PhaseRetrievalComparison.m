%%

% Plot the intensity distribution in the XZ plane
figure;
imagesc(z_vals * 1e3, x * 1e3, U_prop_xz_all); % x and z in mm
colormap('jet');
colorbar;
xlabel('z (mm)');
ylabel('x (mm)');
title('Intensity Distribution in the XZ Plane');