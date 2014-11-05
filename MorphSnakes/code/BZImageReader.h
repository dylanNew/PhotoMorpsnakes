//
//  BZImageReader.h
//  MorphSnakes
//
//  Created by myname on 14-11-5.
//  Copyright (c) 2014年 Bouzou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BZColorPixel.h"

@interface BZImageReader : NSObject
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, assign) unsigned char *imgPixel;

- (UIColor *)getColorAtPoint:(CGPoint)apoint;
- (int)getRAtPoint:(CGPoint)apoint;
- (int)getGAtPoint:(CGPoint)apoint;
- (int)getBAtPoint:(CGPoint)apoint;
- (BZColorPixel *)getColorPixelAtPoint:(CGPoint)apoint;

+ (UIImage *)imageWithPixel:(unsigned char *)pixel
                      width:(CGFloat)w
                     height:(CGFloat)h;
- (UIImage *)getGrayImage;
@end

