function i = findPositionInsideCluster(point, cluster)

for i = 1 : length(cluster)
    if isTheSamePoint(point, cluster(i,:))
        break;
    end
end

end