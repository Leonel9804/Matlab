function y = chromakey(I,Ip)
%% Transformaci�n de las imagenes
if ischar(I)
    I=imread(I);
end

if ischar(Ip)
    Ip=imread(Ip);
end

w=size(I,1);%Filas
z=size(I,2);%Columnas
Ip=imresize(Ip,[w z]);%Redimensionar el tama�o de la imagen paisaje
It=Component_Transformation(I,'FI');%Transformamos
Iy=uint8(It(:,:,1));%Almacenamos luminosidad
Ic=mat2gray(I(:,:,2)-Iy);%Modificaci�n color**
%imshow(Ic);
%Ih=hist(Ic(:),256);
%x=0:255;
%figure; plot(x,Ih);
umbral1=30/255;
mask1=Ic<umbral1;
%figure; imshow(mask1);
final=zeros(size(I));
final(:,:,1)=uint8(I(:,:,1)).*uint8(mask1) + uint8(Ip(:,:,1)).*(1-uint8(mask1));
final(:,:,2)=uint8(I(:,:,2)).*uint8(mask1) + uint8(Ip(:,:,2)).*(1-uint8(mask1));
final(:,:,3)=uint8(I(:,:,3)).*uint8(mask1) + uint8(Ip(:,:,3)).*(1-uint8(mask1));
y=uint8(final);
end