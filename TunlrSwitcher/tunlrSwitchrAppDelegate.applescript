--
--  tunlrSwitchrAppDelegate.applescript
--  TunlrSwitchr
--
--  Created by Lewis Pollard on 22/08/2012.
--  Copyright (c) 2012 Lewis Pollard. All rights reserved.
--

script tunlrSwitchrAppDelegate
	property parent : class "NSObject"
    property statusItem : class "NSStatusItem"
    property NSStatusBar : class "NSStatusBar"
    property NSVariableStatusItemLength : class "NSVariableStatusItemLength"
    
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened 
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    
    on tunlrSwitch_(object)
        do shell script "./switch.sh" with administrator privileges
    end tunlrSwitch_
    
    on awakeFromNib_()
        set aSystemStatusBar to NSStatusBar's systemStatusBar
        
        set statusItem to aSystemStatusBar's statusItemWithLength_(NSVariableStatusItemLength)
        statusItem's retain()
        statusItem's setTitle_("tunlrSwitchr")
        statusItem's setHighlightMode_(true)
    end awakeFromNib_
	
end script