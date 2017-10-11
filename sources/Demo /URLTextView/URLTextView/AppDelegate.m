//
//  AppDelegate.m
//  URLTextView
//
//  Created by Live365_Joni on 8/18/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "AppDelegate.h"
#import "URLMatchController.h"
#import "URLReplaceController.h"

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.label.stringValue = @"该Demo展示了使用链接的两种显示方法:\n 1、文本替换  即使用文本代替链接，点击文本可以跳转到相应链接.\n 2、链接检测  即在输入文本的过程中，可以相应检测出链接.";
    
    URLReplaceController *rCtrl = [[URLReplaceController alloc] initWithNibName:@"URLReplaceController" bundle:nil];
    [rCtrl.view setFrameOrigin:NSMakePoint(0, self.window.frame.size.height - 2*rCtrl.view.frame.size.height)];
    [rCtrl replaceURL:[NSURL URLWithString:@"http://www.baidu.com"] forString:@"百度"];
    [self.window.contentView addSubview:rCtrl.view];
    
    URLMatchController *ctrl = [[URLMatchController alloc] initWithNibName:@"URLMatchController" bundle:nil];
    [self.window.contentView addSubview:ctrl.view];
}

@end
