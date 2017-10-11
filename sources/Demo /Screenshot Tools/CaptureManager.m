//
//  CaptureManager.m
//  Screenshot Tools
//
//  Created by Live365_Joni on 11/3/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "CaptureManager.h"

@interface CaptureManager()
{
    CaptureWindow *_window;
    CaptureType _captureType;
    CaptureState _captureState;
    
    CGDirectDisplayID *displays;
    NSImage *_captureImage;
    
    CGContextRef _context;
}
@end

@implementation CaptureManager
@synthesize mCaptureType =_captureType;
@synthesize mCaptureState = _captureState;
-(id)init
{
    self = [super init];
    if (self) {
        self.mCaptureType = CaptureType_WindowRegion;
        _captureState = CaptureState_None;
        [self interrogateHardware];
        CancelCaptureRegister;
        EndCaptureRegister;
        StartCaptureRegister;
        UpdateCaptureWindowInfoRegister;
        StartCustomRegionCaptureRegister;
    }
    return self;
}

-(NSString *)displayNameFromDisplayID:(CGDirectDisplayID)displayID
{
    NSString *displayProductName = nil;
    
    /* Get a CFDictionary with a key for the preferred name of the display. */
    NSDictionary *displayInfo = (NSDictionary *)IODisplayCreateInfoDictionary(CGDisplayIOServicePort(displayID), kIODisplayOnlyPreferredName);
    /* Retrieve the display product name. */
    NSDictionary *localizedNames = [displayInfo objectForKey:[NSString stringWithUTF8String:kDisplayProductName]];
    
    /* Use the first name. */
    if ([localizedNames count] > 0)
    {
        displayProductName = [[localizedNames objectForKey:[[localizedNames allKeys] objectAtIndex:0]] retain];
    }
    
    [displayInfo release];
    return [displayProductName autorelease];
}

-(void)interrogateHardware
{
    CGError				err = CGDisplayNoErr;
	CGDisplayCount		dspCount = 0;
    
    /* How many active displays do we have? */
    err = CGGetActiveDisplayList(0, NULL, &dspCount);
    
	/* If we are getting an error here then their won't be much to display. */
    if(err != CGDisplayNoErr)
    {
        return;
    }
	
	/* Maybe this isn't the first time though this function. */
	if(displays != nil)
    {
		free(displays);
    }
    
	/* Allocate enough memory to hold all the display IDs we have. */
    displays = calloc((size_t)dspCount, sizeof(CGDirectDisplayID));
    
	// Get the list of active displays
    err = CGGetActiveDisplayList(dspCount,
                                 displays,
                                 &dspCount);
	
	/* More error-checking here. */
    if(err != CGDisplayNoErr)
    {
        NSLog(@"Could not get active display list (%d)\n", err);
        return;
    }
}

#pragma mark - capture data
-(CaptureState)mCaptureState
{
    return _captureState;
}

-(NSImage *)captureImage
{
    return _captureImage;
}

#pragma mark -Capture
-(void)beginCapture
{
    if (_window) {
        [_window release];
        _window = nil;
    }
    _captureState = CaptureState_Capturing;
    _window = [[CaptureWindow alloc] initWindowWithCaptueType:_captureType];
}

-(void)capture
{
    if (_captureType ==CaptureType_FullScreen) {
        [self _FullScreenCapture];
    }
    else{
        [self _RegionCapture];
    }
}

-(void)endCapture
{
     _captureState = CaptureState_None;
    self.mCaptureType = CaptureType_None;
    [_window close];
    _window = nil;
}

-(void)_RegionCapture
{
    [_window RegionScreenCapture:displays[0]];
}

-(void)_FullScreenCapture
{
    [_window FullScreenCapture:displays[0]];
}

#pragma mark - Notification
-(void)cancelCaptureNotification:(NSNotification *)notify
{
    [self endCapture];
}

-(void)endCaptureNotification:(NSNotification *)notify
{
    [self endCapture];
}

-(void)startCaptureNotification:(NSNotification *)notify
{
    [self capture];
}

-(void)updateCaptureWindowInfoNotification:(NSNotification *)notify
{
    if (notify.object && [notify.object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *newCaptureWindowInfo = (NSDictionary *)notify.object;
        if (_window) {
            [_window updateCaptureWindowInfoNotification:newCaptureWindowInfo];
        }
    }
}

-(void)startCustomRegionCaptureNotification:(NSNotification *)notify
{
    if (_captureState == CaptureState_Capturing) {
        if (self.mCaptureType != CaptureType_CustomRegion)
        {
            self.mCaptureType = CaptureType_CustomRegion;
            [_window customRegionSelect:CaptureType_CustomRegion];
        }
    }
}

@end
