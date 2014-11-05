//
//  BZColorPixel.h
//  MorphSnakes
//
//  Created by myname on 14-11-5.
//  Copyright (c) 2014年 Bouzou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZColorPixel : NSObject
@property (nonatomic, assign) int r;
@property (nonatomic, assign) int g;
@property (nonatomic, assign) int b;
//unknown
@property (nonatomic, assign) int a;

- (instancetype)initWithr:(int)r g:(int)g b:(int)b a:(int)a;

@end
