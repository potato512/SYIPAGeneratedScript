//
//  AudioWaveKnob.h
//  AudioWaveDemo
//
//  Created by Live365_Joni on 10/13/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface AudioWaveKnob : NSView
{
    NSColor *_knobColor;
    NSRect _knobRect;
}

@property(readonly)NSSize knobSize;
@property(assign)NSUInteger sampleDateLength;

-(void)drawKnob:(NSRect)knobRect;

@end
