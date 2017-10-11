//
//  AppDelegate.m
//  AudioWaveDemo
//
//  Created by Live365_Joni on 10/13/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
//    NSInteger ret_code = [panel runModalForTypes:@"mp3"];
    
    
    slider = [[AudioWaveSlider alloc] initWithFrame:NSMakeRect(20, 50, self.window.frame.size.width - 40, 200)];
    [slider setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [self.window.contentView addSubview:slider];
}

@end
