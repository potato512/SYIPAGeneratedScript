//
//  UIDLProgessView.h
//  DownloadProgessDemo
//
//  Created by Live365_Joni on 7/14/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UIDLProgessView : NSView
@property(retain,nonatomic)NSColor *overlayColor;
@property(assign,nonatomic)CGFloat innerRadiusRatio;
@property (assign, nonatomic) CGFloat outerRadiusRatio;
@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) CGFloat circleRadiusRatio;
@property (assign, nonatomic) CGFloat stateChangeAnimationDuration;
@property (assign, nonatomic) BOOL triggersDownloadDidFinishAnimationAutomatically;
- (void)displayOperationDidFinishAnimation;
- (void)displayOperationWillTriggerAnimation;
@end
