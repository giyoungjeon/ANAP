function inliers = ransac(f1,f2,iter)
    f1 = [f1(1:2,:);ones(1,size(f1,2))];
    f2 = [f2(1:2,:);ones(1,size(f2,2))];
    
    for t = 1:iter
      % estimate homograpyh
      subset = vl_colsubset(1:size(f1,2), 4) ;
      A = [] ;
      for i = subset
        A = cat(1, A, kron(f1(:,i)', vl_hat(f2(:,i)))) ;
      end
      [U,S,V] = svd(A) ;
      H{t} = reshape(V(:,9),3,3) ;

      % score homography
      X2_ = H{t} * f1 ;
      du = X2_(1,:)./X2_(3,:) - f2(1,:)./f2(3,:) ;
      dv = X2_(2,:)./X2_(3,:) - f2(2,:)./f2(3,:) ;
      inliers{t} = (du.*du + dv.*dv) < 5*5 ;
      score(t) = sum(inliers{t}) ;
    end

    [score, best] = max(score) ;
    H = H{best} ;
    inliers = inliers{best} ;
end