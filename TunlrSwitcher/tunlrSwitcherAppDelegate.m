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

NSImage *tunlrOffImage;
NSImage *tunlrOnImage;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Reset DNS across the board to keep consistency */
    [self executeShellScriptFromResourcesFolderAndReturnSuccess:@"reset.sh"];
}

-(bool)executeShellScriptFromResourcesFolderAndReturnSuccess:(NSString *) scriptName {
    /* Load path to script */
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:scriptName ofType:nil inDirectory:@"Resources"];
    /* Create AppleScript to run script */
    NSString *scriptSource = [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", scriptPath];
    
    /* Init applescript and execute, returns false if error occurs */
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:scriptSource];
    NSDictionary *scriptError = [[NSDictionary alloc] init];
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
    if ([self executeShellScriptFromResourcesFolderAndReturnSuccess:@"switch.sh"]) {
        toggled ? [statusItem setImage: tunlrOffImage] : [statusItem setImage: tunlrOnImage];
        toggled = !toggled;
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Could not set DNS."];
        [alert runModal];
    }
}

@end
