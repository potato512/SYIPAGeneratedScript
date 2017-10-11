//
//  Image+Circle.m
//  JLMediaManager
//
//  Created by Live365_Joni on 8/19/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "Image+Circle.h"

@implementation NSImage(CircleImage)
-(NSImage *)circleImage
{
    CGFloat w = self.size.width;
    CGFloat h  = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextScaleCTM(context, w/2.0, h/2.0);
    CGContextMoveToPoint(context, 2, 1);
    //曲线
//    CGContextAddQuadCurveToPoint(context, 2, 2, 1, 2);
//    CGContextAddQuadCurveToPoint(context, 0, 2, 0, 1);
//    CGContextAddQuadCurveToPoint(context, 0, 0, 1, 0);
//    CGContextAddQuadCurveToPoint(context, 2, 0, 2, 1);
    //圆形
    CGContextAddArcToPoint(context, 2, 2, 1, 2, 1);//current point is (1,2)
    CGContextAddArcToPoint(context, 0, 2, 0, 1, 1);//current point is (0,1)
    CGContextAddArcToPoint(context, 0, 0, 1, 0, 1);//current point is (1,0)
    CGContextAddArcToPoint(context, 2, 0, 2, 1, 1);
    
//other
//    CGContextMoveToPoint(context, 1, 2);
//    CGContextAddArcToPoint(context, 0, 2, 0, 1, 1);
//    CGContextAddArcToPoint(context, 0, 0, 1, 0, 1);
//    CGContextAddArcToPoint(context, 2, 0, 2, 1, 1);
//    CGContextAddArcToPoint(context, 2, 2, 1, 2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    CGContextClip(context);
    
    CGImageRef cgImage = [[NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]] CGImage];
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), cgImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    NSImage *tmpImage = [[NSImage alloc] initWithCGImage:imageMasked size:self.size];
    NSData *imageData = [tmpImage TIFFRepresentation];
    //TODO:memory leak - the obj(NSImage) image alloc, need call autoRelease method.
    NSImage *image = [[NSImage alloc] initWithData:imageData];
    [tmpImage release];
    
    return image;
}

-(NSImage *)roundedCornersImage
{
    CGFloat w = self.size.width;
    CGFloat h  = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    float num_x = 0.0;
    float num_y = 0.0;
    if (w>h) {
        num_x = 9.0;
        num_y = h/(w/num_x);
    }
    else{
        num_y = 9.0;
        num_x = w/(h/num_y);
    }
    CGContextScaleCTM(context, w/num_x, h/num_y);
    CGContextMoveToPoint(context, num_x, num_y-1);
    CGContextAddArcToPoint(context, num_x, num_y, num_x-1, num_y, 1);
    CGContextAddLineToPoint(context, 1, num_y);
    CGContextAddArcToPoint(context, 0, num_y, 0, num_y-1, 1);
    CGContextAddLineToPoint(context, 0, 1);
    CGContextAddArcToPoint(context, 0, 0, 1, 0, 1);
    CGContextAddLineToPoint(context, num_x-1, 0);
    CGContextAddArcToPoint(context, num_x, 0, num_x, 1, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    CGContextClip(context);
    
    CGImageRef cgImage = [[NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]] CGImage];
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), cgImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    NSImage *tmpImage = [[NSImage alloc] initWithCGImage:imageMasked size:self.size];
    NSData *imageData = [tmpImage TIFFRepresentation];
    //TODO:memory leak - the obj(NSImage) image alloc, need call autoRelease method.
    NSImage *image = [[NSImage alloc] initWithData:imageData];
    [tmpImage release];
    
    return image;
}
@end
