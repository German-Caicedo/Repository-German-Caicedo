clc
clear all
close all
Ta=importdata('2011 tiempo.txt');%formato de tiempo para todos los años
%Eliminando los caudales del 29 de febrero porque seria necesario crear otra
%serie  y no tenemos grados de libertad
Qbi(:,1)=load('2012 caudal.txt'); Qbi(:,2)=load('2016 caudal.txt'); 
Qbi(5664:5759,:)=[];
Q=zeros(35040,8);
Q(:,1)=load('2011 caudal.txt'); Q(:,2)=Qbi(:,1); Q(:,3)=load('2013 caudal.txt'); Q(:,4)=load('2014 caudal.txt');
Q(:,5)=load('2015 caudal.txt'); Q(:,6)=Qbi(:,2); Q(:,7)=load('2017 caudal.txt');Q(:,8)=load('2018 caudal.txt');
%Conversion a caudales horarios
%Series con datos incompletos
q=zeros(size(Q,1)/4,8);
for i=2319:size(Q,1)/4
 q(i,1)=(Q(4*i-4,1)+Q(4*i,1))/8+(Q(4*i-3,1)+Q(4*i-2,1)+Q(4*i-1,1))/4;    
end
for i=132:size(Q,1)/4
 q(i,2)=(Q(4*i-4,2)+Q(4*i,2))/8+(Q(4*i-3,2)+Q(4*i-2,2)+Q(4*i-1,2))/4;    
end
%Series con datos completos
%Promedio con el ultimo dato del anterior año
for i=3:8
q(1,i)=(Q(size(q,1),i-1)+Q(4,i))/8+(Q(1,i)+Q(2,i)+Q(3,i))/4;
end
%Resto de los promedios
for j=3:8
for i=2:size(q,1)
 q(i,j)=(Q(4*i-4,j)+Q(4*i,j))/8+(Q(4*i-3,j)+Q(4*i-2,j)+Q(4*i-1,j))/4;    
end
end

Qpr=q(:,1:7);Qpr(Qpr==0)=NaN;;Qpr=Qpr(:);
Qvali=q(:,8);
%vector de horas para caudales horarios
t={'01/01/2011 00:00:00'};
t=datetime(t,'Format','dd/MM/yyyy HH:mm:SS');
t(2:size(q,1),1)=t(1,1)+hours(1:size(q,1)-1)';
for i=2:8
    t(:,i)=t(:,1)+calyears(i-1);
