//
//  OTMediaEnity.h
//  OutlineViewDemo
//
//  Created by Live365_Joni on 8/11/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTMediaEntity : NSObject<NSPasteboardWriting,NSPasteboardReading>
{
@private
    NSURL *_fileURL;
}
@property(nonatomic,readonly)NSString *title;
@property(nonatomic,retain)NSURL *fileURL;

- (id)initWithFileURL:(NSURL *)fileURL ;

@end

@interface OTMediaFolderEntity : OTMediaEntity
{
@private
    NSMutableArray *_children;
}
@property(retain)NSMutableArray *children;

@end
