%% This code uses the Arrizon method to calculate a phase-only computer generated hologram to accurately encode a target complex field profile
%% Author: Ahmed H Dorrah, June 2018
%% Revisions: Jacob Gunnell, November 2024

%nx and ny refer to the blazed grating angle imparted on the desired
%pattern to help filter the target signal from the on axis (zero-th order
%noise) using a 4f lens system. We use a value of 300 for an 8 micron pixel pitch SLM
%X and Y is a mesh grid of coordinates and can be obtained as follows
%x     =  linspace(xmin,xmax,n_x);
%y     =  linspace(ymin,ymax,n_y);
%[X,Y] =  meshgrid(x,y)          ; 

function [SLM0,Energy] = pr_arrizon(Psi1,nx,ny,X,Y)
n_x = 1200; % dimensions of field to produce
n_y = 1200;
ph=angle(Psi1);
v=abs(Psi1)/max(max(abs(Psi1)));%%Field normalized to unity 
aux=round(v*800+1);
F = zeros(n_y,n_x);
load fx2.mat fx;  %Saved table to perform Bessel function inversion
% 
  for mh=1:n_y
      for nh=1:n_x
          temp=aux(mh,nh);
          F(mh,nh)=fx(temp);                                
      end                                                                    
  end 

gy=ny/(n_x*8e-6);
gx=nx/(n_y*8e-6);
    Hol0=F.*sin(ph+1.17*pi*(X*gx+Y*gy));
    Hol=Hol0-min(Hol0(:));
    SLM0=mod(Hol,1.17*pi);
    L = F.*exp(1i*ph);
    Energy = sum(sum(L.*conj(L)));
