run('../vlfeat-0.9.20/toolbox/vl_setup')

Ia = imread('../Stitch_Dataset/974-1.jpg');
Ib = imread('../Stitch_Dataset/975-1.jpg');

%% Feature detection using SIFT and matching

[fa, da] = vl_sift(single(rgb2gray(Ia)),'PeakThresh', 0,'edgethresh',500) ;
[fb, db] = vl_sift(single(rgb2gray(Ib)),'PeakThresh', 0,'edgethresh',500) ;
[matches, scores] = vl_ubcmatch(da, db) ;
f1 = fa(:,matches(1,:));
f2 = fb(:,matches(1,:));

%% Remove outlier using RANSAC
M     = 500;  % Number of hypotheses for RANSAC.
thr   = 0.1;  % RANSAC threshold.

rng(0);
[ ~,res,~,~ ] = multigsSampling(100,[f1;f2],M,10);
con = sum(res<=thr);
[ ~, maxinx ] = max(con);
inliers = find(res(:,maxinx)<=thr);
%%  Global homography

H = global_homography(f1(:,inliers), f2(:,inliers));

%% Local homography