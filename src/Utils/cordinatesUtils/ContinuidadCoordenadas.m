function [np,xlinc,ylinc,nvs,vsaux1,vsaux2,vsaux3,vsaux4]=ContinuidadCoordenadas(x,y,nvi,vaux1,vaux2,vaux3,vaux4)
% se asegura la continuidad de las coordenadas cartesianas
% entrada:
% x,y: secuencias iniciales
% nvi: vertices de la entrada
% vauxi: vectores de la misma longitud de x que se reescalan con x
% salida:
% np: numero de puntos añadidos entre x e y
% xlinc,ylinc: secuencias finales
% nvs: posición de los vertices a la salida
% vauxsi: vectores de entrada vauxi reescalados

xlin=[];ylin=[];
xlinc=[];ylinc=[];inds=[];

x=round(x(:)');
y=round(y(:)');
if length(x)==1
    x=x*ones(1,2);
    y=y.*ones(1,2);
end
np=zeros(1,length(x)-1);
for i=1:length(x)-1;
    np(i)=ceil(max(abs(x(i)-x(i+1)),abs(y(i)-y(i+1))));
    xlin=round(linspace(x(i),x(i+1),np(i)+1));
    ylin=round(linspace(y(i),y(i+1),np(i)+1));
    xlinc=[xlinc xlin(1:end-1)];
    ylinc=[ylinc ylin(1:end-1)];
end
xlinc=[xlinc xlin(end)];
ylinc=[ylinc ylin(end)];
np(end)=np(end)+1;

% si hay mas vectores a ajustar dependiendo de x e y
for nva=1:nargin-3
    eval(['vsaux',num2str(nva),'=[];']);
    for i=1:length(np);
        eval(['vsaux',num2str(nva),'=[vsaux',num2str(nva),' linspace(vaux',num2str(nva),'(i),vaux',num2str(nva),'(min([length(vaux',num2str(nva),') i+1])),np(i))];']);
    end
end
if nargin>2
    np(end)=np(end)-1;
    np(end+1)=1;
    nva=[0; cumsum(nvi(:))];
    for ip=1:length(nvi)
        nvs(1,ip)=sum(np(nva(ip)+1:nva(ip+1)));
    end
    if length(xlinc)==1,nvs=1;end; 
    % se garantiza todos los nvs mantienen al menos una muestra
    indiceceros=find(nvs==0);
    for ipi=1:length(indiceceros)
        indm2=find(nvs>2);
        [vipi,iipi]=min(abs(indm2-indiceceros(ipi)));
        nvs(indiceceros(ipi))=nvs(indiceceros(ipi))+1;
        nvs(indm2(iipi))=nvs(indm2(iipi))-1;
    end
end

% se eliminan los tramos de longitud cero (puntos de entrada repetidos)
np=np(np>0);

% para que este bien hecho:
% cotinuidad: debe ser cero
%sum(ne(max(abs(diff(xlinc)),abs(diff(ylinc))),1));
% no repetir ningún numero
%sum(and(diff(xlinc)==0,diff(ylinc)==0));