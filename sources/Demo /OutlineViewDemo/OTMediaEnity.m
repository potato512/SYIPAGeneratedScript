//
//  OTMediaEnity.m
//  OutlineViewDemo
//
//  Created by Live365_Joni on 8/11/14.
//  Copyright (c) 2014 Live365iOS. All rights reserved.
//

#import "OTMediaEnity.h"

@implementation OTMediaEntity
@dynamic title;
@synthesize fileURL=_fileURL;

-(void)dealloc
{
    [_fileURL release];
    [super dealloc];
}

-(NSString *)title
{
    NSString *title;
    if ([self.fileURL getResourceValue:&title forKey:NSURLLocalizedNameKey error:NULL]) {
        return title;
    }
    return nil;
}

-(id)initWithFileURL:(NSURL *)fileURL
{
    self = [super init];
    if (self) {
        _fileURL = [fileURL retain];
    }
    return self;
}

-(id)copyWithZone:(struct _NSZone *)zone
{
    id result = [[[self class] alloc] initWithFileURL:self.fileURL];
    return result;
}

+(OTMediaEntity *)entityForURL:(NSURL *)url
{
    NSString *typeIdentifier;
    if ([url getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:NULL]) {
        NSString *spicalIdentifier =@"folder";
        NSRange range = [typeIdentifier rangeOfString:spicalIdentifier];
        if (range.location !=NSNotFound) {
            return [[[OTMediaFolderEntity alloc] initWithFileURL:url] autorelease];
        }else{
            return [[[OTMediaEntity alloc] initWithFileURL:url] autorelease];
        }
    }
    return nil;
}

#pragma mark -
#pragma mark - NSPasteboardWriting
- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return [self.fileURL writableTypesForPasteboard:pasteboard];
}

- (id)pasteboardPropertyListForType:(NSString *)type
{
    return [self.fileURL pasteboardPropertyListForType:type];
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard
{
    if ([self.fileURL respondsToSelector:@selector(writingOptionsForType:pasteboard:)]) {
        return [self.fileURL writingOptionsForType:type pasteboard:pasteboard];
    }
    else{
        return 0;
    }
}
#pragma mark -
#pragma mark - NSPasteboardReading
+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    // We allow creation from folder and image URLs only, but there is no way to specify just file URLs that contain images
    return [NSArray arrayWithObjects:(id)kUTTypeFolder, (id)kUTTypeFileURL, nil];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardReadingAsString;
}

- (id)initWithPasteboardPropertyList:(id)propertyList ofType:(NSString *)type
{
    [self release];
    self = nil;
    NSURL *url = [[[NSURL alloc] initWithPasteboardPropertyList:propertyList ofType:type] autorelease];
    NSString *urlUTI;
    if ([url getResourceValue:&urlUTI forKey:NSURLTypeIdentifierKey error:NULL]) {
        self = [[OTMediaEntity alloc] initWithFileURL:url];
    }
    return self;
}

@end


@implementation OTMediaFolderEntity
@dynamic children;
-(void)dealloc
{
    [_children release];
    [super dealloc];
}

-(NSMutableArray *)children
{
    NSMutableArray *result = nil;
    @synchronized(self)
    {
        if (_children == nil && self.fileURL !=nil) {
            NSArray *urls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.fileURL includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLLocalizedNameKey, nil] options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants error:NULL];
            NSMutableArray *newChildren = [[NSMutableArray alloc] initWithCapacity:urls.count];
            for(NSURL *url in urls)
            {
                NSString *typeIdentifier;
                if ([url getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:NULL])
                {
                    OTMediaEntity *entity = [OTMediaEntity entityForURL:url] ;
                    if (entity)
                    {
                        [newChildren addObject:entity];
                    }
                }
            }
            _children = newChildren;
        }
        result = [[_children retain] autorelease];
    }
    return result;
}

@end