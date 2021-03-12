function commons = findCommonNeighbors(neighbors_px1, neighbors_px2)

commons = [];
for i = 1 : length(neighbors_px1)
    for j = 1 : length(neighbors_px2)
        if isTheSamePoint(neighbors_px1(i,:), neighbors_px2(j,:))
            commons = [commons; neighbors_px1(i,:)];
        end
    end
end

end