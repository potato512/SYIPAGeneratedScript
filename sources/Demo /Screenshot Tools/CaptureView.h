//
//  CaptureView.h
//  Screenshot Tools
//
//  Created by Live365_Joni on 11/3/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CaptureDefine.h"

@interface CaptureView : NSView
- (id)initWithFrame:(NSRect)frame withCaptureType:(CaptureType )type;
-(void)FullScreenCapture:(CGDirectDisplayID )displayID;
-(void)RegionScreenCapture:(CGDirectDisplayID )displayID;
-(void)beginSelectRegion;
-(void)endSelectRegion;
-(void)customRegionSelect:(CaptureType)type;
-(void)updateCaptureWindowInfoNotification:(NSDictionary *)newCaptureWindowInfo;

@end
