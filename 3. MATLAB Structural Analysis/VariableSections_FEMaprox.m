clc
clear all
close all
A=load('APOYO.txt');
CA=load('CARGA.txt');
CARVA=load('CARVA.txt');
C=load('CONEC.txt');
CO=load('COORD.txt');
C(:,7)=C(:,7)*10;
disc=[1 2 4 8 16 32 64 90 100 115];
 
for i=1:size(C,1)
    X(i,1)=sqrt((CO(C(i,1),1)-CO(C(i,2),1))^2+(CO(C(i,1),2)-CO(C(i,2),2))^2);
end
syms x
for i=1:size(C,1)
    hx(i,1)=C(i,5)+(C(i,6)-C(i,5))*x/X(i);
end
Ax=hx.*C(:,4);   Ix=(hx.^3).*C(:,4)/12;
for i=1:size(C,1)
 f11(i,1)=double(int(1/(Ax(i)*C(i,7)),[0 X(i)]));
f22(i,1)=double(int(((X(i)-x)^2)/(C(i,7)*Ix(i)),[0 X(i)]));
f23(i,1)=double(int((X(i)-x)/(C(i,7)*Ix(i)),[0 X(i)]));
f33(i,1)=double(int(1/(C(i,7)*Ix(i)),[0 X(i)]));
end
f32=f23;
K=zeros(6,6,size(C,1));
for i=1:size(C,1)
    
K(5,6,i)= f23(i)/(f23(i)^2-f22(i)*f33(i));
K(6,6,i) = f22(i)/(f22(i)*f33(i)-f23(i)^2);
K(2,6,i)=-K(5,6,i);
K(3,6,i)=-K(6,6,i)-K(5,6,i)*X(i);
K(4,4,i)=1/f11(i);
K(1,4,i)=-K(4,4,i);
K(5,5,i)=f33(i)/(f22(i)*f33(i)-f23(i)^2);
K(6,5,i)=f23(i)/(f23(i)^2-f22(i)*f33(i));
K(3,5,i)=-K(6,5,i)-K(5,5,i)*X(i);
K(2,5,i)=-K(5,5,i);    
end
K(4,1,:)=K(1,4,:); K(5,2,:)=K(2,5,:); K(6,2,:)=K(2,6,:); K(5,3,:)=K(3,5,:); K(6,3,:)=K(3,6,:);
for i=1:size(C,1)
    for j=1:size(CARVA,1)
        if CARVA(j,1)==i
 dt1(i,1)=-double(int(CARVA(j,2)*(((x-X(i))^2)*(X(i)-x))/(2*C(i,7)*Ix(i)),[0 X(i)])) ;     
 th1(i,1)=-double(int(CARVA(j,2)*((x-X(i))^2)/(2*C(i,7)*Ix(i)),[0 X(i)]));      
        else                              
        end
    end 
end
for i=1:size(dt1,1)
    QQ1(:,i)=-inv([f22(i,1) f23(i,1) ; f23(i,1) f33(i,1)])*([dt1(i,1) ; th1(i,1)]);    
end
C(:,[5 6])=C(:,[6 5]);
for i=1:size(C,1)
    hx(i,1)=C(i,5)+(C(i,6)-C(i,5))*x/X(i);
end
Ax=hx.*C(:,4);   Ix=(hx.^3).*C(:,4)/12;
for i=1:size(C,1)
 f11(i,1)=double(int(1/(Ax(i)*C(i,7)),[0 X(i)]));
f22(i,1)=double(int(((X(i)-x)^2)/(C(i,7)*Ix(i)),[0 X(i)]));
f23(i,1)=double(int((X(i)-x)/(C(i,7)*Ix(i)),[0 X(i)]));
f33(i,1)=double(int(1/(C(i,7)*Ix(i)),[0 X(i)]));
end
f32=f23;
for i=1:size(C,1)   
K(2,3,i)= -f23(i)/(f23(i)^2-f22(i)*f33(i));
K(3,3,i) = f22(i)/(f22(i)*f33(i)-f23(i)^2);
K(1,1,i)=1/f11(i);
K(2,2,i)=f33(i)/(f22(i)*f33(i)-f23(i)^2);
K(3,2,i)=-f23(i)/(f23(i)^2-f22(i)*f33(i)); 
end
    for i=1:size(C,1)
    for j=1:size(CARVA,1)
        if CARVA(j,1)==i
 dt2(i,1)=-double(int(CARVA(j,2)*(((x-X(i))^2)*(X(i)-x))/(2*C(i,7)*Ix(i)),[0 X(i)])) ;     
 th2(i,1)=-double(int(CARVA(j,2)*((x-X(i))^2)/(2*C(i,7)*Ix(i)),[0 X(i)]));      
        else                              
        end
    end 
