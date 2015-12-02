function [H_j] = local_homography(f1,f2)

    for j = 1:size(f1,2)
        H_j(j) = global_homography(f1(:,j),f2(:,j))
    end
end