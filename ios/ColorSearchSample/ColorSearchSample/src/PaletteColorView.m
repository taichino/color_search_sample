//
//  PaletteColorView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/26/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#include <dispatch/dispatch.h>
#import "PaletteColorView.h"
#import "UIColor+Gradation.h"

@interface PaletteColorView (Private)

- (void)_expand;
- (void)_shrink;

@end

@implementation PaletteColorView

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor center:(BOOL)center {
    self = [super initWithFrame:frame];
    if (self) {
		self.center = center;
		self.baseColor = baseColor;
		
		CGFloat radius = frame.size.width / 2;
		self.layer.cornerRadius = radius;
		self.backgroundColor = self.baseColor;
		NSArray *gradationColors = [self.baseColor gradationColors];

		if (self.center) {
			self.centerCircle = [[[PaletteColorView alloc]
												  initWithFrame:self.bounds
													  baseColor:self.baseColor
														 center:NO] autorelease];
			[self addSubview:self.centerCircle];
			
			NSMutableArray *gradationViews = [NSMutableArray array];
			for (UIColor *color in gradationColors) {
				PaletteColorView *view = [[[PaletteColorView alloc]
											  initWithFrame:self.bounds
												  baseColor:color
													 center:NO] autorelease];
				[self insertSubview:view belowSubview:self.centerCircle];
				[gradationViews addObject:view];
			}
			self.gradationViews = gradationViews;
		}
    }
    return self;
}

- (void)dealloc {
	self.baseColor = nil;
	self.centerCircle = nil;
	self.gradationViews = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark - UIView
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"began");
	
	if (!self.center) {
		[self.superview touchesBegan:touches withEvent:event];
		return;
	}

	[self _expand];
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"end");
	if (!self.center) {
		[self.superview touchesEnded:touches withEvent:event];
		return;
	}

	[self _shrink];
}

#pragma mark
#pragma mark Private methods
#pragma mark

- (void)_expand {
	int startX = CGRectGetMidX(self.bounds);
	int startY = CGRectGetMidY(self.bounds);
	int R = 60;
	int relayR = 80;
	int viewCount = [self.gradationViews count];
	for (int i = 0; i < viewCount; i++) {
		UIView *view = [self.gradationViews objectAtIndex:i];
		CGFloat rad = i * 2 * M_PI / (float)viewCount;
		int targetX = startX + R * cosf(rad);
		int targetY = startY - R * sinf(rad);
		int relayX  = startX + relayR * cosf(rad);
		int relayY  = startY - relayR * sinf(rad);

		CAKeyframeAnimation *posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		posAnim.duration = 0.3;
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, startX, startY);
		CGPathAddLineToPoint(path, NULL, relayX, relayY);
		CGPathAddLineToPoint(path, NULL, targetX, targetY);
		posAnim.path = path;
		CGPathRelease(path);

		view.layer.position = CGPointMake(targetX, targetY);
		[view.layer addAnimation:posAnim forKey:nil];
	}
}

- (void)_shrink {
	int targetX = CGRectGetMidX(self.bounds);
	int targetY = CGRectGetMidY(self.bounds);
	
	int relayR = 10;
	int viewCount = [self.gradationViews count];
	for (int i = 0; i < viewCount; i++) {
		UIView *view = [self.gradationViews objectAtIndex:i];
		CGFloat rad = i * 2 * M_PI / (float)viewCount;
		int startX = CGRectGetMidX(view.frame);
		int startY = CGRectGetMidY(view.frame);
		int relayX = startX + relayR * cosf(rad);
		int relayY = startY - relayR * sinf(rad);

		CAKeyframeAnimation *posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		posAnim.duration = 0.3;
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, startX, startY);
		CGPathAddLineToPoint(path, NULL, relayX, relayY);
		CGPathAddLineToPoint(path, NULL, targetX, targetY);
		posAnim.path = path;
		CGPathRelease(path);

		view.layer.position = CGPointMake(targetX, targetY);
		[view.layer addAnimation:posAnim forKey:nil];
	}	
}

@end