end
for i=1:size(dt2,1)
    QQ2(:,i)=-inv([f22(i,1) f23(i,1) ; f23(i,1) f33(i,1)])*([dt2(i,1) ; th2(i,1)]);
end
QQ=[ QQ2(1,:);-QQ2(2,:); QQ1];
IC=size(CO,1)*3-size(find(A(:,2:4)),1);
G=zeros(size(CO,1),3);
for i=1:size(CO,1)
    for j=1:size(A,1)
        if i==A(j,1)
            G(i,:)=A(j,2:4);
        else
        end
    end
end
t=1;
r=IC+1;
GDL=zeros(size(CO,1),3);
for i=1:size(CO,1)
    if G(i,1)==0
        GDL(i,1)=t; 
        t=t+1;
    else
        GDL(i,1)=r ; 
        r=r+1;
    end
    if G(i,2)==0
        GDL(i,2)=t; 
        t=t+1;  
    else
        GDL(i,2)=r; 
        r=r+1;
    end
      if G(i,3)==0
          GDL(i,3)=t; 
          t=t+1;
    else
        GDL(i,3)=r;
        r=r+1;
      end
end
for i=1:size(C,1)
cos(i,1)=(CO(C(i,2),1)-CO(C(i,1),1))/X(i);
sen(i,1)=(CO(C(i,2),2)-CO(C(i,1),2))/X(i);
end
T=zeros(6,6,size(C,1));
for i=1:size(C,1)
T(1,1,i)=cos(i); T(1,2,i)=-sen(i); T(2,1,i)=sen(i); T(2,2,i)=cos(i); T(3,3,i)=1;
T(4,4,i)=cos(i); T(4,5,i)=-sen(i); T(5,4,i)=sen(i); T(5,5,i)=cos(i); T(6,6,i)=1;
end
U=zeros(size(C,1),6);
for i= 1:size(C,1)
    for j= 1:size(CO,1)
        if C(i,1)==j
            U(i,1)=GDL(j,1); 
            U(i,2)=GDL(j,2);
            U(i,3)=GDL(j,3);
        else
                end
    end
end
for i= 1:size(C,1)
    for j= 1:size(CO,1)
        if C(i,2)==j
            U(i,4)=GDL(j,1);
            U(i,5)=GDL(j,2);
            U(i,6)=GDL(j,3);
        else
                end
    end
end
L=zeros(size(CO,1)*3,6,size(C,1));
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
FEPL= [zeros(1,size(QQ,2)); QQ(1,:); QQ(2,:);zeros(1,size(QQ,2)); QQ(3,:);QQ(4,:)];
for i=1:size(FEPL,2)
    FEPG(:,i)= L(:,:,i)*T(:,:,i)*FEPL(:,i);
end
SFEPG=zeros(size(FEPG,1),1);
for i=1:size(FEPL,2)
    SFEPG=SFEPG+FEPG(:,i);
end
KQQ=KE(1:IC,1:IC);
p=zeros(size(CO,1),3);
for i=1:size(CA,1)
    for j=1:size(CO,1)
    if CA(i,1)==j
        p(j,:)=CA(i,2:4);
    end
    end
end
[v1,v2]=find(p);
V= [v1 v2];
P=zeros(size(CO,1)*3,1);
for i=1:size(V,1)    
    P((GDL(V(i,1),V(i,2))),1)=p(V(i,1),V(i,2));
end
 
Q=P(1:IC,:);
DQ=inv(KQQ)*(Q-SFEPG(1:IC,1));
 
KRQ=KE(IC+1:size(KE,1),1:IC); 
R=KRQ*DQ+SFEPG(IC+1:size(SFEPG,1),1);
 
