function Psi = field_fwbg(u,An,in,n,L,K,Q,q,rho0,phi0)

syms rho phi z

rhog = sqrt(rho.^2+rho0^2-2*rho*rho0.*cos(phi-phi0));
phig = atan2((rho*sin(phi)-rho0*sin(phi0)),(rho*cos(phi)-rho0*cos(phi0)));

betan(in) = Q+(2*pi/L).*n;
krhon(in) = sqrt(2)*sqrt(1-(1/K)*(betan))*K;


mu(z) = 1-1i*2*(q^2)*(1/K)*z;

aux1(in) = besselj(u,krhon.*rhog./mu).*exp(1i.*(krhon.^2)*(1/(2*K)).*z./mu);
Psi(rho,phi,z) = exp(1i*u*phig).*exp(-1i*K*z).*(exp(-(q^2)*(rhog.^2)./mu)./mu).*sum(An.*aux1);


end