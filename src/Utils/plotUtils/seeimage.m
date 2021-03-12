function [] = seeimage(image)

bw = image.bw;

figure('units','normalized','outerposition',[0 0 1 1]), 
imagesc(bw),
colormap(gray),


end