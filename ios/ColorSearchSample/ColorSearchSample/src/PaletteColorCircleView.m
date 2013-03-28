//
//  PaletteColorCircleView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/27/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PaletteColorCircleView.h"

@implementation PaletteColorCircleView

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
		CGFloat radius = frame.size.width / 2;
		self.layer.cornerRadius = radius;
		self.backgroundColor = color;
    }
    return self;
}

@end
