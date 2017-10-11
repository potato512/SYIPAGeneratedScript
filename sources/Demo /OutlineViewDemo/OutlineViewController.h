//
//  OutlineViewController.h
//  OutlineViewDemo
//
//  Created by Live365_Joni on 7/8/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTMediaEnity.h"
@interface OutlineViewController : NSObject<NSOutlineViewDataSource ,NSOutlineViewDelegate>
{
    OTMediaFolderEntity *_contents;
    NSOutlineView *_outlineView;
}
@property(assign)NSOutlineView *outlineView;

@end
