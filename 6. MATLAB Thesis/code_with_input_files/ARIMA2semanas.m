clc
clear all
close all
Qbi(:,1)=load('2012 caudal.txt'); Qbi(:,2)=load('2016 caudal.txt'); 
Qbi(5664:5759,:)=[];
Q=zeros(35040,8);
Q(:,1)=load('2011 caudal.txt'); Q(:,2)=Qbi(:,1); Q(:,3)=load('2013 caudal.txt'); Q(:,4)=load('2014 caudal.txt');
Q(:,5)=load('2015 caudal.txt'); Q(:,6)=Qbi(:,2); Q(:,7)=load('2017 caudal.txt');Q(:,8)=load('2018 caudal.txt');
Q18=Q(:,8);Q17=Q(:,7); Q=Q(:,1:7);
u11=find(~isnan(Q(:,1)),1)-1; %ultimo valor NaN en 2011 
u12=find(~isnan(Q(:,2)),1)-1; %ultimo valor NaN en 2012
Q(1:u12,1)=mean(Q(1:u12,3:7),2);
Q(1:u12,2)=mean(Q(1:u12,3:7),2);
Q(u12+1:u11,1)=mean(Q(u12+1:u11,2:7),2);
Q=[Q Q18];

 for i=1:8
 T(:,:,i)=reshape(Q(:,i),96,365);    
 end