MA(1,1)=R(3,1);
RyD(1,1)=R(5,1);
XB(1,1)=DQ(1,1);
thC(1,1)=DQ(12,1);
clearvars -except RyD MA XB thC disc

disc=[1 2 4 8 16 32 64 90 100 115];
for cn=1:11     
A=load('APOYO.txt');
CA=load('CARGA.txt');
CARVA=load('CARVA.txt');
C=load('CONEC.txt');
CO=load('COORD.txt');
 
C(:,7)=C(:,7)*10;
if cn <= 10
C(:,3)=disc(cn);
else
end
 NP = zeros(size(C,1), 1);
for i=1:size(C,1)
    if C(i,5)~=C(i,6)
        NP(i,1)=i;
    else
    end
end
NP(NP==0)=[];
 
 X = zeros(size(C, 1), 1); %prov
cos = zeros(size(C, 1), 1);
sen = zeros(size(C, 1), 1);

for i=1:size(C,1)
    X(i,1)=sqrt((CO(C(i,1),1)-CO(C(i,2),1))^2+(CO(C(i,1),2)-CO(C(i,2),2))^2);
end
 
for i=1:size(C,1)
cos(i,1)=(CO(C(i,2),1)-CO(C(i,1),1))/X(i);
sen(i,1)=(CO(C(i,2),2)-CO(C(i,1),2))/X(i);
end
for i=1: size(C,1)
    for j=1:size(CARVA,1)
        if i==CARVA(j,1)
        C(i,10)=CARVA(j,2);
        else
        end
    end
end
N = zeros(size(NP,1),12);
for i=1: size(NP,1)
    for j=1:size(C,1)
        if NP(i,1)==j
            N(i,1)=C(j,5); 
            N(i,2)=C(j,6);  
            N(i,3)=X(j);  
            N(i,4)=C(j,4); 
            N(i,5)=C(j,3); 
            N(i,6)=C(j,1); 
            N(i,7)=C(j,2);
            N(i,8)=j; 
            N(i,9)=C(j,7); 
            N(i,10)= cos(j,1); 
             N(i,11)= sen(j,1);  
             N(i,12)=C(j,10);
                  else
        end
    end
end
syms x
nRows = size(N, 1);
hx = sym(zeros(nRows, 1));
for i=1:size(N,1)
hx(i,1)=N(i,1)+(N(i,2)-N(i,1))*x/N(i,3);
   end
Ax=hx.*N(:,4);
Ix=(hx.^3).*N(:,4)/12;
I = zeros(size(N, 1), max(N(:, 5))); % PROV
AA = zeros(size(N, 1), max(N(:, 5)));
% I = zeros(size(N,1),N(:,5));
for i=1:size(N,1)
    for j=1:N(i,5)
I(i,j)=double(int(Ix(i),[N(i,3)*(j-1)/N(i,5) N(i,3)*j/N(i,5)])/(N(i,3)/N(i,5)));
    end
end
I=I';
I=I(:);
% AA = zeros(size(N,1), N(:,5));
for i=1:size(N,1)
    for j=1:N(i,5)
        x=(N(i,3))*(j-1/2)/(N(i,5));
AA(i,j)=subs(Ax(i));
    end
end
AA=double(AA);
AA=AA';
AA=AA(:);
    for i=1:size(C,1)
      for j= 1:size(NP,1)
          if C(NP(j,1))==i
              C(i,:)=0;
          end
      end
    end  
     C(all(~C,2), : ) = [];
 C(:,8)=C(:,4).*C(:,5);
  C(:,9)=C(:,4).*(C(:,5).^3)./12;
   C(:,3:6)=[]; 
 s=size(C,1)+1;
 C=[C ; zeros(size(AA,1),size(C,2))];
