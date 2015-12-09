function [H_j] = local_homography(f1,f2)
% Estimate the local homograpohy
% 
% The function to calculate the local homography of target image (I2)
% to the reference image (I1). Accoding to the matching specific points
% (f1,f2), this function calculates the estimation of the homography.
% It uses Weighted Singular Value Decomposition to the estimation.
% 
% Input Parameters:
%               f1, f2:     matching specific points of each images. (2XN)
% 
% Returns:
%       H:      a cell of local homographies size of 3X3
% 
% Usage: H = local_homography(f1,f2)
% 
% Written by Giyoung Jeon
% Statistical Artificial Intelligence Lab at UNIST
% v1.0 Dec., 6th, 2015

    O = [0 0 0]';
    x = f1(1,:); y = f1(2,:); x_ = f2(1,:); y_ = f2(2,:);
    p = [x; y; ones(size(x))];
    H = cells(1,size(p,2);
    for jdx=1:size(p,2)
        p_j = p(:,jdx);
        d = p-p_j(:,ones(size(p,2),1));
        W_j = exp(arrayfun(@(idx) -norm(d(:,idx)), 1:size(d,2)));
        W_j = reshape(repmat(W_j,2,1),1,2*size(W_j,2));
        W_j = diag(W_j);
        A = zeros(2*size(x,2), 9);
        for idx=1:size(x,2)
            A(2*idx-1,:) = [p(:,idx)' O' x_(idx)*p(:,idx)'];
            A(2*idx,:) = [O' -p(:,idx)' y_(idx)*p(:,idx)'];
        end
        [~, ~, v] = svd(W_j*A);
        H{jdx} = reshape(v(:,end),[3 3]);
    end
end
