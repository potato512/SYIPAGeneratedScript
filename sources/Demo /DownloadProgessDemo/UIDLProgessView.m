//
//  UIDLProgessView.m
//  DownloadProgessDemo
//
//  Created by Live365_Joni on 7/14/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import "UIDLProgessView.h"
typedef enum {
    DLProgressOverlayViewStateWaiting = 0,
    DLProgressOverlayViewStateOperationInProgress = 1,
    DLProgressOverlayViewStateOperationFinished = 2
} DLProgressOverlayViewState;

CGFloat const DLUpdateUIFrequency = 1. / 25.;

@interface UIDLProgessView ()

@property (assign, nonatomic) DLProgressOverlayViewState state;
@property (assign, nonatomic) CGFloat animationProggress;
@property (assign, nonatomic) CGFloat waitingProgress;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation UIDLProgessView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.progress = 0.;
    self.outerRadiusRatio = 0.7;
    self.innerRadiusRatio = 0.6;
    self.overlayColor = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.5];
    self.animationProggress = 0.;
    self.waitingProgress = 0.;
    self.stateChangeAnimationDuration = 0.25;
    self.triggersDownloadDidFinishAnimationAutomatically = YES;
    
}

- (void)displayOperationDidFinishAnimation
{
    self.state = DLProgressOverlayViewStateOperationFinished;
    self.animationProggress = 0.;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:DLUpdateUIFrequency target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)displayOperationWillTriggerAnimation
{
    self.state = DLProgressOverlayViewStateWaiting;
    self.animationProggress = 0.;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:DLUpdateUIFrequency target:self selector:@selector(update) userInfo:nil repeats:YES];
}

-(void)update
{
    switch (self.state) {
        case DLProgressOverlayViewStateWaiting:
        {
            CGFloat waitProgess = self.waitingProgress + DLUpdateUIFrequency/self.stateChangeAnimationDuration;
            if (waitProgess>=1.0) {
                self.waitingProgress = 1.0;
                [self.timer invalidate];
            }
            else
            {
                self.waitingProgress = waitProgess;
            }
        }
            break;
        case DLProgressOverlayViewStateOperationFinished:
        {
            CGFloat animationProggress = self.animationProggress + DLUpdateUIFrequency / self.stateChangeAnimationDuration;
            if (animationProggress >= 1.)
            {
                self.animationProggress = 1.;
                [self.timer invalidate];
                [self removeFromSuperview];
            } else {
                self.animationProggress = animationProggress;
            }
        }
            break;
        default:
            break;
    }
    [self setNeedsDisplay:YES];
}

-(void)remove
{
    [self removeFromSuperview];
}

-(void)setInnerRadiusRatio:(CGFloat)innerRadiusRatio
{
    _innerRadiusRatio = (innerRadiusRatio < 0.) ? 0. : (innerRadiusRatio > 1.) ? 1. : innerRadiusRatio;
}

-(void)setOuterRadiusRatio:(CGFloat)outerRadiusRatio
{
    _outerRadiusRatio = (outerRadiusRatio < 0.) ? 0. : (outerRadiusRatio > 1.) ? 1. : outerRadiusRatio;
}

- (void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = (progress < 0.) ? 0. : (progress > 1.) ? 1. : progress;
        if (progress > 0. && progress <1.) {
            self.state = DLProgressOverlayViewStateOperationInProgress;
        } else if (progress == 1. && self.triggersDownloadDidFinishAnimationAutomatically) {
            [NSTimer scheduledTimerWithTimeInterval:self.stateChangeAnimationDuration target:self selector:@selector(willDisplayFinishAnimation) userInfo:nil repeats:NO];
        }
        [self setNeedsDisplay:YES];
    }
}

-(void)willDisplayFinishAnimation
{
     [self displayOperationDidFinishAnimation];
}


