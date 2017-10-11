//
//  AudioWaveKnob.m
//  AudioWaveDemo
//
//  Created by Live365_Joni on 10/13/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "AudioWaveKnob.h"

@implementation AudioWaveKnob
@synthesize knobSize;
@synthesize sampleDateLength;

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _knobColor = [NSColor greenColor];
        _knobRect = NSMakeRect(0, 0, [self knobSize].width, [self knobSize].height);
    }
    return self;
}

-(NSSize)knobSize
{
    return NSMakeSize(1, self.bounds.size.height);
}

#pragma mark - draw method
-(void)drawKnob:(NSRect)knobRect
{
    _knobRect = knobRect;
    [self drawRect:self.bounds];
}

-(void)_drawKnob
{
    [_knobColor set];
    NSBezierPath *knobPath = [NSBezierPath bezierPath];
    [knobPath moveToPoint:_knobRect.origin];
    [knobPath lineToPoint:NSMakePoint(_knobRect.origin.x, _knobRect.origin.y+_knobRect.size.height)];
    
    NSAffineTransform *retXFrom = [NSAffineTransform transform];
    NSRect waveformRect = [self bounds];
    [retXFrom translateXBy:0.0f yBy:0.0f];
    [retXFrom scaleXBy:waveformRect.size.width / (((CGFloat)self.sampleDateLength - 1 /*we're couting rungs, not fenceposts */ ))
                   yBy:waveformRect.size.height/5.0 ];
    [knobPath transformUsingAffineTransform:retXFrom];
    [knobPath stroke];
}

-(void)drawRect:(NSRect)dirtyRect
{
    [self _drawKnob];
}


@end