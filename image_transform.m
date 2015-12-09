function [new_img] = image_transform(img, H)

if isa(img,'uint8')
    img = double(img);
end
[rows, cols, ~] = size(img);

region = [1 rows 1 cols];
max_size = max([rows cols]);

img = img/255;
[r] = transformImage(img(:,:,1), H, region, max_size);
[g] = transformImage(img(:,:,2), H, region, max_size);
[b] = transformImage(img(:,:,3), H, region, max_size);

new_img = repmat(uint8(0),[size(r),3]);
new_img(:,:,1) = uint8(round(r*255));
new_img(:,:,2) = uint8(round(g*255));
new_img(:,:,3) = uint8(round(b*255));
end

%------------------------------------------------------------

% The internal function that does all the work

function newim = transformImage(img, H, region, sze)
[rows, cols] = size(img);
% Find where corners go - this sets the bounds on the final image
B = bounds(H,region);
nrows = B(2) - B(1);
ncols = B(4) - B(3);

Hinv = inv(H);

% Set things up for the image transformation.
newim = zeros(nrows,ncols);
[xi,yi] = meshgrid(1:ncols,1:nrows);
sxy = homoTrans(Hinv, [xi(:)'+B(3) ; yi(:)'+B(1) ; ones(1,ncols*nrows)]);
xi = reshape(sxy(1,:),nrows,ncols);
yi = reshape(sxy(2,:),nrows,ncols);

[x,y] = meshgrid(1:cols,1:rows);
x = x+region(3)-1; % Offset x and y relative to region origin.
y = y+region(1)-1; 
newim = interp2(x,y,double(img),xi,yi); % Interpolate values from source image
end
function B = bounds(T, R)

P = [R(3) R(4) R(4) R(3)      % homogeneous coords of region corners
     R(1) R(1) R(2) R(2)
      1    1    1    1   ];
     
PT = round(homoTrans(T,P)); 

B = [min(PT(2,:)) max(PT(2,:)) min(PT(1,:)) max(PT(1,:))];
end
function t = homoTrans(P,v)
    
    [dim,npts] = size(v);
    
    if ~all(size(P)==dim)
	error('Transformation matrix and point dimensions do not match');
    end

    t = P\v;  % Transform

    for r = 1:dim-1     %  Now normalise    
	t(r,:) = t(r,:)./t(end,:);
    end
    
    t(end,:) = ones(1,npts);
    
    
end