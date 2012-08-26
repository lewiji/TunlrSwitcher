//
//  StatusItemView.m
//  TunlrSwitcher
//
//  Created by Lewis Pollard on 25/08/2012.
//  Copyright (c) 2012 Lewis Pollard. All rights reserved.
//

#import "StatusItemView.h"
#define StatusItemViewPaddingWidth  6
#define StatusItemViewPaddingHeight 3

@implementation StatusItemView

NSImage *tunlrOffImage;
NSImage *tunlrOnImage;
bool toggled = NO;

@synthesize action = _action;
@synthesize target = _target;

- (id)init {
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    self = [super initWithFrame:itemRect];
    
    if (self) {
        statusItem = nil;
        isMenuVisible = NO;
        /* Load images for menubar icon */
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOn.png" ofType:nil inDirectory:@"Resources"];
        tunlrOnImage = [[NSImage alloc] initWithContentsOfFile:fullPath];
        
        fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOff.png" ofType:nil inDirectory:@"Resources"];
        tunlrOffImage = [[NSImage alloc] initWithContentsOfFile:fullPath];
        image = tunlrOffImage;
    }
   return self;
}

- (void)mouseDown:(NSEvent *)event {
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)rightMouseDown:(NSEvent *)event {
    // Treat right-click just like left-click
    [[self menu] setDelegate:self];
    [statusItem popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
}

- (void)menuWillOpen:(NSMenu *)menu {
    isMenuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
    isMenuVisible = NO;
    [menu setDelegate:nil];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
    // Draw status bar background, highlighted if menu is showing
    [statusItem drawStatusBarBackgroundInRect:rect
                                withHighlight:isMenuVisible];
    
    NSSize iconSize = [image size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    
    
    [image drawAtPoint:iconPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
}

-(void)toggleImage {
    toggled ? [statusItem setImage: tunlrOffImage] : [statusItem setImage: tunlrOnImage];
    toggled = !toggled;
}

@synthesize statusItem;

@end
