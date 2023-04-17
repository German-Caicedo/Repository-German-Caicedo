clc
clear all
close all
Sg=load('Sgsismo.txt');
B=1/5;
z=5/100;
Dt=0.01;
Sg=Sg';
Sg=Sg(:);
Sg(:,2)=Sg;
Sg(:,1)=0:0.01:((size(Sg,1)-1)*0.01);

for j=2:1:200 %
%matriz de iteración
w=2*pi/(j/50);
MI(1,1)=0;
MI(1,2)=0;
MI(1,3)=Sg(1,2);
MI(1,5)=0;
MI(1,6)=0;
MI(1,4)=-MI(1,3)-2*z*w*MI(1,5)-(w^2)*MI(1,6);

for i=2:size(Sg,1)
e=100;
MI(i,4)=randi(10,1);
while e > 0.000001
  MI(i,1)=MI(i-1,1)+Dt;  
  MI(i,2)=Dt;
  MI(i,3)=Sg(i,2);  
  MI(i,5)=MI(i-1,5)+Dt*(MI(i,4)+MI(i-1,4))/2;
  MI(i,6)=MI(i-1,6)+MI(i-1,5)*Dt+((1/2-B)*MI(i-1,4)+B*MI(i,4))*Dt^2;
  a=-MI(i,3)-2*z*w*MI(i,5)-(w^2)*MI(i,6);
  e=abs(a-MI(i,4));
  MI(i,4)=a;
    MI(i,5)=MI(i-1,5)+Dt*(MI(i,4)+MI(i-1,4))/2;
  MI(i,6)=MI(i-1,6)+MI(i-1,5)*Dt+((1/2-B)*MI(i-1,4)+B*MI(i,4))*Dt^2;
end
end
sp(j-1,1)=j/50;
sp(j-1,2)=max((abs(MI(:,4))));
sp(j-1,3)=max(abs((MI(:,5)))); 
sp(j-1,4)=max(abs((MI(:,6))));
ww(j-1,1)=w;
end

Sv=sp(:,4).*ww;
Sa=sp(:,4).*(ww.^2);

%Espectro aceleración NEC
n=2.48;
Z=0.35*980;
r=1;
%Suelo tipo C.
Fa=1.23;
Fd=1.15;
Fs=1.06;
To=0.1*Fs*Fd/Fa;
Tc=0.55*Fs*Fd/Fa;

Se(:,1)=[[0:0.01:To]';To;[0.1:0.01:Tc]';Tc;[0.55:0.01:4]'];    
Se(1:11,2)=Z*Fa*(1+(n-1).*Se(1:11,1)/To);   % 0<T<To 
Se(12:57,2)=n*Z*Fa;                         % To<T<Tc
Se(58:403,2)=n*Z*Fa*((Tc./Se(58:403,1)).^r);    % Tc<T

%Gráficas

figure(1)
subplot(2,2,[1 2 ]);
plot(sp(:,1),sp(:,4),'r')
xlabel('Periodo [seg.]');
ylabel('Desplazamiento [cm]');
g=[ 'Máx ' num2str(max(abs(sp(:,4))) )   ' cm'];
 legend(g)
title('Espectro Desplazamiento')

subplot(2,2,3);
plot(sp(:,1),sp(:,3),'g')
xlabel('Periodo [seg.]');
ylabel('Velocidad [cm/s]');
f=[ 'Máx ' num2str(max(abs(sp(:,3))) )   ' cm/s'];
 legend(f)
title('Espectro Velocidad')

subplot(2,2,4);
plot(sp(:,1),Sv,'k')
xlabel('Periodo [seg.]');
ylabel('Velocidad [cm/s]');
v=[ 'Máx ' num2str(max(abs(Sv)) )   ' cm/s'];
legend(v)
title('Pseudo-espectro velocidad')

figure(2)
subplot(3,1,1);
plot(sp(:,1),sp(:,2),'b')
 xlabel('Periodo [seg.]');
 ylabel('Aceleración [cm/s2]');
 d=[ 'Máx ' num2str(max(abs(sp(:,2))) )   ' cm/s2'];
 legend(d)
title('Espectro Aceleración')
subplot(3,1,2);
plot(sp(:,1),Sa,'m')
xlabel('Periodo [seg.]');
 ylabel('Aceleración [cm/s2]');
  u=[ 'Máx ' num2str(max(abs(Sa)) )   ' cm/s2'];
 legend(u)
title('Pseudo-Espectro aceleración')
subplot(3,1,3);
plot( Se(:,1), Se(:,2), 'color', [ 0.4902    0.1804    0.5608])
xlabel('Periodo [seg.]');
 ylabel('Aceleración [cm/s2]');
 k=[ 'Máx ' num2str(max(abs(Se(:,2))) )   ' cm/s2'];
 legend(k)
 title('Espectro Elástico NEC.')

 figure(3)
 plot(sp(:,1),sp(:,2),'b',sp(:,1),Sa,'m',Se(:,1), Se(:,2), 'r')
 xlabel('Periodo [seg.]');
 ylabel('Aceleración [cm/s2]');
 








