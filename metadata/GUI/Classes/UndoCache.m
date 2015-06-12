classdef UndoCache
    %UndoCache stores the information and cache entries to run the undo
    %functionality
    
    properties
        cacheSize = 30; %max number of cache copies
        cacheLocation = 0; % index in which the undo data is store, larger number = back in time (if redo is pressed, go to cacheLocation - 1)
        cacheEntries = CacheEntry.empty; %array of structs that hold the needed information 
    end
    
    methods
        function undoCache = UndoCache(file)
            undoCache.cacheLocation = 1;
            undoCache.cacheEntries = CacheEntry(file); %first entry is how the file starts out
        end
        
        function numEntries = numCacheEntries(undoCache)
            numEntries = length(undoCache.cacheEntries);
        end
    end
    
end

