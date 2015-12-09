function [panorama] = image_stitch(img1, img2, f1,f2, H)
    boundary = zeros(3,4);
    boundary(:,1) = H\[1;1;1];
    boundary(1:2,1) = round([ boundary(1,1)/boundary(3,1) ; boundary(2,1)/boundary(3,1) ]);
    boundary(:,2) = H\[1;size(img2,1);1];
    boundary(1:2,2) = round([ boundary(1,2)/boundary(3,2) ; boundary(2,2)/boundary(3,2) ]);
    boundary(:,3) = H\[size(img2,2);1;1];
    boundary(1:2,3) = round([ boundary(1,3)/boundary(3,3) ; boundary(2,3)/boundary(3,3) ]);
    boundary(:,4) = H\[size(img2,2);size(img2,1);1];
    boundary(1:2,4) = round([ boundary(1,4)/boundary(3,4) ; boundary(2,4)/boundary(3,4) ]);
%     
%     basePt = H\[f2(:,1);1];
%     basePt = round([basePt(1)/basePt(3);basePt(2)/basePt(3)]);
%     offset = boundary(1:2,1)+[0;3]; % basePt-f2(:,1);

    % Panorama size and offset of the left image
    cw = max([1 size(img1,2) boundary(1,1) boundary(1,2) boundary(1,3) boundary(1,4)]) - min([1 size(img1,2) boundary(1,1) boundary(1,2) boundary(1,3) boundary(1,4)]) + 1;
    ch = max([1 size(img1,1) boundary(2,1) boundary(2,2) boundary(2,3) boundary(2,4)]) - min([1 size(img1,1) boundary(2,1) boundary(2,2) boundary(2,3) boundary(2,4)]) + 1;
    off = [ 1 - min([1 size(img1,2) boundary(1,1) boundary(1,2) boundary(1,3) boundary(1,4)]) + 1 ; 1 - min([1 size(img1,1) boundary(2,1) boundary(2,2) boundary(2,3) boundary(2,4)]) + 1 ];

    warp_img1 = uint8(zeros([ch cw 3]));
    warp_img2 = uint8(zeros([ch cw 3]));

    warp_img1(off(2):(off(2)+size(img1,1)-1),off(1):(off(1)+size(img1,2)-1),:) = img1;
    tmp_warp_img2 = image_transform(img2,H);
    warp_img2(1:size(tmp_warp_img2,1),(end-size(tmp_warp_img2,2)+1):end,:) = tmp_warp_img2;
%     warp_img2(offset(2):(offset(2)+size(tmp_warp_img2,1)-1),offset(1):(offset(1)+size(tmp_warp_img2,2)-1),:) = tmp_warp_img2;

    blender = vision.AlphaBlender('Operation', 'Binary mask', 'MaskSource', 'Input port');
    panorama = step(blender, warp_img1, warp_img2, warp_img2(:,:,1));
end