end
q(q==0) = NaN;
Q18=q(:,8); Q=q(:,1:7); 
minQ=min(Q(:)); maxQ=max(Q(:));
Q=log(Q-minQ+1); %restarle menos que el caudal minimo porque log(0)=-inf
Qm=nanmean(Q'); Qm=Qm'; %Promedio de todos las series
s=nanstd(Q'); s=s';
%Vector con coef. de correlación
r=zeros(8760,1); 
for i=2:8760
r(i,1)=corr(Q(i,:)',Q(i-1,:)','rows','complete'); 
end
r(1,1)=corr(Q(8760,:)',Q(1,:)','rows','complete');

%Vector con coef. "b" 
b=zeros(8760,1);
for i=2:8760
b(i,1)=r(i,1)*s(i,1)/s(i-1,1);
end
b(1,1)=r(1,1)*s(1,1)/s(8760,1);

k=Q(8760,7);
Qp=zeros(8760,1000);
for j=1:1000
% Componente aleatorio
t = 0 + sqrt(1)*randn(8760,1);
%Caudales 2018
Qp(1,j)=Qm(1,1)+b(1,1)*(k-Qm(8760,1))+t(1,1)*s(1,1)*(1-r(1,1)^2)^0.5;
for i=2:8760
    Qp(i,j)=Qm(i,1)+b(i,1)*(Qp(i-1,j)-Qm(i-1,1))+t(i,1)*s(i,1)*(1-r(i,1)^2)^0.5;
   end
end

%Conversion del pronostico a unidades originales
Qp=exp(Qp)+minQ-1; 
%Matriz con percentiles 9,25,50,75,91
Qperc=[quantile(Qp,0.025,2) quantile(Qp,0.25,2) quantile(Qp,0.50,2) quantile(Qp,0.75,2) quantile(Qp,0.975,2)]; 

Qperc(Qperc<0)=NaN; % para toda la matriz
Qperc(Qperc>=maxQ)=NaN;
x=[1:8760];
for i=1:5
[Qperc(:,i),TF] = fillmissing(Qperc(:,i),'linear','SamplePoints',x);
end
por1=zeros(8760,1);
for i=1:8760
    if Q18(i,1) <= Qperc(i,4) && Q18(i,1) >= Qperc(i,2) 
     por1(i,1)=1;
    end
end
por2=zeros(8760,1);
for i=1:8760
    if Q18(i,1) <= Qperc(i,5) && Q18(i,1) >= Qperc(i,1)
     por2(i,1)=1;
    end
end
% 
% figure(1)
% h1=plot(Qpr,'Color',[0, 0.4470, 0.7410],'LineWidth',1.5);
% hold on
% h2=plot(size(Qpr,1)+1:size(Qpr,1)+size(Qvali,1),Qvali,'Color',[0.4660, 0.6740, 0.1880],'LineWidth',1.5);
% w1 = plot(NaN,NaN,'w'); w2 = plot(NaN,NaN,'w');
% l1=legend([h1 w1 w2 h2], 'Período de prueba',['Caudal máximo = ' num2str(max(Qpr),'%.2f') ' m3/s']...
%     ,['Caudal mínimo = ' num2str(min(Qpr),'%.2f') ' m3/s'],'Período de validación');
% set(l1,'FontSize',15);
% t1=title('Serie cada hora'); set(t1,'FontSize' ,15);
% xlabel('Tiempo [horas]'); ylabel('Caudal [m3/s]'); set(gca,'FontSize',14)
% hold off
% 
% figure(2)
% subplot(2,1,1);
% histogram(Qpr,10:1:541)
% t2=title('Distribución de caudales');set(t2,'FontSize',16);
% ylabel('Caudal [m3/s]'); set(gca,'FontSize',14)
% subplot(2,1,2); 
% histogram(log(Qpr),2.3:.05:6.3)
% t3=title('Distribución de logaritmos de caudales');set(t3,'FontSize',16);
% ylabel('ln(Caudal)')
% set(gca,'FontSize',14)

figure(3)
h1=fill([x, fliplr(x)], [Qperc(:,1)', fliplr(Qperc(:,2)')], [0, 0.4470, 0.7410],'LineStyle','none');
hold on
w3 = plot(NaN,NaN,'w'); w4 = plot(NaN,NaN,'w');w10=plot(NaN,NaN,'w');w11=plot(NaN,NaN,'w');
h2=fill([x, fliplr(x)], [Qperc(:,2)', fliplr(Qperc(:,4)')], [0.3010, 0.7450, 0.9330],'LineStyle','none');
fill([x, fliplr(x)], [Qperc(:,4)', fliplr(Qperc(:,5)')], [0, 0.4470, 0.7410],'LineStyle','none');
w5=plot(x,Q18,'color',[0.6350, 0.0780, 0.1840],'linewidth',1.5);
t4=title('Distribución de las predicciones para cada hora');
set(t4,'FontSize',16);
xlabel('Tiempo [horas]');ylabel('Caudal [m3/s]'); set(gca,'FontSize',14);
l2=legend([h1 w3 w10 h2 w4 w11 w5], 'Rango entre percentiles 2.5-97.5',...
    ['Porcentaje de puntos en el rango= ' num2str(sum(por2)*100/8760,'%.2f') ' %'],...
    ['Tamaño medio del rango= ' num2str(mean(Qperc(:,5)-Qperc(:,1)),'%.2f') ' m3/s'],...
    'Rango intercuartil',...
        ['Porcentaje de puntos en el rango= ' num2str(sum(por1)*100/8760,'%.2f') ' %'],...
    ['Tamaño medio del rango= ' num2str(mean(Qperc(:,4)-Qperc(:,2)),'%.2f') ' m3/s'],...
 ['Registro ']);
