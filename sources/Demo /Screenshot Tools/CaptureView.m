//
//  CaptureView.m
//  Screenshot Tools
//
//  Created by Live365_Joni on 11/3/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "CaptureView.h"
#import "AppDelegate.h"
@interface CaptureView()
{
    NSPoint beginPoint;
    NSPoint endPoint;
    
    NSRect _regionRc;
    
    BOOL _selectedRegion;
    
    BOOL _startCapture;
    CGDirectDisplayID _displayID;
    CaptureType _captureType;
    
    NSButton *btnCapture;
    NSInteger _borderLineWidth;
    
    NSDictionary *_newCaptureWindowInfo;
}

@end
@implementation CaptureView
-(void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame withCaptureType:(CaptureType )type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
       
        [self setup];
        _selectedRegion = NO;
        _startCapture = NO;
        _captureType = type;
        _borderLineWidth = 2.0;
        _newCaptureWindowInfo = nil;
    }
    return self;
}

-(void)setup
{

    beginPoint = NSMakePoint(0, 0);
    endPoint = NSMakePoint(0, 0);
    
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInActiveApp|NSTrackingMouseMoved|NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
    [self addTrackingArea:area];
    [area release];
    area = nil;
    
    btnCapture = [[NSButton alloc] initWithFrame:NSMakeRect(_regionRc.origin.x+_regionRc.size.width - 50, _regionRc.origin.y-30, 50, 30)];
    [btnCapture setTitle:@"Capture"];
    [btnCapture setBordered:YES];
    [btnCapture setTarget:self];
    [btnCapture setAction:@selector(postCaptureNotify)];
    [self addSubview:btnCapture];
    [btnCapture release];
    [btnCapture setHidden:YES];
}

-(void)FullScreenCapture:(CGDirectDisplayID)displayID
{
     _displayID = displayID;
    [self startCapture];
   
}

-(void)RegionScreenCapture:(CGDirectDisplayID)displayID
{
    _displayID = displayID;
    [self startCapture];
}

-(void)startCapture
{
    _startCapture = YES;
}

-(void)endCapture
{
    _startCapture = NO;
    EndCapturePush;
}

-(void)beginSelectRegion
{
    _selectedRegion = NO;
    beginPoint.x = 0;
    beginPoint.y = 0;
    _regionRc = NSMakeRect(0, 0, 0, 0);
    [btnCapture setHidden:YES];
}

-(void)endSelectRegion
{
    _selectedRegion = YES;
    [btnCapture setHidden:NO];
    [btnCapture setFrame:NSMakeRect(_regionRc.origin.x+_regionRc.size.width - 50, _regionRc.origin.y-30, 50, 30)];
    NSRect screenrect = [[NSScreen mainScreen] frame];
    if (btnCapture.frame.origin.x>=screenrect.size.width) {
        [btnCapture setFrameOrigin:NSMakePoint(screenrect.size.width- btnCapture.frame.size.width, btnCapture.frame.origin.y)];
    }
}

-(void)clearSelectedRegion
{
    endPoint.x = 0;
    endPoint.y = 0;
    beginPoint.x = endPoint.x;
    beginPoint.y = endPoint.y;
    _selectedRegion = NO;
    _regionRc.size = NSZeroSize;
    _newCaptureWindowInfo = nil;
    if (btnCapture) {
        [btnCapture setHidden:YES];
    }
    [self setNeedsDisplay:YES];
}

-(void)_CaptureWithRect:(NSRect)rect fileName:(NSString *)fileName
{
    CGImageRef imageRef = CGWindowListCreateImage(rect, kCGWindowListOptionOnScreenOnly,(CGWindowID)[AppDelegate getCurWindowNumber] , kCGWindowImageNominalResolution);
    NSRect fullScreenRect = [[NSScreen mainScreen] frame];
    CGRect rc = CGRectMake(_regionRc.origin.x+_borderLineWidth,fullScreenRect.size.height - _regionRc.size.height - rect.origin.y +_borderLineWidth+_borderLineWidth/2.0, _regionRc.size.width-2*(_borderLineWidth +1 ), _regionRc.size.height-2*(_borderLineWidth+1));
    CGImageRef regionImageRef = CGWindowListCreateImage(rc, kCGWindowListOptionOnScreenOnly,(CGWindowID)[AppDelegate getCurWindowNumber] , kCGWindowImageNominalResolution);
    
    size_t imageRefWidth = CGImageGetWidth(_captureType==CaptureType_FullScreen?imageRef:regionImageRef);
    size_t imageRefHeight = CGImageGetHeight(_captureType==CaptureType_FullScreen?imageRef:regionImageRef);
    
    NSImage *newImage = [[NSImage alloc] initWithCGImage:_captureType==CaptureType_FullScreen?imageRef:regionImageRef size:NSMakeSize(imageRefWidth, imageRefHeight)];
    
    NSImage *cursorImg = [[NSCursor currentCursor] image];
    
    NSSize size = newImage.size;
    
    [newImage lockFocus];
    [cursorImg drawInRect:NSMakeRect(20, 30 , cursorImg.size.width, cursorImg.size.height)];
    [newImage unlockFocus];
    
    size = newImage.size;
//    [NSApp currentEvent];
    
    NSBitmapImageRep *imagebits = [[NSBitmapImageRep alloc] initWithData:[newImage TIFFRepresentation]];
    NSData *data = [imagebits representationUsingType:NSPNGFileType properties:nil];
    [data writeToFile:fileName atomically:YES];
    [imagebits release];
    [newImage release];
    CGImageRelease(imageRef);
    CGImageRelease(regionImageRef);
    [self endCapture];
}

