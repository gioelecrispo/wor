function drawSignatureResults(image, clusters, unfolder, data, options, results)


if strcmpi(options.version, 'ALL')
    options.version = 'ESTNC';
    % - Drawing unfolded trace, components
    drawResults(image, clusters, unfolder.ESTNC, data, options, results.ESTNC);
    options.version = 'RSENC';
    % - Drawing unfolded trace, components
    drawResults(image, clusters, unfolder.RSENC, data, options, results.RSENC);
    options.version = 'RSEOC';
    % - Drawing unfolded trace, components
    drawResults(image, clusters, unfolder.RSEOC, data, options, results.RSEOC);
    options.version = 'ALL';
else
    % - Drawing unfolded trace, components
    drawResults(image, clusters, unfolder, data, options, results);
end

end