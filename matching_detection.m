run('../vlfeat-0.9.20/toolbox/vl_setup')

Ia = imread('../Stitch_Dataset/974-1.jpg');
Ib = imread('../Stitch_Dataset/975-1.jpg');

[fa, da] = vl_sift(single(rgb2gray(Ia))) ;
[fb, db] = vl_sift(single(rgb2gray(Ib))) ;
[matches, scores] = vl_ubcmatch(da, db) ;

[a,idx]=sort(scores);
idx = idx(1:100);
subplot(1,2,1);
image(Ia);
vl_plotframe(fa(:,matches(1,idx)));
subplot(1,2,2);
image(Ib);
vl_plotframe(fb(:,matches(2,idx)));

%  Global Homography
H = global_homography(fa(:,matches(1,idx)), fb(:,matches(1,idx)));