C(s:size(C,1),4)=AA;
 C(s:size(C,1),5)=I; 
 for i=1:size(N,1)
         C(s:s+N(i,5)-1,3)= N(i,9);
         C(s:s+N(i,5)-1,6)= N(i,12);
         s=s+N(i,5);
 end 
 NN(:,1)=N(:,5)-1; 
 NN(:,2)=N(:,6) ;
 NN(:,3)= N(:,3)./N(:,5); 
  NN(:,4)= NN(:,3).*N(:,10);  
  NN(:,5)=NN(:,3).*N(:,11);      
  NN(:,6)= N(:,7);   
  for i=1:size(NN,1)
    NN(i,7)=CO(NN(i,2),1); 
    NN(i,8)= CO(NN(i,2),2); 
  end  
    a=size(CO,1);
  f=size(CO,1)+1;
  CO= [CO ; zeros(sum(NN(:,1)),2)]; 
  
  for i=1:size(NN,1)
      for j=1:NN(i,1)
          if j==1
         CO(j+a,1)=NN(i,7)+NN(i,4);
         CO(j+a,2)=NN(i,8)+NN(i,5);
                   else
           CO(j+a,1)=CO(j+a-1,1)+NN(i,4); 
           CO(j+a,2)=CO(j+a-1,2)+NN(i,5);
          end      
      end
    a=a+j;
  end
 NR = zeros(size(N, 1), max(N(:, 5)) + 1); %PROV
  for i=1:size(N,1)      
      for j=1:N(i,5)+1
          if j==1
              NR(i,j)=NN(i,2);
          else
              if j==N(i,5)+1
                  NR(i,j)=NN(i,6);
              else
              NR(i,j)=f;
              f=f+1;
              end
          end
  end
  end
   
 a=size(find(C(:,1)),1);
 
  for i=1:size(N,1)
      for j=1:N(i,5)
          C(j+a,1)=NR(i,j);
          C(j+a,2)=NR(i,j+1);
      end
      a=a+j;
  end 
  XX = zeros(size(C, 1), 1); %prov
  for i=1:size(C,1)
    XX(i,1)=sqrt((CO(C(i,1),1)-CO(C(i,2),1))^2+(CO(C(i,1),2)-CO(C(i,2),2))^2);
  end   
       
  for i=1:size(C,1)      
 K(1,1,i)= C(i,4)*C(i,3)/XX(i);
K(2,2,i)= 12*C(i,3)*C(i,5)/(XX(i)^3);
K(2,3,i)= 6*C(i,3)*C(i,5)/(XX(i)^2);
K(3,3,i)= 4*C(i,3)*C(i,5)/XX(i);
K(3,2,i)=K(2,3,i);K(4,4,i)=K(1,1,i);K(1,4,i)=-K(1,1,i);K(4,1,i)=-K(1,1,i);K(5,2,i)=-K(2,2,i);K(2,5,i)=-K(2,2,i); K(2,6,i)=K(2,3,i);
K(6,2,i)=K(2,3,i);K(3,5,i)=-K(3,2,i);K(5,3,i)=-K(3,2,i);K(3,6,i)=K(3,3,i)/2;K(6,3,i)=K(3,3,i)/2;K(5,5,i)=K(2,2,i);K(6,6,i)=K(3,3,i);
K(5,6,i)=-K(2,3,i);K(6,5,i)=-K(2,3,i);
  end
IC=size(CO,1)*3-size(find(A(:,2:4)),1);
 
G=zeros(size(CO,1),3);
for i=1:size(CO,1)
    for j=1:size(A,1)
        if i==A(j,1)
            G(i,:)=A(j,2:4);
        else
        end
    end
end
 
t=1;
r=IC+1;
GDL=zeros(size(CO,1),3);
for i=1:size(G,1)
    for j=1:size(G,2)
        if G(i,j)==1
            GDL(i,j)=r;
            r=r+1;
        else
            GDL(i,j)=t;
            t=t+1;
        end
    end
end
ncos = zeros(size(C, 1), 1); %PROV
nsen = zeros(size(C, 1), 1);
for i=1:size(C,1)
    ncos(i,1)=(CO(C(i,2),1)-CO(C(i,1),1))/XX(i);
    nsen(i,1)=(CO(C(i,2),2)-CO(C(i,1),2))/XX(i);
end
T=zeros(6,6,size(C,1));
for i=1:size(C,1)
T(1,1,i)=ncos(i); T(1,2,i)=-nsen(i); T(2,1,i)=nsen(i); T(2,2,i)=ncos(i); T(3,3,i)=1;
T(4,4,i)=ncos(i); T(4,5,i)=-nsen(i); T(5,4,i)=nsen(i); T(5,5,i)=ncos(i); T(6,6,i)=1;
end
U=zeros(size(C,1),6);
for i= 1:size(C,1)
    for j= 1:size(CO,1)
        if C(i,1)==j
            U(i,1)=GDL(j,1); 
            U(i,2)=GDL(j,2);
            U(i,3)=GDL(j,3);
        else
                end
    end
