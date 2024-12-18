function display_thread_profile(field, zz)
%DISPLAY_THREAD_PROFILE Summary of this function goes here
%   Detailed explanation goes here

% Intensity profile
plot(zz*1e3, permute(abs(field(600,600,:)).^2, [2 3 1]));
xlabel('z (mm)');
ylabel('Intensity |U|^2');
xlim([zz(1)*1e3 zz(end)*1e3]);

end