set(l2,'FontSize',13);
% 
% MAPE=mean(abs(100*(Q18-mean(Qp,2))./Q18));RMSE= (mean((Q18-mean(Qp,2)).^2)).^0.5;
% n=sum((log(mean(Qp,2))-log(Q18)).^2);d=sum((log(mean(Q18))-log(Q18)).^2);logNSE=100*(1-n/d);
% 
% figure(4)
% 
% subplot(3,1,1);
% h1=plot(Q18,'color',[0.4660, 0.6740, 0.1880],'linewidth',1.5);
% hold on
% w5 = plot(NaN,NaN,'w'); w6 = plot(NaN,NaN,'w'); w7 = plot(NaN,NaN,'w'); w8 = plot(NaN,NaN,'w');...
%     w9 = plot(NaN,NaN,'w');
% t5=title('Media de la distribución de predicciones y valor observado' ); set(t5,'FontSize',16);
% xlabel('Tiempo [horas]'); ylabel('Caudal [m3/s]'); set(gca,'FontSize',12)
% h2=plot(mean(Qp,2),'color',[0.6350, 0.0780, 0.1840],'linewidth',1.5);
% l3=legend([h1 w5 w6 w9 h2 w7 w8],'Observado',...
%     ['Media= ' num2str(mean(Q18),'%.2f') ' m3/s'],...
%     ['Desv. Std= ' num2str(std(Q18),'%.2f') ' m3/s'],...
%     ['logNSE= ' num2str(logNSE,'%.2f') ' %'],...
% 'Pronosticado',...
%     ['Media= ' num2str(mean(mean(Qp,2)),'%.2f') ' m3/s'],...
%     ['Desv. Std= ' num2str(std(mean(Qp,2)),'%.2f') ' m3/s']);
% set(l3,'FontSize',11,'NumColumns',2);
% hold off
% subplot(3,1,2);
% plot(Q18-mean(Qp,2),'color',[0.9290, 0.6940, 0.1250],'linewidth',1.5);
% hold on
% plot(ones(size(Q18,1),1)*mean(Q18-mean(Qp,2)),'--','color',[1 0 0.6],'linewidth',1.5)
% t6=title('Errores');
% set(t6,'FontSize',16);
% l4=legend(['RMSE= ' num2str(RMSE,'%.2f') ' m3/s'],...
%     ['Media= ' num2str(mean((Q18-mean(Qp,2))),'%.2f') ' m3/s']); set(l4,'FontSize',12);
% xlabel('Tiempo [horas]'); ylabel('Caudal [m3/s]');set(gca,'FontSize',12)
% subplot(3,1,3);
% plot(100*(Q18-mean(Qp,2))./Q18,'color',[0.3010, 0.7450, 0.9330],'linewidth',1.5);
% t7=title('Errores percentuales'); set(t7,'FontSize',16);
% l5=legend(['MAPE= ' num2str(MAPE,'%.2f') ' %']); set(l5,'FontSize',12);
% xlabel('Tiempo [horas]');ylabel('%');
% set(gca,'FontSize',12)
% 
% figure(5)
% subplot(2,2,[1,3]);
% histfit(Q18-mean(Qp,2),1000)
% t8=title('Histograma de los errores');set(t8,'FontSize',16);
% subplot(2,2,2);
% autocorr(Q18-mean(Qp,2))
% t9=title('Función de autocorrelación de los errores');set(t9,'FontSize',16);
% xlabel('Retraso'); ylabel('ACF'); set(gca,'FontSize',12)
% subplot(2,2,4);
% parcorr(Q18-mean(Qp,2))
% t10=title('Función de autocorrelación parcial de los errores');set(t10,'FontSize',16);
% xlabel('Retraso'); ylabel('PACF'); set(gca,'FontSize',12)
% 
% figure(6)
% subplot(2,2,[1,3]);
% qqplot(Q18-mean(Qp,2))
% t11=title('Gráfico Q-Q');set(t11,'FontSize',14);
% xlabel('Cuantiles de la distribución estandar normal'); ylabel('Cuantiles de la  muestra'); set(gca,'FontSize',12)
% subplot(2,2,2);
% autocorr((Q18-mean(Qp,2)).^2)
% t12=title('Función de autocorrelación de los errores al cuadrado');set(t12,'FontSize',14);
% xlabel('Retraso'); ylabel('ACF'); set(gca,'FontSize',12)
% subplot(2,2,4);
% parcorr((Q18-mean(Qp,2)).^2)
% t13=title('Función de autocorrelación parcial de los errores al cuadrado');set(t13,'FontSize',14);
% xlabel('Retraso'); ylabel('PACF'); set(gca,'FontSize',12)
% 
% dm=[31;59;90;120;151;181;212;243;273;304;334;365];
% 
% X=zeros(31*24,12,2);
% X(1:dm(1,1)*24,1,1)=Q18(1:dm(1,1)*24,1);
% for i=1:11
% X(1:(dm(i+1,1)*24-dm(i,1)*24),i+1,1)=Q18(dm(i,1)*24+1:dm(i+1,1)*24,1);
% end
% X(1:dm(1,1)*24,1,2)=Qperc(1:dm(1,1)*24,3);
% for i=1:11
% X(1:(dm(i+1,1)*24-dm(i,1)*24),i+1,2)=Qperc(dm(i,1)*24+1:dm(i+1,1)*24,3);
% end
% 
% Qprom(:,1)=nanmean(X(:,:,1),1)';Qprom(:,2)=nanmean(X(:,:,2),1)';
% Qsd(:,1)=nanstd(X(:,:,1),1)';Qsd(:,2)=nanstd(X(:,:,2),1)';
% figure(7)
% bar(Qprom)
% xlabel('[Meses]');ylabel('Caudal [m3/s]');set(gca,'FontSize',12)
% t14=title('Media de cada mes'); set(t14,'FontSize',16);
% figure(8)
% bar(Qsd)
% xlabel('[Meses]');ylabel('Caudal [m3/s]');set(gca,'FontSize',12)
% t15=title('Desviación estándar de cada mes'); set(t15,'FontSize',16);