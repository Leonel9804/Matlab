t=pi/2;    %Valor de theta 
A=0;       %Valor de phi
L=0.5;     %longitud de la antena principal 
He1=0.235;   %esta cantidad es de nuestra antena principal 
He2= 0.5253;  %esta cantidad es de antena parasito 
He3=-0.235;  %limite inferior de la antena principal 
He4=-0.5253;  %Limite inferior de la antena parasito
de= 0.4242640687;    %la distancia de separacio 
ae= 0.4242640687; %radio transveral de los dipolos 

Z12 = @(x) (60/(sin(2*pi*He1).*sin(2*pi*He2))).*sin(2*pi*(He1-abs(x))).*((sin(2*pi*(((x-He2).^2+(de).^2).^0.5)))./((((x-He2).^2+(de).^2).^0.5))-cos(2*pi*He2).*(sin(2*pi*(((x).^2+(de).^2).^0.5)))./((((x).^2+(de).^2).^0.5)));
q12 = integral(Z12,He3,He1);
 
Z12i = @(x) (60/(sin(2*pi*He1).*sin(2*pi*He2))).*sin(2*pi*(He1-abs(x))).*((cos(2*pi*(((x-He2).^2+(de).^2).^0.5)))./((((x-He2).^2+(de).^2).^0.5))-cos(2*pi*He2).*(cos(2*pi*(((x).^2+(de).^2).^0.5)))./((((x).^2+(de).^2).^0.5)));
q12i= integral (Z12i,He3,He1)*1i;

Z11 = @(x) (60/(sin(2*pi*He1).*sin(2*pi*He1))).*sin(2*pi*(He1-abs(x))).*((sin(2*pi*(((x-He1).^2+(ae).^2).^0.5)))./((((x-He1).^2+(ae).^2).^0.5))-cos(2*pi*He1).*(sin(2*pi*(((x).^2+(ae).^2).^0.5)))./((((x).^2+(ae).^2).^0.5)));
q11= integral(Z11,He3,He1);

Z11i = @(x) (60/(sin(2*pi*He1).*sin(2*pi*He1))).*sin(2*pi*(He1-abs(x))).*((cos(2*pi*(((x-He1).^2+(ae).^2).^0.5)))./((((x-He1).^2+(ae).^2).^0.5))-cos(2*pi*He1).*(cos(2*pi*(((x).^2+(ae).^2).^0.5)))./((((x).^2+(ae).^2).^0.5)));
q11i = integral(Z11i,He3,He1)*1i;

Z22 = @(x) (60/(sin(2*pi*He2).*sin(2*pi*He2))).*sin(2*pi*(He2-abs(x))).*((sin(2*pi*(((x-He2).^2+(ae).^2).^0.5)))./((((x-He2).^2+(ae).^2).^0.5))-cos(2*pi*He2).*(sin(2*pi*(((x).^2+(ae).^2).^0.5)))./((((x).^2+(ae).^2).^0.5)));
q22= integral(Z22,He4,He2);

Z22i = @(x) (60/(sin(2*pi*He2).*sin(2*pi*He2))).*sin(2*pi*(He2-abs(x))).*((cos(2*pi*(((x-He2).^2+(ae).^2).^0.5)))./((((x-He2).^2+(ae).^2).^0.5))-cos(2*pi*He2).*(cos(2*pi*(((x).^2+(ae).^2).^0.5)))./((((x).^2+(ae).^2).^0.5)));
q22i= integral(Z22i,He4,He2)*1i;

z12=q12+q12i;
z11=q11+q11i
z22=q22+q22i;

%crear matriz para calcular la matriz inversa de la impedancia 

a=[z11 z12 ; z12 z22];
Y=inv(a);
V=[0 ; 8];
%matriz resultante en rectangular
Z= Y*V;
I1=(2.012468772880194e-03 + 8.946043026760503e-02i); %Debemos sacar los valores que nos dieron en las matrices anteriores;
I2=(7.993154349507284e-02 - 1.333600852730311e-01i);%igual est
g=(cos(L*pi.*cos(t))-cos(L*pi))/(sin(L*pi).*sin(t));
x=exp(-0.2*pi*1i*sin(t)*cos(A));
u=(cos(t.*cos(t))/(sin(t)));

b=(I1).*(g).*(x)+(I2).*(u);

s=60*abs(b);