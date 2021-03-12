function direction = getDirectionBetweenAdiacentClusterPoint(cluster, i1, i2)
% i1 e i2 sono due indici indicanti i punti del cluster alle posizioni i1 e
% i2 rispettivamente.
point1 = cluster(i1,:);
point2 = cluster(i2,:);

direction = point2 - point1;

end