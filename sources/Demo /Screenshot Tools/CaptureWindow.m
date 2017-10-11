//
//  CaptureWindow.m
//  Screenshot Tools
//
//  Created by Live365_Joni on 11/3/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "CaptureWindow.h"

@interface CaptureWindow ()
{
    CaptureView *_view;
}
@end

@implementation CaptureWindow
-(void)dealloc
{
    [_view release];
    [super dealloc];
}

-(id)initWindowWithCaptueType:(CaptureType)type
{
    NSRect fullScreenRect = [[NSScreen mainScreen] frame];
    self = [super initWithContentRect:fullScreenRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO screen:[NSScreen mainScreen]];
    if (self) {
        NSUInteger windowNumber = [self windowNumber];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setOpaque:NO];
        _view = [[CaptureView alloc] initWithFrame:fullScreenRect withCaptureType:type];
        [self.contentView addSubview:_view];
        if (type != CaptureType_FullScreen) {
            [self setLevel:1000+1];
            [self makeKeyAndOrderFront:nil];
            [self display];
        }
        //push notificaton
        
        NSDictionary *windowDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:windowNumber],@"kWindowNumber", nil];
        DidBeginCapturePush;
    }
    return self;
}

-(void)updateCaptureWindowInfoNotification:(NSDictionary *)newCaptureWindowInfo
{
    if (_view) {
        [_view updateCaptureWindowInfoNotification:newCaptureWindowInfo];
    }
}

-(void)FullScreenCapture:(CGDirectDisplayID)displayID
{
    [_view FullScreenCapture:displayID];
    [self display];
}

-(void)RegionScreenCapture:(CGDirectDisplayID)displayID
{
    [_view RegionScreenCapture:displayID];
    [self display];
}

-(void)customRegionSelect:(CaptureType)type
{
    [_view customRegionSelect:type];
    [self display];
}

//- (BOOL)canBecomeKeyWindow
//{
//    return YES;
//}
//
//- (BOOL)canBecomeMainWindow
//{
//    return YES;
//}

@end
