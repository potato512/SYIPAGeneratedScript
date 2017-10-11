//
//  URLMatchControllerViewController.m
//  URLTextView
//
//  Created by Live365_Joni on 8/18/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "URLMatchController.h"

@interface URLMatchController ()

@end

@implementation URLMatchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self.view awakeFromNib];
        
    }
    return self;
}

-(void)awakeFromNib
{
    _textView.delegate = self;
}

-(void)matchURLTextStorage
{
    NSString *curString = _textView.string;
    if (curString != nil && ![curString isEqualToString:@""]) {
        NSError *error = NULL;
        NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        NSArray *matchs = [dataDetector matchesInString:curString options:0 range:NSMakeRange(0, [curString length])];
        [_textView.textStorage beginEditing];
        [_textView.textStorage removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [curString length])];
        [_textView.textStorage removeAttribute:NSLinkAttributeName range:NSMakeRange(0, [curString length])];
        for (NSTextCheckingResult *match in matchs){
            NSRange matchRange = [match range];
            if ([match resultType] ==NSTextCheckingTypeLink) {
                NSURL *url = [match URL];
                [_textView.textStorage addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[url absoluteString],NSLinkAttributeName, nil] range:matchRange];
            }
        }
        [_textView.textStorage endEditing];
    }
}

#pragma mark - 
#pragma mark - textView delegate

-(BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    //match url
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        usleep(500);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self matchURLTextStorage];
        });
    });
    return YES;
}


@end
