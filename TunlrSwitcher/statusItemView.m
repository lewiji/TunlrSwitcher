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

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
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
    // Trigger switch
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
    [statusItem drawStatusBarBackgroundInRect:[self bounds]
                                withHighlight:isMenuVisible];
    
    // Draw title string
    NSPoint origin = NSMakePoint(StatusItemViewPaddingWidth,
                                 StatusItemViewPaddingHeight);
    NSRect drawRect;
    drawRect.size = image.size;
    drawRect.origin = NSZeroPoint;
    
    [image drawAtPoint:origin fromRect:drawRect operation:NSCompositeSourceOver fraction:1];
    
}

-(void)toggleImage {
    toggled ? [statusItem setImage: tunlrOffImage] : [statusItem setImage: tunlrOnImage];
    toggled = !toggled;
}

@synthesize statusItem;

@end
