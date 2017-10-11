//
//  UIImgView.m
//  DownloadProgessDemo
//
//  Created by Live365_Joni on 7/14/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import "UIImgView.h"

@implementation UIImgView
@synthesize progess;

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

-(void)setUp{
    _imgView = [[NSImageView alloc] initWithFrame:self.bounds];
     [_imgView setImage:[NSImage imageNamed:@"albumCover_default.png"]];
    [_imgView setImageScaling:NSImageScaleAxesIndependently];
    [self addSubview:_imgView];
    
    _DLProgessView = [[UIDLProgessView alloc] initWithFrame:self.bounds];
    [self addSubview:_DLProgessView];
    
    self.wantsLayer = YES;
    self.layer.cornerRadius = self.bounds.size.width/2;
}

-(void)setProgess:(int)pProgess
{
    _DLProgessView.progress = pProgess;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
