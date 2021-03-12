function drawResults(image, clusters, unfolder, data, options, results)



logger = getLogger(options);
logger.info('--> Drawing Results...');

if options.plot
    drawings = [];
    [lengthUnfoldedArray, ~] = size(unfolder.unfoldedArray);
    drawingSpeed = round(lengthUnfoldedArray*0.002); if drawingSpeed == 0; drawingSpeed = 1; end
    if options.computeResults
        drawings = [drawings, drawTrajectory_dynamic_withMeasures(image, clusters, unfolder, data, options, results, drawingSpeed, 1)];
        drawings = [drawings, drawOnlineAndRecoveredTrajectory(image.bw, data.online8conn, unfolder, results)];
    else 
        drawings = [drawings, drawTrajectory_dynamic(image.bw, unfolder.unfoldedArray(:,2), unfolder.unfoldedArray(:,1), drawingSpeed, 1)];
    end
    drawings = [drawings, drawQuiverPlot_colored(unfolder)];
end



logger.info('*** END ELABORATION ***');

end