//
//  URLReplaceController.h
//  URLTextView
//
//  Created by Live365_Joni on 10/22/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface URLReplaceController : NSViewController
{
    IBOutlet NSTextView *_textView;
}
-(void)replaceURL:(NSURL *)url forString:(NSString *)key;
@end
