% HOLOGRAPHIC LIGHT SHEETS
%   Main author: Vinicius Soares de Angelis (vinicius.angelis@usp.br)
%   Contributor: Jhonas Olivati de Sarro
%   Date: 2021/03/04
%   Last update: 2023/04/24

% To run this code:
% - Select 'Browser for folder' in the upper left corner in MATLAB environment 
% and search for the folder 'holographic-light-sheets_code';
% - Open the file 'main_grayscale.m' and run it.

% Folder 'holographic-light-sheets_code' contains the results concerning the input 
% image example 'logo_eesc.png' and the input parameters presented in Fig. 3e 
% of the article 'https://www.nature.com/articles/s41566-023-01188-y'

close all;
clear all;
clc;
%% input parameters


M = 1; % number of linear FWs ( = number of pixels in x direction desired for the the input image)
Mz = 301; % number of pixels in z direction desired for the the input image
          
z1 = 0:1:Mz-1;
u1 = square(2*pi*z1/80); % target light thread intensity pattern

lambda0 = 532e-9; %[m] operating wavelength of the laser in free space (visible range: 400 to 650 nm)
r0 = 30e-6; % [m] spot size radius of each FW
delta_x_param = 1; % distance between the FWs in terms of r0. For delta_x_param = 2, delta_x = 2 x r0 
L = 550e-3; % [m] longitudinal distance of each FW ( = image length in z direction)


%%

fprintf('Number of linear FWs: %d \n',M);
fprintf('Spot size radius of each FW: %f um\n',r0*1e6);
fprintf('Longitudinal distance of each FW: %f mm\n',L*1e3);
fprintf('Distance between the FWs: %f r0 \n',delta_x_param);

w0 = (2*pi*Const.c0)/lambda0; %[rad/s] operating angular frequency
lambda = lambda0; %[m] wavelength of the medium
k = 2*pi/lambda0; %[rad/m] wavenumber of the medium
fprintf('Wavelength: %f nm\n',lambda*1e9);
fprintf('Operating frequency: %f THz\n',(w0/(2*pi))*1e-12);

syms kz z rho phi
digits(100);

delta_x = delta_x_param*r0;
Xmin = 0; 
%Xmax = Xmin + (M-1)*delta_x;
Xmax = Xmin + 80*delta_x;
Zmax = L;
Zmin = 0;
Quant_z = Mz;
zp = linspace(Zmin,Zmax,Quant_z);
step = zp(2)-zp(1);
x0 = Xmin:delta_x:Xmax;
y0 = zeros(length(x0));


Qx = 301;
Qz = 301;
xx = linspace(x0(1)-r0,x0(end)+r0,Qx);
zz = linspace(Zmin,Zmax,Qz);
[XX,ZZ] = meshgrid(xx,zz);



Q = k*sqrt(1-(2.4048/(r0*k))^2); % central longitudinal wave number
Nmax = floor((L/(2*pi))*(k-Q)); % maximum number of BBs
%krho0 = sqrt(1-Q/k)*k; % central transverse wave number
krho0 = sqrt(k^2-Q^2);
N = 10;

kzc = Q-2*pi*N/L; % longitudinal wave number of the Bessel beam with the highest axicon angle
axicon_max = acos(kzc/k); % highest axicon angle
krho_max = sqrt(1-(kzc/k))*k; % transverse wave number of the Bessel beam with the highest axicon angle  
Rab = L*sqrt((k/kzc)^2-1); % minimum radius aperture for generate each FW


Lxab = 2*Rab+(x0(end)-x0(1)); % minimum dimensions of a rectangular aperture (placed at z = 0) able to generate
Lyab = 2*Rab;                 % the set of FWs   


q = 0.5*k/(L*krho0); % control de Guassian apodization

fprintf('Guassian beam waist (1/q): %f mm \n',(1/q)*1e3);
fprintf('Number of Bessel beams in each FW superposition (2 N+1): %d \n',2*N+1);
fprintf('Paraxiallity level (Q/k): %f \n',Q/k);
fprintf('Highest axicon angle (�): %f \n',axicon_max*(180/pi));
fprintf('Corresponding longitudinal wavenumber (kzc/k): %f \n',kzc/k);
fprintf('Inverse of the highest transverse wave number (nm): %f \n',1e9/krho_max);
fprintf('Minimum rectangular aperture dimension in x (mm): %f \n',Lxab*1e3);
fprintf('Minimum rectangular aperture dimension in y (mm): %f \n',Lyab*1e3);

u = 0; % order of the Bessel-Gauss beams
%% field squared amplitude
tic
Psi = 0;

tic
for i=1:1
    aux = sum(u1(i,:).*function_gate(zp-step/2,zp+step/2));
    [An,in,n] = profile_fw(aux,L,N);
    rho0 = sqrt(x0(i).^2+y0(i).^2);
    phi0 = atan2(y0(i),x0(i));
    aux = field_fwbg(u,An,in,n,L,k,Q,q,rho0,phi0);
    Psi = Psi + aux; 
end
fPsi = matlabFunction(Psi,'vars', [rho phi z]);

E2E0 = abs(fPsi(XX,0,ZZ)).^2; % normalized squared amplitude of the field
                              % in xz plane                                              

% colormap settings (for visualization purposes only)
rgbValues = spectrumRGB(lambda*1e9);
discr_color = 255;
cmap = [linspace(0,1,discr_color)'*rgbValues(1) linspace(0,1,discr_color)'*rgbValues(2) linspace(0,1,discr_color)'*rgbValues(3)];
toc
%%
figure
surf(XX*1e3,ZZ*1e3,E2E0)
shading flat
%colormap(cmap)
colormap('jet')
colorbar 
xlabel('x (mm)')
ylabel('z (mm)')
zlabel('(|E|/E_0)^2')
title([' (|E|/|E_0|)^2 (x, y = ' num2str(0),' mm, z)']);
xlim([xx(1)*1e3 xx(end)*1e3])
ylim([Zmin*1e3 Zmax*1e3])
set(gca,'FontSize',10,'FontWeight','bold')
view([-270 90])
%%

% output phase only map for SLM
% Define the inputs
SLM_pixel_size = 8e-6;
nx = 0;  % Example value for blazed grating angle in x-direction
ny = 0;  % Example value for blazed grating angle in y-direction
% nx=1e10;
% ny=1e10;
n_x = 1920;  % Size of the SLM in x-direction
n_y = 1200;  % Size of the SLM in y-direction
x = linspace(-n_x/2*SLM_pixel_size, n_x/2*SLM_pixel_size, n_x);  % Coordinate range in x
y = linspace(-n_y/2*SLM_pixel_size, n_y/2*SLM_pixel_size, n_y);  % Coordinate range in y
[X, Y] = meshgrid(x, y);  % Generate the mesh grid
RHO = sqrt(X.^2 + Y.^2);
PHI = atan2(Y,X);
Psi1 = fPsi(RHO,PHI,0);

% Perform phase retrieval
[SLM0, Energy] = GenerateHologram(Psi1, nx, ny, X, Y);
%[SLM0, Energy] = pr_cam(Psi1, nx, ny, X, Y, 1);


% Display the results
figure;
imagesc(SLM0);
colorbar;
title('Phase-Only Hologram (SLM0)');

disp(['Energy: ', num2str(Energy)]);

%%

% Simulate free-space propagation