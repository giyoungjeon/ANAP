function [H] = local_homography(f1,A, Pjs)

    O = [0 0 0]';
    sigma = 8.5;
    x = f1(1,:); y = f1(2,:); x_ = Pjs(1,:); y_ = Pjs(2,:);
    p = [x; y; ones(size(x))];
    H = cell(1,size(Pjs,2));
    for jdx=1:size(p,2)
        p_j = p(:,jdx);
        d = p-p_j(:,ones(size(p,2),1));
        W_j = exp(arrayfun(@(idx) -norm(d(:,idx),2), 1:size(d,2)))./sigma^2;
        W_j = reshape(repmat(W_j,2,1),1,2*size(W_j,2));
        W_j = diag(W_j);
        [u, s, v] = svd(W_j*A);
        H{jdx} = reshape(v(:,end),[3 3]);
    end
end
