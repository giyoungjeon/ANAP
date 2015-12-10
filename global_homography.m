function [H,A] = global_homography(f1, f2)

    O = [0 0 0];
    x = f1(1,:); 
    y = f1(2,:); 
    x_ = f2(1,:);     
    y_ = f2(2,:);
    
    p = [x; y; ones(size(x))];
    A = [];
    for idx=1:size(x,2)
        A = [A; p(:,idx)'   O           -x_(idx)*p(:,idx)';
                O           -p(:,idx)'  y_(idx)*p(:,idx)'];
    end
    [u, s, v] = svd(A,0);
    H = reshape(v(:,end),[3,3])';
end