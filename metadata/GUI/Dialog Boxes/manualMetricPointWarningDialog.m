function [ cancelled ] = manualMetricPointWarningDialog()
% [ cancelled ] = manualMetricPointWarningDialog()
% warns user that since the tube is not segmented, the metric points will
% have to be manually selected. They cancel if they wish.
    
    cancelled = true;

    message = 'The GJ Tube needs to be segmented for automatic metric point selection to occur, therefore metric point selection will be performed manually. The measurements e and f will only be computed if the tube is segmented.';
    title = 'GJ Tube Not Segmented';
    
    ok = 'Continue';
    cancel = 'Cancel';
    
    default = ok;
    
    choice = questdlg(message, title, ok, cancel, default);
    
    switch choice
        case ok
            cancelled = false;
        case cancel
            cancelled = true;
    end
    
end

