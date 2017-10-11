//
//  AppDelegate.m
//  OutlineViewDemo
//
//  Created by Live365_Joni on 7/8/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    [self.outLineViewCtrl setOutlineView:self.outlineView];

    [self.outLineViewCtrl setOutlineView:self.outlineView];
    [self.outlineView reloadData];
}

@end
