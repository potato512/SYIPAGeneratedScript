//
//  AppDelegate.h
//  OutlineViewDemo
//
//  Created by Live365_Joni on 7/8/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OutlineViewController.h"
@class OTMediaEntity;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSOutlineView *outlineView;
@property (assign) IBOutlet NSWindow *window;
@property(assign) IBOutlet OutlineViewController *outLineViewCtrl;

@end
