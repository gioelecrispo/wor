function unfolder = initializeUnfolder(image)

unfolder.unfoldedArray = [];
unfolder.starters = [];
unfolder.enders = [];
unfolder.components = [];
unfolder.unfolderCounter = 1; 
unfolder.tracedMatrix = zeros(image.dimensions);

end