for i=1:8
R(:,i)=nanmean(T(:,:,i)',2); %promedios diarios
end
R(366:378,:)=NaN;
Q18=R(:,8);Q=R(:,1:7);


Q=Q(:); Q=reshape(Q,14,189); Q2sem=nanmean(Q,1)'; %promedios semanales
Q18=reshape(Q18,14,27);Q2sem18=nanmean(Q18,1)';

% D = LagOp({1 -1},'Lags',[0,27]);
% dY = filter(D,Q2sem);
% Y=dY;
% h = adftest(Y) %augmented Dickey-Fuller test para comprobar estacionalidad
% figure(1) %para averiguar que modelos arima es prudente utilizar
% parcorr(Y,'NumLags',60,'NumSTD',2) 
% figure(2)
% autocorr(Y,'NumLags',60,'NumSTD',2)

y=Q2sem;
T = length(y);

for Q=1:2
      for P=1:2
         for p=1:3
 Mdl(p,P,Q) = arima('ARLags',p,'SARLags',27:27:P*27,'SMALags',27:27:Q*27,'Seasonality',27);
 pp(p,P,Q)=p;
 PP(p,P,Q)=P;
 QQ(p,P,Q)=Q;
         end
     end
end
 Mdl=Mdl(:);pp=pp(:);PP=PP(:);QQ=QQ(:);
 
LOGL = zeros(12,1); PQ = zeros(12,1);
for i=1:12
        [fit,~,logL] = estimate( Mdl(i),y,'Display','off');
        LOGL(i,1) = logL; %funcion de maxima verosimilitud
        BIC1(i,1) = pp(i)+PP(i)+QQ(i); %numero de parametros para BIC
end

[~,bic] = aicbic(LOGL,BIC1+1,189);
[M,I] = min(bic) % el mejor es el SARIMA(1,0,0)(2,1,2)52 ----posicion 10

EstMdl = estimate(Mdl(10),y);
[yF,yMSE] = forecast(EstMdl,27,'Y0',y); %Pronostico MMSE
[YMc,E] = simulate(EstMdl,27,'NumPaths',1000,'Y0',y); %Pronostico montecarlo
Qperc=[quantile(YMc,0.025,2) quantile(YMc,0.25,2) quantile(YMc,0.50,2) quantile(YMc,0.75,2) quantile(YMc,0.975,2)];

por1=zeros(27,1);
for i=1:27
    if Q2sem18(i,1) <= Qperc(i,4) && Q2sem18(i,1) >= Qperc(i,2) 
     por1(i,1)=1;
    end
end
por2=zeros(27,1);
for i=1:27
    if Q2sem18(i,1) <= Qperc(i,5) && Q2sem18(i,1) >= Qperc(i,1)
     por2(i,1)=1;
    end
end

x=[1:27]; Q18=Q2sem18;Qp=YMc;

figure(3)
h1=fill([x, fliplr(x)], [Qperc(:,1)', fliplr(Qperc(:,2)')], [0, 0.4470, 0.7410],'LineStyle','none');
hold on
w3 = plot(NaN,NaN,'w'); w4 = plot(NaN,NaN,'w');w10=plot(NaN,NaN,'w');w11=plot(NaN,NaN,'w');
h2=fill([x, fliplr(x)], [Qperc(:,2)', fliplr(Qperc(:,4)')], [0.3010, 0.7450, 0.9330],'LineStyle','none');
fill([x, fliplr(x)], [Qperc(:,4)', fliplr(Qperc(:,5)')], [0, 0.4470, 0.7410],'LineStyle','none');
w5=plot(x,Q18,'color',[0.6350, 0.0780, 0.1840],'linewidth',1.5);
t4=title('Distribución de las predicciones para cada 2 semanas');
set(t4,'FontSize',16);
xlabel('Tiempo [2 semanas]');ylabel('Caudal [m3/s]'); set(gca,'FontSize',14);
l2=legend([h1 w3 w10 h2 w4 w11 w5], 'Rango entre percentiles 2.5-97.5',...
    ['Porcentaje de puntos en el rango= ' num2str(sum(por2)*100/27,'%.2f') ' %'],...
    ['Tamaño medio del rango= ' num2str(mean(Qperc(:,5)-Qperc(:,1)),'%.2f') ' m3/s'],...
    'Rango intercuartil',...
        ['Porcentaje de puntos en el rango= ' num2str(sum(por1)*100/27,'%.2f') ' %'],...
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
% xlabel('Tiempo [2 semanas]'); ylabel('Caudal [m3/s]'); set(gca,'FontSize',12)
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
% xlabel('Tiempo [2 semanas]'); ylabel('Caudal [m3/s]');
% set(gca,'FontSize',12)
% subplot(3,1,3);
% plot(100*(Q18-mean(Qp,2))./Q18,'color',[0.3010, 0.7450, 0.9330],'linewidth',1.5);
% t7=title('Errores percentuales'); set(t7,'FontSize',16);
% l5=legend(['MAPE= ' num2str(MAPE,'%.2f') ' %']); set(l5,'FontSize',12);
% xlabel('Tiempo [2 semanas]');ylabel('%');
% set(gca,'FontSize',12)
% 
% figure(5)
% subplot(2,2,[1,3]);
% histfit(Q18-mean(Qp,2),10)
% t8=title('Histograma de los errores');set(t8,'FontSize',16);
% subplot(2,2,2);
% autocorr(Q18-mean(Qp,2),'NumLags',12)
% t9=title('Función de autocorrelación de los errores');set(t9,'FontSize',16);
% xlabel('Retraso'); ylabel('ACF'); set(gca,'FontSize',12)
% subplot(2,2,4);
% parcorr(Q18-mean(Qp,2),'NumLags',12)
% t10=title('Función de autocorrelación parcial de los errores');set(t10,'FontSize',16);
% xlabel('Retraso'); ylabel('PACF'); set(gca,'FontSize',12)
% 
% figure(6)
% subplot(2,2,[1,3]);
% qqplot(Q18-mean(Qp,2))
% t11=title('Gráfico Q-Q');set(t11,'FontSize',14);
% xlabel('Cuantiles de la distribución estandar normal'); ylabel('Cuantiles de la  muestra'); set(gca,'FontSize',12)
% subplot(2,2,2);
% autocorr((Q18-mean(Qp,2)).^2,'NumLags',12)
% t12=title('Función de autocorrelación de los errores al cuadrado');set(t12,'FontSize',14);
% xlabel('Retraso'); ylabel('ACF'); set(gca,'FontSize',12)
% subplot(2,2,4);
% parcorr((Q18-mean(Qp,2)).^2,'NumLags',12)
% t13=title('Función de autocorrelación parcial de los errores al cuadrado');set(t13,'FontSize',14);
% xlabel('Retraso'); ylabel('PACF'); set(gca,'FontSize',12)

