for n=1:651
    k=num2str(n);
    if n<10
        num=['0' '0' '0' k]; 
    end
    if n>9 && n<100
        num=['0' '0' k]; 
    end
    if n>99
        num=['0' k];
    end
    fondo=['fondo2\Oceano' num '.png'];
    Imagen=['images2\frame_' num '.png'];
    An=['anag' num '.png'];
    Ip=imread(fondo);
    I=imread(Imagen);
    map = mapa(I,Ip);
    y = chromakey(I,Ip);
    [Left, Right] = dibr(y, map);
    Anaglifa = stereoAnaglyph(Left,Right);
    imwrite(Anaglifa, An);
end