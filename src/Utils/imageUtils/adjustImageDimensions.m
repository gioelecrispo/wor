function bwreal = adjustImageDimensions(bwreal)

[rows, cols] = size(bwreal);
offsetSalSkel = 43;
raux = ones(rows, offsetSalSkel);
caux = ones(offsetSalSkel, cols + offsetSalSkel*2);

bwreal = [caux; raux bwreal raux; caux];

end