function branchPointsMatrix = getBranchPointsMatrix(image)

branchPointsMatrix = image.pointsMatrix(:,:,PointClassificationType.BRANCH_POINT);
branchPointsMatrix(isnan(branchPointsMatrix)) = 0;

end