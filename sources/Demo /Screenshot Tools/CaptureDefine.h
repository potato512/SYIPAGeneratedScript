//
//  CaptureDefine.h
//  Screenshot Tools
//
//  Created by Live365_Joni on 11/3/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#ifndef Screenshot_Tools_CaptureDefine_h
#define Screenshot_Tools_CaptureDefine_h

#import "KeyCode.h"

enum
{
    CaptureType_None = 0,
    CaptureType_FullScreen = 1,
    CaptureType_WindowRegion = 2,
    CaptureType_CustomRegion = 3
};
typedef NSInteger CaptureType;

enum{
    CaptureState_None = 0,
    CaptureState_Capturing = 1
};
typedef NSInteger CaptureState;

#define CancelCaptureRegister     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCaptureNotification:) name:@"CancelCaptureRegister" object:nil]
#define CancelCapturePush   [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelCaptureRegister" object:nil]

#define EndCaptureRegister [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endCaptureNotification:) name:@"EndCaptureRegister" object:nil]
#define EndCapturePush [[NSNotificationCenter defaultCenter] postNotificationName:@"EndCaptureRegister" object:nil]

#define StartCaptureRegister [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startCaptureNotification:) name:@"StartCaptureRegister" object:nil]
#define StartCapturePush [[NSNotificationCenter defaultCenter] postNotificationName:@"StartCaptureRegister" object:nil]

#define StartCustomRegionCaptureRegister [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startCustomRegionCaptureNotification:) name:@"StartCustomRegionCaptureRegister" object:nil]
#define StartCustomRegionCapturePush [[NSNotificationCenter defaultCenter] postNotificationName:@"StartCustomRegionCaptureRegister" object:nil]

#define DidBeginCaptureRegister [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginCaptureNotification:) name:@"DidBeginCaptureRegister" object:nil]
#define DidBeginCapturePush [[NSNotificationCenter defaultCenter] postNotificationName:@"DidBeginCaptureRegister" object:windowDic]

#define UpdateCaptureWindowInfoRegister  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCaptureWindowInfoNotification:) name:@"UpdateCaptureWindowInfoRegister" object:nil]
#define UpdateCaptureWindowPush  [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCaptureWindowInfoRegister" object:captureWindowInfoDic]


#endif
