//
//  AudioWaveSlider.m
//  AudioWaveDemo
//
//  Created by Live365_Joni on 10/13/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "AudioWaveSlider.h"

@implementation AudioWaveSlider
-(void)dealloc
{
    [knobCell release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
#pragma mark - init method
-(void)updateTrackingArea
{
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInKeyWindow | NSTrackingMouseMoved |NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
    
    [self addTrackingArea:area];
    [area release];
    area = nil;
}

-(void)setup
{    //test code
    arr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ; i<self.bounds.size.width;i++) {
        float  random = (arc4random()%10)/10.0;
        float sign = arc4random()%2;
        if (sign ==1) {
            random = random - 2*random;
        }
        [arr addObject:[NSNumber numberWithFloat:random]];
    }
    //test end
    
    _rectScale = 1.0;
    knobCell = [[AudioWaveKnob alloc] initWithFrame:self.bounds];
    [knobCell setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [self addSubview:knobCell];
    knobPoint = NSZeroPoint;
    
    [self updateTrackingArea];

}

-(NSRect)signalRect {
    NSRect retRect = [self bounds];
    return retRect;
}

#pragma mark - view notification
-(void)viewDidEndLiveResize
{
    // scale .mouseDown or mouse drag  use it
    NSRect newRect = self.bounds;
    _rectScale = _sampleDataLength/newRect.size.width;
}

#pragma mark - mouse event
-(void)mouseDown:(NSEvent *)theEvent
{
    NSPoint location =  [self convertPoint:[theEvent locationInWindow] fromView:nil];
    knobPoint.x = location.x*_rectScale ;
    
    [self setNeedsDisplay:YES];
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint location =  [self convertPoint:[theEvent locationInWindow] fromView:nil];
    knobPoint.x = location.x *_rectScale ;
    if (knobPoint.x<=0) {
        knobPoint.x = 0.0;
    }
    if (knobPoint.x >=self.bounds.size.width) {
        knobPoint.x = self.bounds.size.width;
    }
    [self setNeedsDisplay:YES];
}

#pragma mark - data operate
-(NSString *)getFromatTimeString:(int)time
{
    int minute = 0;
    int second = 0;
    minute = time/60;
    second = time - (minute *60);
    NSString *formatTime = @"00:00";
    if (minute<10) {
        if (second<10) {
            formatTime = [NSString stringWithFormat:@"0%d:0%d",minute,second];
        }
        else{
            formatTime = [NSString stringWithFormat:@"0%d:%d",minute,second];
        }
    }
    else{
        if (second<10) {
            formatTime = [NSString stringWithFormat:@"%d:0%d",minute,second];
        }
        else{
            formatTime = [NSString stringWithFormat:@"%d:%d",minute,second];
        }
    }
    return formatTime;
}

#pragma mark - draw method

-(NSAffineTransform *)coalescedSampleTransform {
    NSAffineTransform *retXform = [NSAffineTransform transform];
    NSRect waveformRect = [self signalRect];
    [retXform translateXBy:0.0f yBy:waveformRect.size.height / 2];
    [retXform scaleXBy:waveformRect.size.width / (((CGFloat)_sampleDataLength - 1 /*we're couting rungs, not fenceposts */ ))
                   yBy:waveformRect.size.height/3.0 ];
    
    return retXform;
    
}

-(void)_drawScale
{
    NSPoint *scalePoint;
    scalePoint = calloc(_sampleDataLength, sizeof(NSPoint));
    if (arr) {
        for (int i = 0 ; i<_sampleDataLength; i++) {
            if (i%60 ==0) {
                scalePoint[i] = NSMakePoint(i, - 0.3);
            }
            else if (i%30==0)
            {
                scalePoint[i] = NSMakePoint(i, - 0.2);
            }
            else if (i%5==0) {
                scalePoint[i] = NSMakePoint(i, - 0.1 );
            }
            else{
                scalePoint[i] = NSMakePoint(i, self.bounds.size.height);
            }
        }
    }
    
    NSBezierPath *scalePath = [NSBezierPath bezierPath];
    [scalePath moveToPoint:NSMakePoint(0, 0)];
    [scalePath appendBezierPathWithPoints:scalePoint count:[arr count]];
    [scalePath lineToPoint:NSMakePoint([arr count], 0)];
    
    NSAffineTransform *retXform = [NSAffineTransform transform];
    NSRect waveformRect = [self signalRect];
    [retXform translateXBy:0.0f yBy:(self.bounds.size.height- 5)];
    [retXform scaleXBy:waveformRect.size.width / (((CGFloat)_sampleDataLength - 1 /*we're couting rungs, not fenceposts */ ))
                   yBy:waveformRect.size.height/5.0 ];
    [scalePath transformUsingAffineTransform:retXform];
    
    [scalePath stroke];
    
}

-(void)_drawAudoWave:(NSArray *)waves
{
    NSPoint point = NSZeroPoint;
    
    if (_sampleData) {
        _sampleData = realloc(_sampleData, _sampleDataLength*sizeof(NSPoint));
    }
    else{
        _sampleData = calloc(_sampleDataLength, sizeof(NSPoint));
    }
    
    if (waves) {
        for (int i = 0;i <[waves count];i++)
        {
            // value range (0 ~ 1);
            float value = [[waves objectAtIndex:i] floatValue];
            point = NSMakePoint(point.x+1, value);
            _sampleData[i] = point;
        }
    }
    
    NSBezierPath *waveformPath = [NSBezierPath bezierPath];
    [waveformPath moveToPoint:NSMakePoint(0, 0)];
    [waveformPath appendBezierPathWithPoints:_sampleData count:[waves count]];
    [waveformPath lineToPoint:NSMakePoint([waves count], 0)];
    
    [waveformPath transformUsingAffineTransform:[self coalescedSampleTransform]];
    
    [[NSColor darkGrayColor] set];
    [waveformPath stroke];
    [[NSColor grayColor] set];
    [waveformPath fill];
}

- (void)drawRect:(NSRect)dirtyRect
{
     _sampleDataLength = [arr count];
    //draw scale
    [self _drawScale];
    
    //darw waves
    [self _drawAudoWave:arr];
    
    //draw knob
    if (knobCell) {
        knobCell.sampleDateLength = _sampleDataLength;
        [knobCell drawKnob:NSMakeRect(knobPoint.x, knobPoint.y, [knobCell knobSize].width, [knobCell knobSize].height)];
    }
}

@end
