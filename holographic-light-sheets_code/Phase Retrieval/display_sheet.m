function display_sheet(field, xx, zz)
%DISPLAY_SHEET Summary of this function goes here
%   Detailed explanation goes here

[XX,ZZ] = meshgrid(xx,zz);
surf(XX*1e3, ZZ*1e3, abs(field(600:900,:)').^2);
shading flat;
xlabel('x (mm)');
ylabel('z (mm)');
xlim([xx(1)*1e3 xx(end)*1e3]);
ylim([zz(1)*1e3 zz(end)*1e3]);
view([-270 90]);

end

