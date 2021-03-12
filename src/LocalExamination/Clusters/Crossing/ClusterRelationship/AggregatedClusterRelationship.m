classdef (Abstract) AggregatedClusterRelationship < ClusterRelationship & handle & matlab.mixin.Heterogeneous
    % AGGREGATED: si parla di "aggregazione" quando un insieme di cluster
    %             più semplici formano un cluster più complesso (nella
    %             stessa posizione).
    %
    %                   |                  |
    %                 - o -     ==>        o       +       - o -
    %                  / \                / \
    %               AGGREGATED          CHILD_1           CHILD_2
    %%%%%
    properties
        % children: array di cluster ID di tipo SingleClusterRelationship,
        %           cioè di cluster (più semplici) che formano il cluster
        %           aggregato.
        children
        % childrenIndexes: cell array che contiene il mapping tra gli indici
        %                  degli anchorBP del cluster aggregato e dei suoi
        %                  figli.
        %                  Ad esempio, immaginiamo di avere un cluster di
        %                  rango 5. Quest'ultimo avrà 5 anchorBP, con indici
        %                  [1, 2, 3, 4, 5]. Immaginiamo, ora che un suo
        %                  figlio venga  generato dagli indici [2, 4, 5].
        %                  Dal punto di vista del cluster aggregato il
        %                  figlio ha indici [2, 4, 5].
        %                  Dal punto di vista del cluster figlio gli indici
        %                  sono [1, 2, 3].
        childrenIndexes
    end
    methods
        function obj = AggregatedClusterRelationship()
            obj = obj@ClusterRelationship;
            obj.children = [];
            obj.childrenIndexes = [];
        end
        function [nextIndex, path] = crossCluster(obj, index, clusters)
            [nextIndex, path] = crossCluster@ClusterRelationship(obj, index, clusters);
        end
    end
end