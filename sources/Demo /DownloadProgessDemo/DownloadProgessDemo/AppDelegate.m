//
//  AppDelegate.m
//  DownloadProgessDemo
//
//  Created by Live365_Joni on 7/14/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _count = 0;
    sleep(1);
    [self.dlProgessView displayOperationWillTriggerAnimation];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setProgessValue) userInfo:nil repeats:YES];
}

-(void)setProgessValue
{
    _count = _count+5;
    self.dlProgessView.progress = _count/60.0;
}

@end
