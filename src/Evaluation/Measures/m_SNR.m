function SNRt= m_SNR(xs,ys,xrs,yrs)

%%% Put warnings off
warning('off', 'MATLAB:chckxy:IgnoreNaN');

% % calcula la relacion se�al ruido entre dos trayectoria 2DF
% % xroff,yroff es la trayectoria de referencia
% % xoff, yoff es la trayectoria a evaluar su SNR

NSNR=trapz((xrs-xs).^2+(yrs-ys).^2);%NSNR=sum((xrs-xs).^2+(yrs-ys).^2);
DSNR=trapz((xrs-mean(xrs)).^2+(yrs-mean(yrs)).^2);%DSNR=sum((xrs-mean(xrs)).^2+(yrs-mean(yrs)).^2);
SNRt=-10*log10(NSNR/DSNR);

end
