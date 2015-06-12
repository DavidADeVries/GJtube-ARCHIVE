function [ file ] = performUndo( file )
%performUndo actually what it says on the tin

cacheLocation = file.undoCache.cacheLocation;

numCacheEntries = length(file.undoCache.cacheEntries);

cacheLocation = cacheLocation + 1; %go back in time

if cacheLocation > numCacheEntries
    cacheLocation = numCacheEntries;
end

if cacheLocation > file.undoCache.cacheSize
    cacheLocation = file.cacheLocation;
end

file.undoCache.cacheLocation = cacheLocation;

cacheEntry = file.undoCache.cacheEntries(cacheLocation);

file = cacheEntry.restoreToFile(file);


end

