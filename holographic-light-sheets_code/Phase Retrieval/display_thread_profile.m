function display_thread_profile(field, zz)
%DISPLAY_THREAD_PROFILE Summary of this function goes here
%   Detailed explanation goes here

% Intensity profile
semilogy(zz*1e3, abs(field(600,:)').^2);
xlabel('z (mm)');
ylabel('Intensity (W/m^2)');
xlim([zz(1)*1e3 zz(end)*1e3]);

end

