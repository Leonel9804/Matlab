function [Left, Right] = dibr(color, depth)

if ischar(color)    %Is the image a string or a array?
    color=imread(color);
else
    color=uint8(color);
end
rows = size(color,1);
cols = size(color,2);
[Y1,U1,V1]=rgb2yuv(color(:,:,1),color(:,:,2),color(:,:,3),'YUV420_8');
Y = cell(1,1);
U = cell(1,1);
V = cell(1,1);
Y{1,1}=double(Y1);
U{1,1}=double(U1);
V{1,1}=double(V1);

if ischar(depth)    %Is the image a string or a array?
    depth=imread(depth);
else
    depth=uint8(depth);
end

Y2 = cell(1,1);
depth=single(depth(:,:,1));
if max(depth(:))>8
    depth=single((depth - min(depth(:)))./(max(depth(:))-min(depth(:))));
    depth=depth.*8;
end
Y2{1,1}=uint8(depth);

for nf = 1:size(Y,2)
    L{nf}.luma = zeros(rows,cols);
    L{nf}.chroma1 = zeros(rows/2, cols/2);
    L{nf}.chroma2 = zeros(rows/2, cols/2);
    
    R{nf}.luma = zeros(rows,cols);
    R{nf}.chroma1 = zeros(rows/2, cols/2);
    R{nf}.chroma2 = zeros(rows/2, cols/2);
end

mask.luma = zeros(rows,cols);
mask.chroma1 = zeros(rows/2, cols/2);

% This value is the half of the maximum shift
% Maximum shift comes at depth = 0;
S = 58;

N = 256; %Number of depth planes
%depth = 0;
shiftx = zeros(1,N);

% Calculate the shift table to lookup
for i = 1:N
    shiftx(1,i) = find_shiftMC3(i-1, cols);
end


for nf=1:size(Y,2)
    
    D = Y2{nf};
    
    % Left Image
    
    % Luma Components
    for i = 1:rows
        %Note the order of rendering
        for j = cols:-1:1
            shift = shiftx(1,(D(i,j)+1));
            
            if(j-shift+S<cols)
                L{nf}.luma(i,j+S-shift)= Y{nf}(i,j);
                mask.luma(i,j+S-shift) = 1;
            end
        end
        
        % Filling of disocclusions with Background Pixel Extrapolation
        for j = 1:cols
            if(mask.luma(i,j)==0)
                if(j-7<1)
                    L{nf}.luma(i,j) = Y{nf}(i,j);
                else
                    L{nf}.luma(i,j) = sum(L{nf}.luma(i,j-7:j-4))/4;
                end
            end
        end
    end
    
    % Chroma Components
    for i = 1:rows/2
        for j = cols/2:-1:1
            shift = shiftx(1,(D(i*2,j*2)+1)); %P.S. It is not cols/2 here
            
            if(j-ceil(shift/2)+S/2<cols/2)
                L{nf}.chroma1(i,j-ceil(shift/2)+S/2)= U{nf}(i,j);
                L{nf}.chroma2(i,j-ceil(shift/2)+S/2)= V{nf}(i,j);
                mask.chroma1(i,j-ceil(shift/2)+S/2) = 1;
            end
        end
        
        % Filling of disocclusions with Background Pixel Extrapolation
        for j = 1:cols/2
            if(mask.chroma1(i,j)==0)
                if(j-2<1)
                    L{nf}.chroma1(i,j) = U{nf}(i,j);
                    L{nf}.chroma2(i,j) = V{nf}(i,j);
                else
                    L{nf}.chroma1(i,j) = sum(L{nf}.chroma1(i,j-2:j-1))/2;
                    L{nf}.chroma2(i,j) = sum(L{nf}.chroma2(i,j-2:j-1))/2;
                end
            end
        end
    end
    
    mask.luma = zeros(rows,cols);
    mask.chroma1 = zeros(rows/2, cols/2);
    
    % Right Image
    for i = 1:rows
        for j = 1:cols
            shift = shiftx(1,(D(i,j)+1));
            
            if(j+shift-S>1)
                R{nf}.luma(i,j+shift-S)= Y{nf}(i,j);
                mask.luma(i,j+shift-S) = 1;
            end
        end
        
        % Filling of disocclusions with Background Pixel Extrapolation
        for j=cols:-1:1
            if(mask.luma(i,j) == 0)
                if(j+7>cols)
                    R{nf}.luma(i,j) = Y{nf}(i,j);
                else
                    R{nf}.luma(i,j) = sum(R{nf}.luma(i,j+4:j+7))/4;
                end
            end
        end
    end
    
    for i = 1:rows/2
        for j = 1:cols/2
            shift = shiftx(1,(D(i*2,j*2)+1));
            
            if(j+ceil(shift/2)-S/2>1)
                R{nf}.chroma1(i,j+ceil(shift/2)-S/2)= U{nf}(i,j);
                R{nf}.chroma2(i,j+ceil(shift/2)-S/2)= V{nf}(i,j);
                
                mask.chroma1(i,j+ceil(shift/2)-S/2) = 1;
            end
        end
        
        % Filling of disocclusions with Background Pixel Extrapolation
        for j=cols/2:-1:1
            if(mask.chroma1(i,j) == 0)
                if(j+2>cols/2)
                    R{nf}.chroma1(i,j) = U{nf}(i,j);
                    R{nf}.chroma2(i,j) = V{nf}(i,j);
                else
                    R{nf}.chroma1(i,j) = sum(R{nf}.chroma1(i,j+1:j+2))/2;
                    R{nf}.chroma2(i,j) = sum(R{nf}.chroma2(i,j+1:j+2))/2;
                end
            end
        end
    end
    
    
end

Left=yuv2rgb(L{1}.luma,L{1}.chroma1,L{1}.chroma2,'YUV420_8');
Right=yuv2rgb(R{1}.luma,R{1}.chroma1,R{1}.chroma2,'YUV420_8');
