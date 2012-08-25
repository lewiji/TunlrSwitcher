//
//  tunlrSwitcherAppDelegate.m
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

#import "tunlrSwitcherAppDelegate.h"
#import "StatusItemView.h"

@implementation tunlrSwitcherAppDelegate

bool firstRun = YES;

NSString *primaryDNS;
NSString *secondaryDNS;
StatusItemView *statusItemView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Register preference defaults for DNS servers
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"prefDefaults" ofType:@"plist"];
    NSDictionary *plistDefaults = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *appDefaults = plistDefaults;
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

-(bool)executeShellScriptFromResourcesFolderAndReturnSuccess:(NSString *) scriptName {
    /* Retrieve DNS servers from user defaults */
    primaryDNS = [[NSUserDefaults standardUserDefaults] stringForKey:@"PrimaryDNSServer"];
    secondaryDNS = [[NSUserDefaults standardUserDefaults] stringForKey:@"SecondaryDNSServer"];
    
    /* Load path to script */
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:scriptName ofType:nil inDirectory:@"Resources"];
    /* Create AppleScript to run script */
    NSMutableString *scriptSource = [NSMutableString stringWithFormat:@"do shell script \"%@ %@ %@ %d\" with administrator privileges", scriptPath, primaryDNS, secondaryDNS, firstRun];
    /* Init applescript and execute, returns false if error occurs */
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:scriptSource];
    NSDictionary *scriptError = [[NSDictionary alloc] init];
    firstRun = NO; /* The first switch we do always switches to the specified DNS servers (for consistency with menubar icon state) */
    return [appleScript executeAndReturnError:&scriptError];
}

-(void)awakeFromNib{

    /* Create menubar item */
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    statusItemView = [[StatusItemView alloc] init];
    statusItemView.statusItem = statusItem;
    [statusItemView setMenu:statusMenu];
    [statusItemView setToolTip:NSLocalizedString(@"TunlrSwitcher",
                                                 @"Status Item Tooltip")];
    [statusItem setView:statusItemView];
}

-(IBAction)switch:(id)sender {
    /* Execute switch script and switch image; if switching failed pop up an error */
    if ([self executeShellScriptFromResourcesFolderAndReturnSuccess:@"switch.sh"] ) {
        [statusItemView toggleImage];
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Could not set DNS."];
        [alert runModal];
    }
}

-(IBAction)openPrefsPanel:(id)sender {
    if (! prefsWindow ) {
		prefsWindow	= [[NSWindowController alloc] initWithWindow:[self window]];
	}
    
    primaryDNS = [[NSUserDefaults standardUserDefaults] stringForKey:@"PrimaryDNSServer"];
    secondaryDNS = [[NSUserDefaults standardUserDefaults] stringForKey:@"SecondaryDNSServer"];
    
    [[self primaryDNSField] setStringValue: primaryDNS];
    [[self secondaryDNSField] setStringValue: secondaryDNS];
	[prefsWindow showWindow:self];
    [[self window] makeKeyWindow];
    [[self window] orderFrontRegardless];
}

-(IBAction)savePrefs:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[[self primaryDNSField] stringValue] forKey:@"PrimaryDNSServer"];
    [[NSUserDefaults standardUserDefaults] setObject:[[self secondaryDNSField] stringValue] forKey:@"SecondaryDNSServer"];
    [prefsWindow close];
}

@end
