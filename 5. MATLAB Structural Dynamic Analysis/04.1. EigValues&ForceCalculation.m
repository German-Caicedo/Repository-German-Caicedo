clc
clear all
close all

g=980; %cm/s2 
n=2.48; Z=0.4*g; %suelo en Tulcán
r=1; R=6; fip=1; fie=1; Imp=1;
Fa=1.2; Fd=1.19; Fs=1.28; %Suelo tipo D de Damián
To=0.1*Fs*Fd/Fa; Tc=0.55*Fs*Fd/Fa; %limites de las funciones del espectro
syms T
Sp1=n*Z*Fa/(R*fip*fie);                         %T<Tc
Sp2=n*Z*Fa*((Tc./T).^r)/(R*fip*fie);    % Tc<T

E=14.1*(240^0.5);  %t/cm2
I1=(100^4)/12;  %cm4    falta la sección de la col. grande
I2=(45^4)/12;  %cm4  
k1=12*E*I1/(400^3);
k2=12*E*I2*9/(400^3);
k=[k1+k2 -k2 0 0; -k2 k2+k2 -k2 0; 0 -k2 k2+k2 -k2; 0 0 -k2 k2];
M= [68.74 0 0 0;0 179.36 0 0; 0 0 179.36 0; 0 0 0 179.36]./g; %faltan los pesos de los pisos superiores
[phi,w2] = eig(k,M);    w=w2.^0.5;
phi1=phi(:,1); phi2=phi(:,2); phi3=phi(:,3); phi4=phi(:,4);
Mi= [phi1'*M*phi1 ; phi2'*M*phi2 ;  phi3'*M*phi3; phi4'*M*phi4 ];
phiN=[phi(:,1)*Mi(1,1) phi(:,2)*Mi(2,1) phi(:,3)*Mi(3,1) phi(:,4)*Mi(4,1)  ];
r=[1 ; 1 ; 1; 1];
L=(phiN')*M*r;
mt=sum(diag(M));
ME=(L.^2)./mt;
MEac=[1  ME(1,1)*100;2 (ME(1,1)+ME(2,1))*100; 3 (ME(1,1)+ME(2,1)+ME(3,1))*100 ];
TT=2*pi./diag(w);
T=TT(1,1); Sa(1,1)=double(subs(Sp1 ));   
T=TT(2,1); Sa(2,1)=double(subs(Sp1 )) ; 
T=TT(3,1); Sa(3,1)=double(subs(Sp1 ));   
T=TT(4,1); Sa(4,1)=double(subs(Sp1 )) ; 

ww=diag(w);
qmax=[(L(1,1)*Sa(1,1)./(ww(1,1)^2))*phiN(:,1)  (L(2,1)*Sa(2,1)./(ww(2,1)^2))*phiN(:,2) (L(3,1)*Sa(3,1)./(ww(3,1)^2))*phiN(:,3) (L(4,1)*Sa(4,1)./(ww(4,1)^2))*phiN(:,4) ];
Qmax=[L(1,1)*Sa(1,1)*M*phiN(:,1)  L(2,1)*Sa(2,1)*M*phiN(:,2) L(3,1)*Sa(3,1)*M*phiN(:,3)  L(4,1)*Sa(4,1)*M*phiN(:,4)  ];

ABS=[abs(Qmax(1,1))+abs(Qmax(1,2))+abs(Qmax(1,3))+abs(Qmax(1,4)); abs(Qmax(2,1))+abs(Qmax(2,2))+abs(Qmax(2,3))++abs(Qmax(2,4)); abs(Qmax(3,1))+abs(Qmax(3,2))+abs(Qmax(3,3))++abs(Qmax(3,4)) ;abs(Qmax(4,1))+abs(Qmax(4,2))+abs(Qmax(4,3))++abs(Qmax(4,4))];
 SRSS=[(Qmax(1,1)^2+Qmax(1,2)^2+Qmax(1,3)^2+Qmax(1,4)^2)^0.5 ; (Qmax(2,1)^2+Qmax(2,2)^2+Qmax(2,3)^2+Qmax(2,4)^2)^0.5;  (Qmax(3,1)^2+Qmax(3,2)^2+Qmax(3,3)^2+Qmax(3,4)^2)^0.5;  (Qmax(4,1)^2+Qmax(4,2)^2+Qmax(4,3)^2+Qmax(4,4)^2)^0.5 ];
Fdis= [(ABS(1,1)+SRSS(1,1))/2 ;(ABS(2,1)+SRSS(2,1))/2; (ABS(3,1)+SRSS(3,1))/2; (ABS(4,1)+SRSS(4,1))/2 ];

 V=sum(Fdis)*Imp

   plot([0;Fdis(1,1);Fdis(2,1);Fdis(3,1);Fdis(4,1)],[0;4;8;12;16],'r')
   xlabel('Fuerzas  [t]');
   ylabel('Altura [m]');
   text(Fdis(1,1),4,['(' num2str(Fdis(1,1)) ',' num2str(4) ')'])
   text(Fdis(2,1),8,['(' num2str(Fdis(2,1)) ',' num2str(8) ')'])
    text(Fdis(3,1),12,['(' num2str(Fdis(3,1)) ',' num2str(12) ')'])
   text(Fdis(4,1),16,['(' num2str(Fdis(4,1)) ',' num2str(16) ')']) 
  title(['Distribución de fuerzas'])


