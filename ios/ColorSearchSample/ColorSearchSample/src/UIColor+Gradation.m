//
//  UIColor+Gradation.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/26/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "UIColor+Gradation.h"

@implementation UIColor (Gradation)

- (NSArray *)gradationColors {
	const NSInteger NUM = 3;
	
	CGFloat hue = 0, saturation = 0, brightness = 0, alpha = 0;
	BOOL res = [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	if (!res) return nil;

	if (brightness == 0) brightness = 0.0001;
	if (saturation == 0) saturation = 0.0001;

	// shifting brightness to make darker colors	
	NSMutableArray *colors = [NSMutableArray array];
	for (CGFloat b = 0; b < brightness; b += brightness / NUM) {
		UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:b alpha:alpha];
		[colors addObject:color];
	}

	// shifting saturation to make light colors	
	for (CGFloat s = saturation; s >= 0; s -= saturation / NUM) {
		UIColor *color = [UIColor colorWithHue:hue saturation:s brightness:brightness alpha:alpha];
		[colors addObject:color];
	}
	[colors removeObjectAtIndex:0];
	
	return colors;
}

@end
