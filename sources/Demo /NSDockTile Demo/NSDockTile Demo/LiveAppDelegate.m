//
//  LiveAppDelegate.m
//  NSDockTile Demo
//
//  Created by Live365_Joni on 6/12/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import "LiveAppDelegate.h"

@implementation LiveAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.textView.string = @"该Demo主要展示两个功能:\n 1、Badgel  显示于Dock中App上的红色字体.\n 2、Status bar icon 显示于屏幕右上角";
    
    NSDockTile *dock = [NSApp dockTile];
    if (dock) {
        [dock setBadgeLabel:@"New"];
        [dock setShowsApplicationBadge:YES];
        
        //system status bar
        NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
        if (statusBar) {
            NSStatusItem *statusBarItem = [[statusBar statusItemWithLength:NSVariableStatusItemLength] retain];
            [statusBarItem setImage:[NSImage imageNamed:@"smallIcon"]];
            [statusBarItem setHighlightMode:YES];
            NSMenu *menu = [[NSMenu alloc] initWithTitle:@"menu"];
            [menu addItemWithTitle:@"item1" action:@selector(action) keyEquivalent:@""];
            [menu addItemWithTitle:@"item2" action:@selector(action) keyEquivalent:@""];
            [statusBarItem setMenu:menu];
//            [statusBarItem setView:[[NSView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)]];
            
//            [statusBarItem popUpStatusItemMenu:menu];
        }
    }
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    if (!flag) {
        [self.window orderFront:nil];
        [self.window makeKeyWindow];
    }
    return YES;
}

-(NSMenu *)applicationDockMenu:(NSApplication *)sender
{
    NSMenu *dockMenu = [[[NSMenu alloc] initWithTitle:@"DockTile"] autorelease];
    [dockMenu addItemWithTitle:self.window.title action:@selector(dockAction) keyEquivalent:@""];
    
    return dockMenu;
}

-(void)action{
    
}

-(void)dockAction
{
    [self.window orderFront:nil];
    [self.window makeKeyWindow];
}

@end
