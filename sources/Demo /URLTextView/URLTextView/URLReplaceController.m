//
//  URLReplaceController.m
//  URLTextView
//
//  Created by Live365_Joni on 10/22/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "URLReplaceController.h"

@interface URLReplaceController ()

@end

@implementation URLReplaceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self.view awakeFromNib];
        _textView.string = @"这个链接是百度";
        _textView.linkTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor blueColor], NSForegroundColorAttributeName,[NSNumber numberWithInteger:NSSingleUnderlineStyle],NSUnderlineStyleAttributeName, nil];
    }
    return self;
}

-(void)replaceURL:(NSURL *)url forString:(NSString *)key
{
    NSString *stringValue = [[_textView.textStorage attributedSubstringFromRange:NSMakeRange(0, _textView.string.length)] string];
    _textView.string = @"";
    if (stringValue.length == 0)
    {
        return;
    }
    NSRange keyRange = [stringValue rangeOfString:key];
    if (keyRange.location == NSNotFound) {
        return;
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:stringValue];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor] range:NSMakeRange(0, stringValue.length)];
    [attributeString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12] range:NSMakeRange(0, stringValue.length)];
    [attributeString addAttribute:NSLinkAttributeName value:url range:keyRange];
    [_textView.textStorage appendAttributedString:attributeString];
    
    [attributeString release];
}

@end
