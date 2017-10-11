//
//  AppDelegate.h
//  DownloadProgessDemo
//
//  Created by Live365_Joni on 7/14/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UIDLProgessView.h"
#import "UIImgView.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    int _count ;
}
@property(retain) IBOutlet UIDLProgessView *dlProgessView;
@property(retain) IBOutlet UIImgView *imgVew;
@property (assign) IBOutlet NSWindow *window;

@end
