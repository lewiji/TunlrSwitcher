//
//  tunlrSwitcherAppDelegate.m
//  TunlrSwitcher
//
//  Created by Lewis Pollard on 22/08/2012.
//  Copyright (c) 2012 Lewis Pollard. All rights reserved.
//

#import "tunlrSwitcherAppDelegate.h"

@implementation tunlrSwitcherAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Tunlr "];
}

-(IBAction)switch:(id)sender {
    NSDictionary *scriptError = [[NSDictionary alloc] init]; 
    /* Create the Applescript to run with the filename and comment string... */
    NSString *scriptSource = @"do shell script \"./switch.sh\" with administrator privileges";
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:scriptSource];
    
    if(![appleScript executeAndReturnError:&scriptError]) {
        NSLog([scriptError description]);
    }
}

@end
