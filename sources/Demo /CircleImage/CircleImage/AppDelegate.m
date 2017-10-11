//
//  AppDelegate.m
//  CircleImage
//
//  Created by Live365_Joni on 8/19/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "AppDelegate.h"
#import "Image+Circle.h"
@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSImage *image = [NSImage imageNamed:@"albumCover_default"];
    NSImage *cirImage = [image circleImage];
    if (cirImage) {
        [self.cirImageView setImage:cirImage];
    }
    
    NSImage *hImage = [[NSImage imageNamed:@"111"] roundedCornersImage];
    [self.hImageView setImage:hImage];
    
    NSImage *vImage = [[NSImage imageNamed:@"222"] roundedCornersImage];
    [self.vImageView setImage:vImage];

}

@end