end
for i= 1:size(C,1)
    for j= 1:size(CO,1)
        if C(i,2)==j
            U(i,4)=GDL(j,1);
            U(i,5)=GDL(j,2);
            U(i,6)=GDL(j,3);
        else
                end
    end
end
L=zeros(size(CO,1)*3,6,size(C,1));
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
KQQ=KE(1:IC,1:IC);
p=zeros(size(CO,1),3);
for i=1:size(CA,1)
    for j=1:size(CO,1)
    if CA(i,1)==j
        p(j,:)=CA(i,2:4);
    end
    end
end
[v1,v2]=find(p);
V= [v1 v2];
P=zeros(size(CO,1)*3,1);
for i=1:size(V,1)    
    P((GDL(V(i,1),V(i,2))),1)=p(V(i,1),V(i,2));
end
Q=P(1:IC,:);
for i=1:size(C,1)
    FEP(2,i)= XX(i,1)*C(i,6)/2;
    FEP(3,i)= (XX(i,1)^2)*C(i,6)/12;
    FEP(5,i)= XX(i,1)*C(i,6)/2;
    FEP(6,i)= -(XX(i,1)^2)*C(i,6)/12;
end
for i=1:size(C,1)
    FEPG(:,i)=L(:,:,i)*T(:,:,i)*FEP(:,i) ;     
end
SFEPG=zeros(size(FEPG,1),1);
for i=1:size(FEP,2)
    SFEPG=SFEPG+FEPG(:,i);
end
DQ=inv(KQQ)*(Q-SFEPG(1:IC,1));
KRQ=KE(IC+1:size(KE,1),1:IC); 
R=KRQ*DQ+SFEPG(IC+1:size(SFEPG,1),1);
MA(cn+1,1)=R(3,1);
RyD(cn+1,1)=R(5,1);
XB(cn+1,1)=DQ(1,1);
thC(cn+1,1)=DQ(12,1);
clearvars -except RyD MA XB thC disc R DQ IC
end
fprintf('********************************************************* \n ')
fprintf(' Con el nivel de discretización ingresado:\n');
fprintf('La reacción en el eje x de A es igual a  '), fprintf('%.2f t.\n', R(1,1))
fprintf('La reacción en el eje y de A es igual a  '), fprintf('%.2f t.\n', R(2,1))
fprintf('El momento de reaccion en A es igual a  '), fprintf('%.2f tm.\n', R(3,1))
fprintf('La reacción en el eje x de D es igual a  '), fprintf('%.2f t.\n', R(4,1))
fprintf('La reacción en el eje y de D es igual a  '), fprintf('%.2f t.\n', R(5,1))
fprintf('El momento de reaccion en D es igual a  '), fprintf('%.2f tm.\n', R(6,1))
fprintf('********************************************************** \n ')
fprintf(' Los desplazamientos en los GDL desconocidos son:\n ');
fprintf(' GDL \t desplazamientos (cm y rad^-2)  \n');
 fprintf('     %1.0f  \t\t  %0.4f \n ', [[1:IC];(DQ.*100)'] )
 fprintf('********************************************************** \n ')
fprintf('El desplazamiento horizontal en B es igual a '), fprintf('%.5f cm.\n', DQ(1,1)*100)
fprintf('El desplazamiento vertical en B es igual a   '), fprintf('%.5f cm.\n', DQ(2,1)*100)
fprintf('El giro en B es igual a   '), fprintf('%.5f rad.*10^-2\n', DQ(3,1)*100)
fprintf('El desplazamiento horizontal en C es igual a  '), fprintf('%.5f cm.\n', DQ(10,1)*100)
fprintf('El desplazamiento vertical en C es igual a   '), fprintf('%.5f cm.\n', DQ(11,1)*100)
fprintf('El giro en C es igual a  '), fprintf('%.5f rad.*10^-2\n', DQ(12,1)*100)
 