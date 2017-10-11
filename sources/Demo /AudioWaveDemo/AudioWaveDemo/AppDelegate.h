//
//  AppDelegate.h
//  AudioWaveDemo
//
//  Created by Live365_Joni on 10/13/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AudioWaveSlider.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    AudioWaveSlider *slider;
}

@property (assign) IBOutlet NSWindow *window;

@end
