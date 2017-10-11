//
//  CaptureManager.h
//  Screenshot Tools
//
//  Created by Live365_Joni on 11/3/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CaptureWindow.h"

@interface CaptureManager : NSObject
@property(assign)CaptureType mCaptureType;
@property(readonly)NSImage *captureImage;
@property(readonly)CaptureState mCaptureState;

-(void)beginCapture;
-(void)capture;
-(void)endCapture;

@end
