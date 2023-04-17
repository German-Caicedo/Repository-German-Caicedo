clc
clear all
close all
CONDENSACIÓN

Sismo=load('aceleraciones.txt'); %importe del archivo
Sismo=Sismo';Sismo=Sismo(:); %trasposición y conversión en vector de la matriz de registros

E=200; %t/cm^2
I=(40^4)/12; %cm^4
A=40^2; %cm^2
Long=([9 6 3 3 3 3 3 7 4]')*100; %cm

Se=zeros(6,6,9);
for i=1:9
Se(:,:,i)= [A*E/Long(i) 0 0 -A*E/Long(i) 0 0;...
        0 12*E*I/(Long(i)^3) 6*E*I/(Long(i)^2) 0 -12*E*I/(Long(i)^3) 6*E*I/(Long(i)^2);...
       0 6*E*I/(Long(i)^2) 4*E*I/Long(i) 0 -6*E*I/(Long(i)^2) 2*E*I/Long(i);...
       -A*E/Long(i) 0 0 A*E/Long(i) 0 0;...
       0 -12*E*I/(Long(i)^3) -6*E*I/(Long(i)^2) 0 12*E*I/(Long(i)^3) -6*E*I/(Long(i)^2);...
       0 6*E*I/(Long(i)^2) 2*E*I/Long(i) 0 -6*E*I/(Long(i)^2) 4*E*I/Long(i)];
end

Ro=[0 -1 0 0 0 0;...
    1 0 0 0 0 0;...
    0 0 1 0 0 0;...
    0 0 0 0 -1 0;...
    0 0 0 1 0 0;...
    0 0 0 0 0 1];

GDLs=[ 0 0 0 16 17 18;...
     0 0 0 10 11 12;...
     10 11 12 13 14 15;...
      0 0 0 4 5 6;...
      0 0 0 1 2 3;...
      1 2 3 7 8 9;...
      16 17 18 13 14 15;...
      10 11 12 7 8 9;...
      4 5 6 1 2 3];
  
  
Col=zeros(18,6,9);
  for j=1:6
  for i=1:9
      if GDLs(i,j)==0
      else
     Col(GDLs(i,j),j,i)=1;
      end
  end
  end
  
SE=zeros(18,18,9);
for i=1:6
    SE(:,:,i)=Col(:,:,i)*Ro*Se(:,:,i)*Ro'*Col(:,:,i)';
end
for i=7:9
    SE(:,:,i)=Col(:,:,i)*Se(:,:,i)*Col(:,:,i)';
end


Sest=zeros(18,18);
for i=1:9
    Sest=Sest+SE(:,:,i);
end


S11=Sest(1,1);S12=Sest(1,2:18);S21=Sest(2:18,1);S22=Sest(2:18,2:18);
Scond=S11-S12*(S22^-1)*S21;

RESPUESTAS


B=1/5;xi=5/100;m=40/980;fr=(Scond/m)^0.5;D=0.01; 

Matriz con iteraciones
numreg=length(Sismo); %numero de registros
Newm=zeros(numreg,4);
Newm(:,1)=[0:0.01:(numreg-1)*0.01]';
Newm(1,3)=0; Newm(1,4)=0; %Valor inicial de velocidad y desplazamiento
Newm(1,2)=-Sismo(1,1); %valor inicial de aceleración
 aiterada=zeros(numreg,1);
for i=2:numreg
error=9876;
Newm(i,2)=Newm(i-1,2);
while error > 0.00001
  Newm(i,3)=Newm(i-1,3)+(D/2)*(Newm(i,2)+Newm(i-1,2)); %velocidad calculada
  Newm(i,4)=Newm(i-1,4)+Newm(i-1,3)*D+((1/2-B)*Newm(i-1,2)+B*Newm(i,2))*D^2; %desplazamiento calculado
  aiterada(i)=-Sismo(i)-2*xi*fr*Newm(i,3)-(fr^2)*Newm(i,4);  
  error=abs(Newm(i,2)-aiterada(i));
  Newm(i,2)=aiterada(i); %La velocidad y desplazamiento se recalculan con la aceleracion que convergió
  Newm(i,3)=Newm(i-1,3)+(D/2)*(Newm(i,2)+Newm(i-1,2));
  Newm(i,4)=Newm(i-1,4)+Newm(i-1,3)*D+((1/2-B)*Newm(i-1,2)+B*Newm(i,2))*D^2;
end
end

figure(1)
h1=plot(Newm(:,1),Newm(:,2),'color',[0, 0.4470, 0.7410],'LineWidth',1.5);
hold on
w1 = plot(NaN,NaN,'w');
title('Respuesta en aceleración','FontSize',22);
xlabel('Tiempo [seg.]'); ylabel('Aceleración [cm2/s]'); set(gca,'FontSize',16);xlim([0 51.6]);
l1=legend([h1 w1], 'x`` ',['max. absoluta= ' num2str(max(abs(Newm(:,2))),'%.3f') ' cm2/s']);
set(l1,'FontSize',15);
hold off

figure(2)
h2=plot(Newm(:,1),Newm(:,3),'color',[0.8500, 0.3250, 0.0980],'LineWidth',1.5);
hold on
w2 = plot(NaN,NaN,'w');
title('Respuesta en velocidad','FontSize',22);
xlabel('Tiempo [seg.]'); ylabel('Velocidad [cm/s]'); set(gca,'FontSize',16);xlim([0 51.6]);
l2=legend([h2 w2], 'x` ',['max. absoluta= ' num2str(max(abs(Newm(:,3))),'%.3f') ' cm/s']);
set(l2,'FontSize',15);
hold off

figure(3)
h3=plot(Newm(:,1),Newm(:,4),'color',[0.9290, 0.6940, 0.1250],'LineWidth',1.5);
hold on
w3 = plot(NaN,NaN,'w');
title('Respuesta en desplazamiento','FontSize',22);
xlabel('Tiempo [seg.]'); ylabel('Desplazamiento [cm]'); set(gca,'FontSize',16);xlim([0 51.6]);
l3=legend([h3 w3], 'x ',['max. absoluta= ' num2str(max(abs(Newm(:,4))),'%.3f') ' cm']);
set(l3,'FontSize',15);
hold off

Resultados literal 1

Res1=Newm(1:50,:);

clearvars -except Sismo Res1
xi=5/100;numreg=length(Sismo); B=1/5;D=0.01;

S=zeros(200,3);
W=zeros(200,1);
for k=2:1:200
    T(k,1)=k/50;
    fr=2*pi/T(k);
    W(k,1)=fr;
Newm=zeros(numreg,4);
Newm(:,1)=[0:0.01:(numreg-1)*0.01]';
Newm(1,3)=0; Newm(1,4)=0; %Valor inicial de velocidad y desplazamiento
Newm(1,2)=-Sismo(1,1); %valor inicial de aceleración
aiterada=zeros(numreg,1);
for i=2:numreg
error=9876;
Newm(i,2)=rand*20;
while error > 0.0001
  Newm(i,3)=Newm(i-1,3)+(D/2)*(Newm(i,2)+Newm(i-1,2)); %velocidad calculada
  Newm(i,4)=Newm(i-1,4)+Newm(i-1,3)*D+((1/2-B)*Newm(i-1,2)+B*Newm(i,2))*D^2; %desplazamiento calculado
  aiterada(i)=-Sismo(i)-2*xi*fr*Newm(i,3)-(fr^2)*Newm(i,4);  
  error=abs(Newm(i,2)-aiterada(i));
  Newm(i,2)=aiterada(i); %La velocidad y desplazamiento se recalculan con la aceleracion que convergió
  Newm(i,3)=Newm(i-1,3)+(D/2)*(Newm(i,2)+Newm(i-1,2)); %velocidad calculada
  Newm(i,4)=Newm(i-1,4)+Newm(i-1,3)*D+((1/2-B)*Newm(i-1,2)+B*Newm(i,2))*D^2; %desplazamiento calculado
end
end
S(k,:)=max(abs(Newm(:,2:4)));
end

Pseudo espectros
Pseudov(1:199,1)=S(2:200,3).*W(2:200);
Pseudoa(1:199,1)=S(2:200,3).*W(2:200).^2;

Espectro aceleración NEC
n=2.48;Z=0.51;r=1;
Fa=1.2;Fd=1.19;Fs=1.28;To=0.1*Fs*Fd/Fa;Tc=0.55*Fs*Fd/Fa;

SNEC(:,1)=[[0:0.02:fix(To/0.02)*0.02]';To;[ceil(To/0.02)*0.02:0.02:fix(Tc/0.02)*0.02]';...
    Tc;[ceil(Tc/0.02)*0.02:0.02:4]'];
f1=find(SNEC==To);f2=find(SNEC==Tc);
for i=1:f1
    SNEC(i,2)=Z*Fa*980*(1+(n-1)*SNEC(i,1)/To);
end
SNEC(f1+1:f2,2)=n*Z*980*Fa;
for i=f2+1:length(SNEC)
    SNEC(i,2)=n*Z*Fa*980*(Tc/SNEC(i,1))^r;
end


figure(4)
h4=plot(([2:1:200]')./50,S(2:200,1),'color',[0.4940, 0.1840, 0.5560],'LineWidth',2);
hold on
h5=plot(([2:1:200]')./50,Pseudoa,'color',[0.4660, 0.6740, 0.1880],'LineWidth',2);
h6=plot(SNEC(:,1),SNEC(:,2),'color',[0.3010, 0.7450, 0.9330],'LineWidth',2);
w4 = plot(NaN,NaN,'w');w5 = plot(NaN,NaN,'w');w6 = plot(NaN,NaN,'w');
xlabel('Periodo [seg.]'); ylabel('Aceleración [cm2/s]'); set(gca,'FontSize',16);xlim([0 4]);
l4=legend([h4 w4 h5 w5 h6 w6], 'Espectro elástico de aceleración',...
['max.= ' num2str(max(S(2:200,1)),'%.3f') ' cm2/s'],...
 'Espectro elástico de pseudo aceleración',...
 ['max.= ' num2str(max(Pseudoa),'%.3f') ' cm2/s'],...
 'Espectro elástico NEC',...
 ['max.= ' num2str(max(SNEC(:,2)),'%.3f') ' cm2/s']);
set(l4,'FontSize',15);
hold off

figure(5)
h7=plot(([2:1:200]')./50,S(2:200,2),'color',[0.4940, 0.1840, 0.5560],'LineWidth',2);
hold on
h8=plot(([2:1:200]')./50,Pseudov,'color',[0.4660, 0.6740, 0.1880],'LineWidth',2);
w7 = plot(NaN,NaN,'w');w8 = plot(NaN,NaN,'w');
xlabel('Periodo [seg.]'); ylabel('Velocidad [cm/s]'); set(gca,'FontSize',16);xlim([0 4]);

l5=legend([h7 w7 h8 w8], 'Espectro elástico de velocidad',...
['max.= ' num2str(max(S(2:200,2)),'%.3f') ' cm/s'],...
 'Espectro elástico de pseudo velocidad',...
 ['max.= ' num2str(max(Pseudov),'%.3f') ' cm/s'])
set(l5,'FontSize',15);
hold off

figure(6)
h9=plot(([2:1:200]')./50,S(2:200,3),'color',[0.4940, 0.1840, 0.5560],'LineWidth',2);
hold on
w9 = plot(NaN,NaN,'w');
xlabel('Periodo [seg.]'); ylabel('Desplazamiento [cm]'); set(gca,'FontSize',16);xlim([0 4]);

l6=legend([h9 w9], 'Espectro elástico de desplazamiento',...
['max.= ' num2str(max(S(2:200,3)),'%.3f') ' cm']);
set(l6,'FontSize',15);
hold off

Resultados literal 2
Res2=[T(2:101,:) S(2:101,:)]; %Tabla con espectros
Res3=[T(2:101,:) Pseudoa(1:100,1) Pseudov(1:100,1) ];%Tabla con pseudo-espectros
Res4=SNEC(1:100,:);%Tablas con espectro NEC
 
clearvars -except Sismo Res1 Res2 Res3 Res4

E=200;  %t/cm2
I=(40^4)/12;  %cm4               
h=[300 600 900]';
k=zeros(3,1);
for i=1:3
    k(i,1)=12*E*I/(h(i)^3);
end


M= [20 0 0;...
    0 20 0;...
    0 0 10]./980;

K=[3*k(1) -k(1) 0;...
    -k(1) 2*k(1)+k(2) -k(1);...
    0 -k(1) k(1)+k(3)];

syms x y z
fr2= double(solve(det(K-(x)*M)==0,x));

modos=zeros(3);
modos(1,:)=1;
for i=1:length(fr2)
b=(K-fr2(i)*M);
S=solve([b(1,:)*[1;y;z]==0,b(2,:)*[1;y;z]==0],[y z]);
modos(2,i)=double(S.y);
modos(3,i)=double(S.z);
end

for i=1:length(fr2)
MM(i,1)=(modos(:,i)')*M*modos(:,i);
end
n=MM.^-0.5;
for i=1:length(fr2)
modNorm(:,i)=n(i)*modos(:,i);
end


r=[1;1;1];
L=modNorm'*M*r;

Mtotal=sum(M(:));
Mef=((L.^2)./Mtotal).*100;

T=2*pi./(fr2.^0.5);
n=2.48;Z=0.51;r=1;I=1;
Fa=1.2;Fd=1.19;Fs=1.28;
Tc=0.55*Fs*Fd/Fa;
R=6;fip=1;fie=1;Imp=1;
funcion antes de Tc, todos los periodos estan antes de Tc
Sa(1:3,1)=n*Z*Fa*980/(R*fip*fie);


qmax=zeros(3);
for i=1:length(fr2)
qmax(:,i)=(L(i)*Sa(i)/fr2(i))*modNorm(:,i);
end
Qmax=zeros(3);
for i=1:length(fr2)
Qmax(:,i)=L(i)*Sa(i)*M*modNorm(:,i);
end


ABS=zeros(3,1);
for i=1:length(fr2)
ABS(i,1)=sum(abs(Qmax(i,:)));
end 
SRRS=rssq(Qmax,2);


Prom=mean([ABS SRRS],2);
Vbasal=sum(Prom)*I;


figure (7)
subplot(1,2,1);
plot([0;Prom],[0:3:9])
grid on
grid minor
 xlabel('Fuerzas [ton.]'); ylabel('Altura [m.]'); set(gca,'FontSize',16);xlim([0 max(Prom)]);ylim([0 9]);
   title(['Distribución de fuerzas laterales por piso'],'FontSize',18)
   hold on
   x=[0;Prom]; y=[0:3:9];
      for v=2:4
       caption = sprintf('F=%.2f, h=%.2f', x(v), y(v));
       text(x(v)-1.7, y(v)-0.15, caption, 'BackgroundColor', 'w','FontSize',14);
       plot(x(v), y(v),'b--o');
      end
   
subplot(1,2,2);
plot([0;Prom]./max(Prom),[0:3:9])
grid on
grid minor
 xlabel('Fuerzas [ton./ton.]'); ylabel('Altura [m.]'); set(gca,'FontSize',16);xlim([0 1]);ylim([0 9]);
   title(['Distribución de fuerzas laterales normalizadas por piso'],'FontSize',18)
