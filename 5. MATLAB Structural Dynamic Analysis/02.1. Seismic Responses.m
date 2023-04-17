% % dinamico
% Condensación
clc
clear all
close all
C=load('CONEC.txt');
CO=load('COORD.txt');

x=zeros(size(C,1),1);
for i=1:size(C,1)
    x(i,1)=sqrt((CO(C(i,1),1)-CO(C(i,2),1))^2+(CO(C(i,1),2)-CO(C(i,2),2))^2); %longitud elemento
end

cos=zeros(size(C,1),1);
sen=zeros(size(C,1),1);
for i=1:size(C,1)
cos(i,1)=(CO(C(i,2),1)-CO(C(i,1),1))/x(i); %coseno elemento
sen(i,1)=(CO(C(i,2),2)-CO(C(i,1),2))/x(i); %seno elemento
end

AI=zeros(size(C,1),2);
for i=1:size(C,1)
AI(i,1)=C(i,3)*C(i,4);   %area elemento
AI(i,2)=C(i,3)*(C(i,4)^3)/12;    %inercia elemento
end


K=zeros(6,6,size(C,1));
for i=1:size(C,1)
K(:,:,i)=[AI(i,1)*C(i,5)/x(i) 0 0 -AI(i,1)*C(i,5)/x(i) 0 0,
    0 12*C(i,5)*AI(i,2)/(x(i)^3) 6*C(i,5)*AI(i,2)/(x(i)^2) 0 -12*C(i,5)*AI(i,2)/(x(i)^3) 6*C(i,5)*AI(i,2)/(x(i)^2),
    0 6*C(i,5)*AI(i,2)/(x(i)^2) 4*C(i,5)*AI(i,2)/x(i) 0 -6*C(i,5)*AI(i,2)/(x(i)^2) 2*C(i,5)*AI(i,2)/x(i),
    -AI(i,1)*C(i,5)/x(i) 0 0 AI(i,1)*C(i,5)/x(i) 0 0,
    0 -12*C(i,5)*AI(i,2)/(x(i)^3) -6*C(i,5)*AI(i,2)/(x(i)^2) 0 12*C(i,5)*AI(i,2)/(x(i)^3) -6*C(i,5)*AI(i,2)/(x(i)^2),
    0 6*C(i,5)*AI(i,2)/(x(i)^2) 2*C(i,5)*AI(i,2)/x(i) 0 -6*C(i,5)*AI(i,2)/(x(i)^2) 4*C(i,5)*AI(i,2)/x(i)];
end

T=zeros(6,6,size(C,1));
for i=1:size(C,1)
T(1,1,i)=cos(i); T(1,2,i)=-sen(i); T(2,1,i)=sen(i); T(2,2,i)=cos(i); T(3,3,i)=1;
T(4,4,i)=cos(i); T(4,5,i)=-sen(i); T(5,4,i)=sen(i); T(5,5,i)=cos(i); T(6,6,i)=1;
end

GDL=[13 14 15;16 17 18;19 20 21;1 2 3;4 5 6;7 8 9;10 11 12];
U=zeros(size(C,1),6);
for i= 1:size(C,1)
    for j= 1:size(CO,1)
        if C(i,1)==j
            U(i,1)=GDL(j,1); U(i,2)=GDL(j,2); U(i,3)=GDL(j,3);
        else
                end
    end
end
for i= 1:size(C,1)
    for j= 1:size(CO,1)
        if C(i,2)==j
            U(i,4)=GDL(j,1); U(i,5)=GDL(j,2); U(i,6)=GDL(j,3);
        else
                end
    end
end

for i=1:size(C,1)
    L(U(i,1),1,i)=1;
    L(U(i,2),2,i)=1;
    L(U(i,3),3,i)=1;
    L(U(i,4),4,i)=1;
    L(U(i,5),5,i)=1;
    L(U(i,6),6,i)=1;
end

for i=1:size(C,1)
Ki(:,:,i)=L(:,:,i)*T(:,:,i)*K(:,:,i)*((T(:,:,i))')*((L(:,:,i))');
end

KE=zeros(size(CO,1)*3);
for i=1:size(C,1)
    KE=KE+Ki(:,:,i);
end

KQQ=KE(1:12,1:12);


KLL2=KQQ(1,1)-KQQ(1,2:12)*(KQQ(2:12,2:12)^-1)*KQQ(2:12,1);


%%RESPUESTAS
B=1/5;
z=5/100;
P=40; %ton
g=980; %cm/s2
Dt=0.01; %s
Sg=load('Sgsismo.txt');
Sg=Sg';
Sg=Sg(:);
Sg(:,2)=Sg;
Sg(:,1)=0:0.01:((size(Sg,1)-1)*0.01);
m=P/g; %ts2/cm
w=(KLL2/m)^0.5; %s-1
%matriz de iteración
MI(1,1)=0;
MI(1,2)=0;
MI(1,3)=Sg(1,2);
MI(1,5)=0;
MI(1,6)=0;
MI(1,4)=-MI(1,3)-2*z*w*MI(1,5)-(w^2)*MI(1,6);

for i=2:size(Sg,1)
e=1;
MI(i,4)=randi(10,1);
while e > 0.000001
  MI(i,1)=MI(i-1,1)+Dt;  
  MI(i,2)=Dt;
  MI(i,3)=Sg(i,2);  
  MI(i,5)=MI(i-1,5)+Dt*(MI(i,4)+MI(i-1,4))/2;
  MI(i,6)=MI(i-1,6)+MI(i-1,5)*Dt+((1/2-B)*MI(i-1,4)+B*MI(i,4))*Dt^2;
  a=-MI(i,3)-2*z*w*MI(i,5)-(w^2)*MI(i,6);
  e=abs(a-MI(i,4));
  MI(i,4)=a; %recalcular x y x' porque ya estamos en la siguiente fila
  MI(i,5)=MI(i-1,5)+Dt*(MI(i,4)+MI(i-1,4))/2;
  MI(i,6)=MI(i-1,6)+MI(i-1,5)*Dt+((1/2-B)*MI(i-1,4)+B*MI(i,4))*Dt^2;
end
end



 subplot(3,1,1);
plot(Sg(:,1),MI(:,4),'b')
grid on
grid minor
title('Respuestas en Aceleración')
xlabel('Tiempo[s]') 
ylabel('Aceleración [cm/s2]') 
d=[ 'Máx ' num2str(max(abs(MI(:,4))) )   ' cm/s2'];
 legend(d)

subplot(3,1,2);
plot(Sg(:,1),MI(:,5),'g')
grid on
grid minor
title('Respuestas en Velocidad')
xlabel('Tiempo[s]') 
ylabel('Velocidad [cm/s]')
e=[ 'Máx ' num2str(max(abs(MI(:,5))) )   ' cm/s'];
 legend(e)

subplot(3,1,3);
plot(Sg(:,1),MI(:,6),'r')
grid on
grid minor
title('Respuestas en Desplazamiento')
xlabel('Tiempo[s]') 
ylabel('Desplazamiento [cm]')
f=[ 'Máx ' num2str(max(abs(MI(:,6))) )   ' cm'];
 legend(f)


































