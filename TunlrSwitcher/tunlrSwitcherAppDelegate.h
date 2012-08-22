//
//  tunlrSwitcherAppDelegate.h
//  TunlrSwitcher
//
//  Created by Lewis Pollard on 22/08/2012.
//  Copyright (c) 2012 Lewis Pollard. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface tunlrSwitcherAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
}
-(IBAction)switch:(id)sender;
@property (assign) IBOutlet NSWindow *window;

@end
