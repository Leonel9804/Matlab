function CT_Image = Component_Transformation(Image_rgb,option)
if nargin ~= 2
    CT_Image = 'E';
    disp('Warning: Two Arguments are necessary');
    return;
end

if ischar(Image_rgb)
    X=imread (Image_rgb);
else
    X=Image_rgb;
end
CT_Image=zeros(size(X));
X = double(X);
if strcmp(option, 'FI')
    CT_Image(:,:,1)  = 0.299*X(:,:,1) + 0.5870*X(:,:,2) + 0.114*X(:,:,3);
    CT_Image(:,:,2)  = 0.5*X(:,:,3) - 0.16875*X(:,:,1)- 0.33126*X(:,:,2);
    CT_Image(:,:,3)  = 0.5*X(:,:,1) - 0.41869*X(:,:,2) - 0.08131*X(:,:,3);
elseif strcmp(option, 'II')
    CT_Image(:,:,1)  = X(:,:,1) + 1.402*X(:,:,3);
    CT_Image(:,:,2)  = X(:,:,1) - 0.34413*X(:,:,2)- 0.71414*X(:,:,3);
    CT_Image(:,:,3)  = X(:,:,1) + 1.772*X(:,:,2);

elseif strcmp(option, 'FR')
    CT_Image(:,:,1)  = 0.25*X(:,:,1) + 0.5*X(:,:,2) + 0.25*X(:,:,3);
    CT_Image(:,:,2)  = X(:,:,3) - X(:,:,2);
    CT_Image(:,:,3)  = X(:,:,1) - X(:,:,2);

elseif strcmp(option, 'IR')
    CT_Image(:,:,2)  = X(:,:,1) - 0.25*X(:,:,2)- 0.25*X(:,:,3);
    CT_Image(:,:,1)  = X(:,:,3) + CT_Image(:,:,2);
    CT_Image(:,:,3)  = X(:,:,2) + CT_Image(:,:,2);
else
    disp('Warning: The requested option is not supported by Component_Transformation');
    return
end