function [] = skeletonize(filepath)
    %%% SALERNO's SKELETONIZATION 
    jarfile = ['"' pwd '\Skeleton\SalernoSkeletonization.jar' '"'];
    parameters = ['"' filepath '"'];
    command = ['java -jar ' jarfile ' ' parameters];
    [~, cmdout] = system(command)
end