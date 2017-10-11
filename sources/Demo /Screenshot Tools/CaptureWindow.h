//
//  CaptureWindow.h
//  Screenshot Tools
//
//  Created by Live365_Joni on 11/3/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CaptureDefine.h"
#import "CaptureView.h"
@interface CaptureWindow : NSWindow
-(id)initWindowWithCaptueType:(CaptureType)type;
-(void)FullScreenCapture:(CGDirectDisplayID )displayID;
-(void)RegionScreenCapture:(CGDirectDisplayID )displayID;
-(void)updateCaptureWindowInfoNotification:(NSDictionary *)newCaptureWindowInfo;
-(void)customRegionSelect:(CaptureType)type;
@end
