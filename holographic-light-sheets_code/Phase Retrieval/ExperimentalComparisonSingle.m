%% Figure 3: Experimental comparisonn_x

fig = figure(3);
t = tiledlayout(2,2, 'TileSpacing', 'compact', 'Padding', 'tight'); % Create tiled layout
t.OuterPosition = [0 0 0.85 1];

w = 3.45e-6 * 300 * 1e3;

nexttile;
macroblock_image = imread("Pictures/macroblock 25mm 3.jpg");
macroblock_crop = imcrop(macroblock_image, [0 0 800 300]);
imshow(macroblock_crop);
title("2x2 Macroblock, gain=0.6");
scalebar(gca, 'x', 25, 'mm', 'Location', 'southeast', ...
    'ConversionFactor', 3.2, 'Color', 'white', 'LineWidth', 3, ...
    'Margin', [30 10], 'FontWeight', 'bold');
scalebar(gca, 'y', 0.25, 'mm', 'Location', 'southeast', ...
    'ConversionFactor', 1e-3/3.45e-6, 'Color', 'white', 'LineWidth', 3, ...
    'Margin', [10 30], 'FontWeight', 'bold');

nexttile;
uerd_image = imread("Pictures/uerd 25mm 1.jpg");
uerd_crop = imcrop(uerd_image, [30 0 800 300]);
imshow(uerd_crop);
title("Unidirectional Error Diffusion (UERD), gain=0.5");
scalebar(gca, 'x', 25, 'mm', 'Location', 'southeast', ...
    'ConversionFactor', 3.2, 'Color', 'white', 'LineWidth', 3, ...
    'Margin', [30 10], 'FontWeight', 'bold');
scalebar(gca, 'y', 0.25, 'mm', 'Location', 'southeast', ...
    'ConversionFactor', 1e-3/3.45e-6, 'Color', 'white', 'LineWidth', 3, ...
    'Margin', [10 30], 'FontWeight', 'bold');

nexttile;
cam_image = imread("Pictures/cam 25mm 1.jpg");
cam_crop = imcrop(cam_image, [0 0 800 300]);
imshow(cam_crop);
title("Complex Amplitude Modulation (CAM), gain=0.4");
scalebar(gca, 'x', 25, 'mm', 'Location', 'southeast', ...
    'ConversionFactor', 3.2, 'Color', 'white', 'LineWidth', 3, ...
    'Margin', [30 10], 'FontWeight', 'bold');
scalebar(gca, 'y', 0.25, 'mm', 'Location', 'southeast', ...
    'ConversionFactor', 1e-3/3.45e-6, 'Color', 'white', 'LineWidth', 3, ...
    'Margin', [10 30], 'FontWeight', 'bold');

nexttile;
phaseonly_image = imread("Pictures/phaseonly 25mm 1.jpg");
phaseonly_crop = imcrop(phaseonly_image, [5 0 800 300]);
imshow(phaseonly_crop);
title("Phase-only");
scalebar(gca, 'x', 25, 'mm', 'Location', 'southeast', ...
    'ConversionFactor', 3.2, 'Color', 'white', 'LineWidth', 3, ...
    'Margin', [30 10], 'FontWeight', 'bold');
scalebar(gca, 'y', 0.25, 'mm', 'Location', 'southeast', ...
    'ConversionFactor', 1e-3/3.45e-6, 'Color', 'white', 'LineWidth', 3, ...
    'Margin', [10 30], 'FontWeight', 'bold');

% colormap settings (for visualization purposes only)
rgbValues = spectrumRGB(532);
discr_color = 255;
cmap = [linspace(0,1,discr_color)'*rgbValues(1) linspace(0,1,discr_color)'*rgbValues(2) linspace(0,1,discr_color)'*rgbValues(3)];

% Add a shared colorbar
% Use a hidden axis to create a global colorbar
cb_ax = axes(fig, 'Visible', 'off'); % Hidden axis
cb = colorbar(cb_ax, 'Position', [0.9 0.1 0.02 0.8]); % Manual position on the right
colormap(cmap);
clim([0 1]);
%set(gca,'ColorScale',colorscale);
cb.Label.String = 'Intensity (a.u.)';

% Use light theme
%set(gcf, "Theme", "light");