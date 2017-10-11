//
//  ViewController.m
//  AutoGenerateIpa
//
//  Created by zhangshaoyu on 2017/10/11.
//  Copyright © 2017年 devZhang. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark - 视图

- (void)setUI
{
    NSTextField *uploadPathTextField = [[NSTextField alloc] initWithFrame:CGRectMake(10.0, 10.0, 180.0, 35.0)];
    [self.view addSubview:uploadPathTextField];
    uploadPathTextField.backgroundColor = [NSColor lightGrayColor];
    uploadPathTextField.placeholderString = @"ipa上传路径";
    
    NSView *currentView = uploadPathTextField;
    
    NSButton *uploadButton = [[NSButton alloc] initWithFrame:CGRectMake((currentView.frame.origin.x + currentView.frame.size.width + 10.0), currentView.frame.origin.y, 60.0, currentView.frame.size.height)];
    [self.view addSubview:uploadButton];
    uploadButton.title = @"设置";
}

#pragma mark - 响应


@end
