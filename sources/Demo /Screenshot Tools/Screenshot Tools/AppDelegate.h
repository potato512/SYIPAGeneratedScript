//
//  AppDelegate.h
//  Screenshot Tools
//
//  Created by Live365_Joni on 10/28/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CaptureManager.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,NSTextFieldDelegate>
{
    CaptureManager *_CaptureManager;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *label;
+(NSUInteger)getCurWindowNumber;
//@property (assign) IBOutlet NSTextField *MouseLocationlabel;
//@property (assign) IBOutlet NSTextField *KeyDownlabel;
//@property (assign) IBOutlet NSTextField *WindowNamelabel;
//@property (assign) IBOutlet NSTextField *WindowRectlabel;
@end
