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

@implementation tunlrSwitcherAppDelegate
@synthesize window, primaryDNSField, secondaryDNSField;

bool toggled = NO;
bool firstRun = YES;

NSImage *tunlrOffImage;
NSImage *tunlrOnImage;
NSString *primaryDNS;
NSString *secondaryDNS;

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"prefDefaults" ofType:@"plist"];
    NSDictionary *plistDefaults = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *appDefaults = plistDefaults;
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [plistDefaults release];
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
    firstRun = NO;
    bool success;
    success = [appleScript executeAndReturnError:&scriptError];
    [appleScript release];
    [scriptError release];
    return success;
}

-(void)awakeFromNib {
    /* Load images for menubar icon */
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOn.png" ofType:nil inDirectory:@"Resources"];
    tunlrOnImage = [[NSImage alloc] initWithContentsOfFile:fullPath];
    
    fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOff.png" ofType:nil inDirectory:@"Resources"];
    tunlrOffImage = [[NSImage alloc] initWithContentsOfFile:fullPath];

    /* Create menubar item */
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setImage: tunlrOffImage];
    [statusItem setHighlightMode:YES];
    [statusItem retain];
}
                              
-(IBAction)switch:(id)sender {
    if ([self executeShellScriptFromResourcesFolderAndReturnSuccess:@"switch.sh"] ) {
        toggled ? [statusItem setImage: tunlrOffImage] : [statusItem setImage: tunlrOnImage];
        toggled = !toggled;
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Could not set DNS."];
        [alert runModal];
        [alert release];
    }
}

-(IBAction)openPrefsPanel:(id)sender {
    if (! prefsWindow ) {
		prefsWindow	= [[NSWindowController alloc] initWithWindow:[self window]];
	}
    
    primaryDNS = [[NSUserDefaults standardUserDefaults] stringForKey:@"PrimaryDNSServer"];
    secondaryDNS = [[NSUserDefaults standardUserDefaults] stringForKey:@"SecondaryDNSServer"];
    

    NSArray *webDNS = [self getWebDNS];
    NSString *webPrimaryDNS = [webDNS objectAtIndex:0];
    NSString *webSecondaryDNS = [webDNS objectAtIndex:1];
    
    if ( [primaryDNS isNotEqualTo: webPrimaryDNS] || [secondaryDNS isNotEqualTo: webSecondaryDNS] ) {
        NSAlert *dnsalert = [[NSAlert alloc] init];
        [dnsalert setMessageText:@"Tunlr.net has updated their DNS IPs!"];
        [dnsalert setInformativeText:@"Would you like to Update your DNS settings?\nBe aware, this cannot be undone."];
        [dnsalert addButtonWithTitle:@"Ok"];
        [dnsalert addButtonWithTitle:@"No Thanks"];
        [dnsalert setAlertStyle:NSWarningAlertStyle];
        
        if ([dnsalert runModal] == NSAlertFirstButtonReturn) {
            // OK clicked, update the record
            primaryDNS = webPrimaryDNS;
            secondaryDNS = webSecondaryDNS;
        }
        [dnsalert release];
    }
    
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

-(NSArray *)getWebDNS {
    /* Get DNS ip's from website */
    NSURL *targetURL = [NSURL URLWithString:@"http://tunlr.net/get-started/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Create a string from dataResponse using encoding so we can parse the response.
    NSString *dataString = [[NSString alloc] initWithData:dataResponse encoding:NSASCIIStringEncoding];
    
    // Parse data into an array, where dataString equals '<span style="font-size: xx-large;">' (well, sort of..)
    NSArray *components = [dataString componentsSeparatedByString:@"font-size: xx-large;"];
    
    // Create a Mutable for storing the output of the for-loop
    NSMutableArray *webDNSIPArray = [NSMutableArray arrayWithCapacity:2];
    
    // Time for Parsing the HTML into single ip's
    for (NSString *queryString in components) {
        // look for the closing bracket of '<span style="font-size: xx-large;">'
        NSArray *queryComponents = [queryString componentsSeparatedByString:@">"];
        NSString *parseString = [queryComponents objectAtIndex:1];
        
        // Parse out the remaining '</span>'
        NSArray *qC = [parseString componentsSeparatedByString:@"<"];
        NSString *ipString = [qC objectAtIndex:0];
		      
        // add parsed ip to array so we can access it outside the loop
        [webDNSIPArray addObject:[NSString stringWithFormat:@"%@", ipString]];
        
    }

    // clean out unnecessary data that slipped though
    NSMutableArray *cleanArray = [NSMutableArray arrayWithArray:webDNSIPArray];
    [cleanArray removeObjectAtIndex:0];
    webDNSIPArray = [[NSArray arrayWithArray: cleanArray] retain];

    return [webDNSIPArray autorelease];
}

-(void)dealloc {
    [window release], window = nil;
    [primaryDNSField release], primaryDNSField = nil;
    [secondaryDNSField release], secondaryDNSField = nil;
    [tunlrOffImage release], tunlrOffImage = nil;
    [tunlrOnImage release], tunlrOnImage = nil;
    [prefsWindow release], prefsWindow = nil;
    toggled = nil;
    firstRun = nil;
    [super dealloc];
}

@end
