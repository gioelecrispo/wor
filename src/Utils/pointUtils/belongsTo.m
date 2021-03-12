function [bool, i] = belongsTo(point, set, first)

bool = false;

container = [];
containerIndexes = [];

[setLength, ~] = size(set);
for i = 1 : setLength 
    if isTheSamePoint(point, set(i,:))
        container = [container; point];
        containerIndexes = [containerIndexes; i];
        if(first == true)
            break; 
        end
    end
end

if ~isempty(containerIndexes)
    bool = true;
    i = containerIndexes;
end

end