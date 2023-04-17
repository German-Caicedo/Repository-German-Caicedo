clc
clear
B=2500; %t/m3
qa=11; % t/m2
h=0.65;
load def_zapcomb_H65cm.txt
% calculos
d=def_zapcomb_H65cm;
qs=abs(d.*B);

nudos=1:1:length(qs);
% %figuras

aux=[1, qa; 73,qa]; %funcion constante para determinar si los puntos sobrepasan el esfuerzo admisible
% nudos sobre qa

for i=1:1:length(qs)
    if qs(i,1)>qa
        z(i,1)=1;
    else
        z(i,1)=0;
    end
end
zt=sum(z);
porc=zt*100/length(qs);
%grafica de #nudos-esfuerzo
figure (1)
hold on
plot(nudos,qs,'-k','linewidth',1.5)
plot(aux(:,1),aux(:,2),'-r','linewidth',2)
xlabel('Nudos')
ylabel('Esfuerzo de trabajo [T/m2]')
title('Esfuerzos de trabajo')
legend(['Espesor de zapata','	','=','',num2str(h), '[m]',newline,'[Porcentaje= ',num2str(porc),'%'] ,'location','southoutside')
hold off
