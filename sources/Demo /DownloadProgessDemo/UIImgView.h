//
//  UIImgView.h
//  DownloadProgessDemo
//
//  Created by Live365_Joni on 7/14/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UIDLProgessView.h"
@interface UIImgView : NSView
{
    NSImageView *_imgView;
    UIDLProgessView *_DLProgessView;
}

@property(assign,nonatomic)int progess;

@end
