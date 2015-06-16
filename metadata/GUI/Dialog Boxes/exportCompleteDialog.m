function [ handle ] = exportCompleteDialog()
% [ handle ] = exportCompleteDialog()
% tells the user that the export is complete

message = 'Export successfully completed.';
icon = 'none';
title = 'Export Complete';

handle = msgbox(message, title, icon); %handle used for waiting


end

