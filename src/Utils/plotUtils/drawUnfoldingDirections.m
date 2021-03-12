function drawUnfoldingDirections(image, unfolder, interval)

bw = image.bw;

unfoldedArray_X = unfolder.unfoldedArray(:,2);
unfoldedArray_Y = unfolder.unfoldedArray(:,1);

reducedUnfoldedArray = [unfoldedArray_X(1,:) unfoldedArray_Y(1,:); 
                       unfoldedArray_X(2:interval:end-1,:), unfoldedArray_Y(2:interval:end-1,:); 
                       unfoldedArray_X(end,:) unfoldedArray_Y(end,:)];


figure('units','normalized','outerposition',[0 0 1 1])
imagesc(bw), colormap(gray), drawnow, hold on

arrow(reducedUnfoldedArray(1:end-1,:),reducedUnfoldedArray(2:end,:), 'Color', 'r', 'Width', 0);
%for i = 1 : length(reducedUnfoldedArray(:,1))
%    plot(reducedUnfoldedArray(i,1), reducedUnfoldedArray(i,2), 'Color', 'r', 'Marker', '>');
%end
end