function [ file ] = performRedo( file )
%performUndo actually what it says on the tin


cacheLocation = file.undoCache.cacheLocation;

cacheLocation = cacheLocation - 1; %go forward in time

if  cacheLocation == 0
    cacheLocation = 1;
end

file.undoCache.cacheLocation = cacheLocation;

cacheEntry = file.undoCache.cacheEntries(cacheLocation);

file = cacheEntry.restoreToFile(file);


end

