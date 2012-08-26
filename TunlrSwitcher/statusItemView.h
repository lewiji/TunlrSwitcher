//
//  StatusItemView.h
//  TunlrSwitcher
//
//  Created by Lewis Pollard on 25/08/2012.
//  Copyright (c) 2012 Lewis Pollard. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSView <NSMenuDelegate> {
    NSStatusItem *statusItem;
    NSImage *image;
    BOOL isMenuVisible;
    SEL _action;
    __unsafe_unretained id _target;
}
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;
-(void)toggleImage;
@end