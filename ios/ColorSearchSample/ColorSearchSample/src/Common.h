//
//  Common.h
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/28/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define COLOR(R, G, B)    [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define RECT(x, y, w, h)  CGRectMake(x, y, w, h)
#define _AR_               autorelease

extern NSString * const kColorSelectedNotification;
extern NSString * const kMoverSelectedNotification;

