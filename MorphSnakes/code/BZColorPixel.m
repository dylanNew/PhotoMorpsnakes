//
//  BZColorPixel.m
//  MorphSnakes
//
//  Created by myname on 14-11-5.
//  Copyright (c) 2014年 Bouzou. All rights reserved.
//

#import "BZColorPixel.h"

@implementation BZColorPixel

- (instancetype)initWithr:(int)r g:(int)g b:(int)b a:(int)a
{
    self = [super init];
    if (self)
    {
        self.r = r;
        self.g = g;
        self.b = b;
        self.a = a;
    }
    return self;
}

@end
