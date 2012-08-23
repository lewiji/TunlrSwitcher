//
//  tunlrSwitcherAppDelegate.m
//  TunlrSwitcher
//
//  Created by Lewis Pollard on 22/08/2012.
//  Copyright (c) 2012 Lewis Pollard. All rights reserved.
//

#import "tunlrSwitcherAppDelegate.h"

@implementation tunlrSwitcherAppDelegate

bool toggled = NO;
bool firstRun = YES;

NSImage *tunlrOffImage;
NSImage *tunlrOnImage;
NSDictionary *prefsArray;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Resources/prefs" ofType:@"plist"];
    prefsArray = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

-(bool)executeShellScriptFromResourcesFolderAndReturnSuccess:(NSString *) scriptName {
    /* Load path to script */
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:scriptName ofType:nil inDirectory:@"Resources"];
    /* Create AppleScript to run script */
    NSMutableString *scriptSource = [NSMutableString stringWithFormat:@"do shell script \"%@ %@ %@ %d\" with administrator privileges", scriptPath, [prefsArray objectForKey:@"PrimaryDNSServer"], [prefsArray objectForKey:@"SecondaryDNSServer"], firstRun];
    
    /* Init applescript and execute, returns false if error occurs */
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:scriptSource];
    NSDictionary *scriptError = [[NSDictionary alloc] init];
    firstRun = NO;
    return [appleScript executeAndReturnError:&scriptError];
}

-(void)awakeFromNib{
    /* Load images for menubar icon */
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOn.png" ofType:nil inDirectory:@"Resources"];
    tunlrOnImage = [[NSImage alloc] initWithContentsOfFile:fullPath];
    
    fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOff.png" ofType:nil inDirectory:@"Resources"];
    tunlrOffImage = [[NSImage alloc] initWithContentsOfFile:fullPath];

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    
    [statusItem setImage: tunlrOffImage];
    [statusItem setHighlightMode:YES];
}

-(IBAction)switch:(id)sender {
    if ([self executeShellScriptFromResourcesFolderAndReturnSuccess:@"switch.sh"] ) {
        toggled ? [statusItem setImage: tunlrOffImage] : [statusItem setImage: tunlrOnImage];
        toggled = !toggled;
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Could not set DNS."];
        [alert runModal];
    }
}

@end
