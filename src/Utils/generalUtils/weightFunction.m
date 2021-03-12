function weightedArray = weightFunction(lengthNum)

numbers = 1 : lengthNum;

shift = 1;
slope = 2.5/lengthNum;
weightedArray = zeros(1, lengthNum);
for i = numbers
    weightedArray(i) = shift - exp(-slope*i);
    shift = shift - weightedArray(i);
end
rest =  (1 - sum(weightedArray));
increment = rest / lengthNum;
weightedArray = weightedArray + increment;




end
