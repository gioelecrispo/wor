function [] = ZhangSkel_2(imgpath)

img = imread(imgpath);
img(img == 255) = 1;
img2 = img;
img2(img == 1) = 0;
img2(img == 0) = 1;
s = Skeleton_M(img2);
s2 = s;
s2(s == 1) = 0;
s2(s == 0) = 1;
seeimage(s2)
imwrite(s2, [imgpath(1:end-7) 'skel.png']);

end