-(NSRect)circleRect
{
    if (self.state != DLProgressOverlayViewStateOperationFinished) {
        CGFloat circleWidth = (MIN(self.bounds.size.width, self.bounds.size.height)/3.0)*2*(self.waitingProgress);
        CGFloat circleHeight = (MIN(self.bounds.size.width, self.bounds.size.height)/3.0)*2*(self.waitingProgress);
        return NSMakeRect((self.bounds.size.width - circleWidth)/2.0, (self.bounds.size.height- circleHeight)/2.0, circleWidth, circleHeight);
    }
    else
    {
        CGFloat maxCircleWidth = (MIN(self.bounds.size.width, self.bounds.size.height)/3.0)*2;
        CGFloat maxCircleHeight = (MIN(self.bounds.size.width, self.bounds.size.height)/3.0)*2;
        CGFloat circleWidth = maxCircleWidth+10 + (self.bounds.size.width/3.0 * 2 )*(self.animationProggress);
        CGFloat circleHeight = maxCircleHeight +10+ (self.bounds.size.height/3.0*2)*(self.animationProggress);
        return NSMakeRect((self.bounds.size.width - circleWidth)/2.0 , (self.bounds.size.height- circleHeight)/2.0 , circleWidth, circleHeight);
    }
    return NSZeroRect;
}

- (CGFloat)innerRadius
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat radius = MIN(width, height) / 2. * self.innerRadiusRatio;
    switch (self.state) {
        case DLProgressOverlayViewStateWaiting:
            return (radius * self.animationProggress);
        case DLProgressOverlayViewStateOperationFinished:
            return (radius + (MAX(width, height) / sqrtf(2.) - radius) * self.animationProggress);
        default: return radius;
    }
}

- (CGFloat)outerRadius
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat radius = MIN(width, height) / 2. * self.outerRadiusRatio;
    switch (self.state) {
        case DLProgressOverlayViewStateWaiting:
            return (radius * self.animationProggress);
        case DLProgressOverlayViewStateOperationFinished:
            return (radius + (MAX(width, height) / sqrtf(2.) - radius) * self.animationProggress);
        default: return radius;
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
   /*
    [self.overlayColor set];
    if ( !(self.animationProggress ==1.0) ) {
        CGFloat offset = 1 - self.animationProggress;
        [NSBezierPath setDefaultLineWidth:5*offset];
        [[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(5*offset ,5*offset, dirtyRect.size.width - 2*(5*offset), dirtyRect.size.height - 2*(5*offset)) xRadius:dirtyRect.size.width/2 yRadius:dirtyRect.size.height/2] stroke];
    }
    NSBezierPath * path = [NSBezierPath bezierPath];
    [path setLineWidth:2];
    
    NSPoint center = { self.bounds.size.width/2,self.bounds.size.height/2 };
    if (_progress==0) {
        [path appendBezierPathWithRoundedRect:NSMakeRect(10, 10, self.bounds.size.width -20 , self.bounds.size.height-20) xRadius:(self.bounds.size.width -20)/2 yRadius:(self.bounds.size.width -20)/2];
    }else{
        [path moveToPoint: center];
        [path appendBezierPathWithArcWithCenter: center
                                         radius: (self.bounds.size.width - 20)/2
                                     startAngle: 90
                                       endAngle: (CGFloat)(-_progress *360 +90)];
        
        
    }
     [path fill];
     */
    NSPoint center = NSMakePoint(NSMidX(dirtyRect), NSMidX(dirtyRect));
    [self.overlayColor set];
    //waiting animation
    NSBezierPath *path = [NSBezierPath new];
    [path setWindingRule:NSEvenOddWindingRule];
    [path appendBezierPathWithRect:dirtyRect];
    
    NSRect circleRect = [self circleRect];
    [path appendBezierPathWithRoundedRect:circleRect xRadius:circleRect.size.width/2.0 yRadius:circleRect.size.width/2.0];
    
    [path fill];
    [path release];
    path = nil;
    
    //progress animation
    path = [[NSBezierPath alloc] init];
    NSRect innerRect = NSMakeRect(circleRect.origin.x+3, circleRect.origin.y+3,circleRect.size.width-6,circleRect.size.height-6);
    if (_progress==0) {
        [path appendBezierPathWithRoundedRect:innerRect xRadius:innerRect.size.width/2.0 yRadius:innerRect.size.height];
    }
    else
    {
        [path moveToPoint:center];
        [path appendBezierPathWithArcWithCenter:center
                                         radius:innerRect.size.width/2.0
                                     startAngle:90
                                       endAngle:(CGFloat)(-_progress *360 +90)];
    }
    [path fill];
    [path release];
    path = nil;
    
}

@end
