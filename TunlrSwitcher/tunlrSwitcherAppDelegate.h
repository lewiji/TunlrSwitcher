//
//  tunlrSwitcherAppDelegate.h
//  TunlrSwitcher
//
//  Created by Lewis Pollard on 22/08/2012.
//  Copyright (c) 2012 Lewis Pollard. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface tunlrSwitcherAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindowController *prefsWindow;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
}
-(IBAction)switch:(id)sender;
-(IBAction)openPrefsPanel:(id)sender;
-(IBAction)savePrefs:(id)sender;
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *primaryDNSField;
@property (assign) IBOutlet NSTextField *secondaryDNSField;

@end
