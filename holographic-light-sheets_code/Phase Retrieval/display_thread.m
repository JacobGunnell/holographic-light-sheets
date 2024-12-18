function display_thread(field, xx, zz)
%DISPLAY_THREAD Summary of this function goes here
%   Detailed explanation goes here

[XX,ZZ] = meshgrid(xx,zz);
surf(XX*1e3, ZZ*1e3, permute(abs(field(600,450:750,:)).^2, [3 2 1]));
shading flat;
xlabel('x (mm)');
ylabel('z (mm)');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([zz(1)*1e3 zz(end)*1e3]);
view([-270 90]);

end

