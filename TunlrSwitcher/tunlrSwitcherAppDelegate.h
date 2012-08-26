//
//  tunlrSwitcherAppDelegate.h
//  TunlrSwitcher
//
//  Created by Lewis Pollard on 22/08/2012.
//  Copyright (c) 2012 Lewis Pollard. All rights reserved
//  This file is part of TunlrSwitcher.
//
//  TunlrSwitcher is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  TunlrSwitcher is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

#import <Cocoa/Cocoa.h>

@interface tunlrSwitcherAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindowController *prefsWindow;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    IBOutlet NSWindow *window;
    IBOutlet NSTextField *primaryDNSField;
    IBOutlet NSTextField *secondaryDNSField;
}
-(IBAction)switch:(id)sender;
-(IBAction)openPrefsPanel:(id)sender;
-(IBAction)savePrefs:(id)sender;
@property (retain, nonatomic) IBOutlet NSWindow *window;
@property (retain, nonatomic) IBOutlet NSTextField *primaryDNSField;
@property (retain, nonatomic) IBOutlet NSTextField *secondaryDNSField;

@end
