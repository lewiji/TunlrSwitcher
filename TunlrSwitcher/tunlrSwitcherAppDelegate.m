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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib{
    
    NSDictionary *scriptError = [[NSDictionary alloc] init];

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOff.png" ofType:nil inDirectory:@"Resources"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:fullPath];
    [statusItem setImage: image];
    
    /* Reset DNS */
    NSString *scriptSource = @"do shell script \"for adapter in $adapters do\nnetworksetup -setdnsservers $adapter empty\ndone\" with administrator privileges";
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:scriptSource];
    
    
    if(![appleScript executeAndReturnError:&scriptError]) {
        NSLog([scriptError description], nil);
    }
}

-(IBAction)switch:(id)sender {
    NSDictionary *scriptError = [[NSDictionary alloc] init]; 
    /* Create the Applescript to run with the filename and comment string... */
    NSString *scriptSource = @"do shell script \"./switch.sh\" with administrator privileges";
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:scriptSource];
    

    if(![appleScript executeAndReturnError:&scriptError]) {
        NSLog([scriptError description], nil);
    }
    
    if (toggled == NO) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOn.png" ofType:nil inDirectory:@"Resources"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:fullPath];
        [statusItem setImage: image];
        toggled = YES;
    } else {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOff.png" ofType:nil inDirectory:@"Resources"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:fullPath];
        [statusItem setImage: image];
    }
}

@end
