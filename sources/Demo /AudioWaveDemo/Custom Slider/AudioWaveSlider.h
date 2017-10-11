//
//  AudioWaveSlider.h
//  AudioWaveDemo
//
//  Created by Live365_Joni on 10/13/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AudioWaveKnob.h"

@interface AudioWaveSlider : NSView
{
    AudioWaveKnob  *knobCell;
    NSPoint knobPoint;
    NSSize knobSize;
    
    int minValue;
    int maxValue;
    int currentValue;
    
    NSPoint *_sampleData;
    NSUInteger  _sampleDataLength;
    float _rectScale ;
    
    //test code
    NSMutableArray *arr;
    //test end
}


@end
