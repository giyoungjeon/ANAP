function [H] = global_homography(f1, f2)
% Estimate the global homograpohy
% 
% The function to calculate the global homography of target image (I2)
% to the reference image (I1). Accoding to the matching specific points
% (f1,f2), this function calculates the estimation of the homography.
% 
% Input Parameters:
%               f1, f2:     matching specific points of each images. (2XN)
% 
% Returns:
%       H:      global homography size of 3X3
% 
% Usage: H = global_homography(f1,f2)
% 
% Written by Giyoung Jeon
% Statistical Artificial Intelligence Lab at UNIST
% v1.0 Nov., 31st, 2015

    O = [0 0 0];
    x_ = f1(1,:); y_ = f1(2,:); x = f2(1,:); y = f2(2,:);
    p = [x; y; ones(size(x))];
    A = [];
    for idx=1:size(x,2)
        A = [A; p(:,idx)'   O           x(idx)*p(:,idx)';
                O           p(:,idx)'  -y_(idx)*p(:,idx)'];
    end
    [u, s, v] = svd(A,0);
    H = reshape(v(:,end),3,3)';
end