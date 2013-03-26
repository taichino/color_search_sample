//
//  PaletteColorView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/26/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PaletteColorView.h"
#import "UIColor+Gradation.h"

@implementation PaletteColorView

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor
{
    self = [super initWithFrame:frame];
    if (self) {
		self.baseColor = baseColor;
		CGFloat radius = frame.size.width / 2;
		self.layer.cornerRadius = radius;
		self.backgroundColor = self.baseColor;
		self.gradationColors = [self.baseColor gradationColors];
    }
    return self;
}

- (void)dealloc {
	self.baseColor = nil;
	self.gradationColors = nil;
	[super dealloc];
}

@end
