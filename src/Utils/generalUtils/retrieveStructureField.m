function resultArray = retrieveStructureField(structure, field)

[~, lengthStructure] = size(structure);

resultArray = cell(lengthStructure, 1);
for i = 1 : lengthStructure 
    resultArray{i} = structure(i).(field);
end