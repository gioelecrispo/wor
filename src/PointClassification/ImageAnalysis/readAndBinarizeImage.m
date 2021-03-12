function bw = readAndBinarizeImage(path)
% path is the path where the image is located.
%
% For the binarization, a threshold T = 0.5 in a scale from [0] to [1], ie
% T = 128 in a scale from [0] to [255] is more than enough to cover all
% possible cases, since we find only images that have values of
% pixel equal to 0 (BLACK) or 255 (WHITE).

skeleton = imread(path);
sksize = size(skeleton);
if length(sksize) > 2
    skeleton = rgb2gray(skeleton);
end
bw = imbinarize(skeleton, 0.5);
bw = 1 - bwmorph(1-bw, 'fill');

end