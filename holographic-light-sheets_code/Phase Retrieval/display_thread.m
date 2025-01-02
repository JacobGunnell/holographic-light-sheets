function display_thread(field, xx, zz)
%DISPLAY_THREAD Summary of this function goes here
%   Detailed explanation goes here

x_center = xx(51);
[XX,ZZ] = meshgrid(xx(1:101)-x_center,zz);
surf(XX*1e3, ZZ*1e3, abs(field(550:650,:)').^2);
shading flat;
xlabel('x (mm)');
ylabel('z (mm)');
xlim([(xx(1)-x_center)*1e3 (xx(101)-x_center)*1e3]);
ylim([zz(1)*1e3 zz(end)*1e3]);
view([-270 90]);

end

