function adjustedResults = adjustResults(results, version)

lengthResults = length(results);
for i = 1 : lengthResults
    res = results(i).(version);
    if isempty(res)
        res = emptyResult();
    end
    adjustedResults(i) = res;
end

end