-(NSString *)getDesktopPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return path;
}

-(void)_FullScreenCapture
{
    NSRect fullScreenRect = [[NSScreen mainScreen] frame];
    NSString *path = [self getDesktopPath];
    path = [path stringByAppendingPathComponent:@"testScreenShot.png"];
    [self _CaptureWithRect:fullScreenRect fileName:path];
}

-(void)_RegionCapture
{
    NSString *path = [self getDesktopPath];
    path = [path stringByAppendingPathComponent:@"testRegionScreenShot.png"];
    [self _CaptureWithRect:_regionRc fileName:path];
}

-(void)customRegionSelect:(CaptureType)type
{
    _captureType = type;
    if (_newCaptureWindowInfo != nil) {
        [self endSelectRegion];
    }
    else{
        [self beginSelectRegion];
        _newCaptureWindowInfo = nil;
    }
}

#pragma mark - mouse event

-(void)mouseDown:(NSEvent *)theEvent
{
    if (_captureType == CaptureType_CustomRegion)
    {
        if (_selectedRegion==NO) {
            beginPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
            endPoint.x = beginPoint.x;
            endPoint.y = beginPoint.y;
        }
         [self setNeedsDisplay:YES];
    }
}

-(void)mouseUp:(NSEvent *)theEvent
{
    [self endSelectRegion];
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    endPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [self setNeedsDisplay:YES];
}

-(void)mouseMoved:(NSEvent *)theEvent
{

}

-(void)rightMouseDown:(NSEvent *)theEvent
{
    if (_regionRc.size.width !=0 || _regionRc.size.height !=0)
    {
        [self clearSelectedRegion];
        StartCustomRegionCapturePush;
    }
    else{
        CancelCapturePush;
    }
}

#pragma mark - notification
-(void)updateCaptureWindowInfoNotification:(NSDictionary *)newCaptureWindowInfo
{
    if (_captureType != CaptureType_WindowRegion)
    {
        return;
    }
    if (![btnCapture isHidden]) {
        return;
    }
    if (newCaptureWindowInfo)
    {
        NSString *windowName = [newCaptureWindowInfo objectForKey:(NSString *)kCGWindowName];
        NSLog(@"%@",windowName);
        _newCaptureWindowInfo = newCaptureWindowInfo;
        [newCaptureWindowInfo objectForKey:(NSString *)kCGWindowBounds];
        CGRect windowRect;
        CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)[newCaptureWindowInfo objectForKey:(NSString *)kCGWindowBounds], &windowRect);
        NSRect fullScreenRc = [[NSScreen mainScreen] frame];
        NSRect nsWindowRect = NSMakeRect(windowRect.origin.x, fullScreenRc.size.height - windowRect.origin.y - windowRect.size.height, windowRect.size.width, windowRect.size.height);
        NSLog(@"the window rect ---> X:%f Y:%f W:%f H%f",nsWindowRect.origin.x,nsWindowRect.origin.y,nsWindowRect.size.width,nsWindowRect.size.height);
        _regionRc = nsWindowRect;
        [self setNeedsDisplay:YES];
    }
}

#pragma mark- action
-(void)postCaptureNotify
{
    StartCapturePush;
}

#pragma mark - draw
-(void)_RegionCaptureDraw:(NSRect)dirtyRect
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineCapStyle:NSRoundLineCapStyle];
    [path appendBezierPathWithRect:dirtyRect];
    [path setWindingRule:NSEvenOddWindingRule];
    if (_newCaptureWindowInfo ==nil ) {
        if ( !((beginPoint.x == endPoint.x) && (beginPoint.y == beginPoint.y)))
        {
            _regionRc = NSMakeRect((beginPoint.x>endPoint.x)?endPoint.x:beginPoint.x,(beginPoint.y>endPoint.y)?endPoint.y:beginPoint.y, (beginPoint.x>endPoint.x)?beginPoint.x-endPoint.x:endPoint.x-beginPoint.x, (beginPoint.y>endPoint.y)?beginPoint.y-endPoint.y:endPoint.y-beginPoint.y);
        }
    }
    [path appendBezierPathWithRect:_regionRc];

    [[NSColor redColor] set];
    NSBezierPath *squarePath = [NSBezierPath bezierPath];
    [squarePath setLineWidth:_borderLineWidth];
    [squarePath appendBezierPathWithRect:NSMakeRect(_regionRc.origin.x, _regionRc.origin.y, _regionRc.size.width-_borderLineWidth/2.0, _regionRc.size.height-_borderLineWidth/2.0)];
    [squarePath stroke];
    [[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.4] set];
    [path fill];

}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    
    if (_captureType != CaptureType_FullScreen)
    {
        [self _RegionCaptureDraw:dirtyRect];
    }

    if (_startCapture) {
        if (_captureType == CaptureType_FullScreen)
        {
            [self _FullScreenCapture];
        }
        else{
            [self _RegionCapture];
        }
    }
}

@end
