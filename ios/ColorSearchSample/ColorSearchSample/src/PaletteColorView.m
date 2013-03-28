//
//  PaletteColorView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/26/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PaletteColorView.h"
#import "PaletteColorCircleView.h"
#import "UIColor+Gradation.h"

@interface PaletteColorView (Private)

- (void)_expand;
- (void)_shrink;

@end

@implementation PaletteColorView

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor {
    self = [super initWithFrame:frame];
    if (self) {
		self.baseColor = baseColor;
		NSMutableArray *gradationViews = [NSMutableArray array];
		
		NSArray *gradationColors = [self.baseColor gradationColors];
		PaletteColorCircleView *centerCircle = [[[PaletteColorCircleView alloc] initWithFrame:self.bounds
																						color:self.baseColor] autorelease];
		[self addSubview:centerCircle];
		[gradationViews addObject:centerCircle];
			
		for (UIColor *color in gradationColors) {
			PaletteColorCircleView *view = [[[PaletteColorCircleView alloc] initWithFrame:self.bounds
																					color:color] autorelease];
			[self insertSubview:view belowSubview:centerCircle];
			[gradationViews addObject:view];
		}
		self.gradationViews = gradationViews;

    }
    return self;
}

- (void)dealloc {
	self.baseColor = nil;
	self.gradationViews = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark - UIResponder
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"began");
	[self _expand];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	for (UIView *subview in self.gradationViews) {
		if ([subview pointInside:[touch locationInView:subview] withEvent:event]) {
			subview.layer.shadowOpacity = 0.3;
			subview.layer.shadowOffset = CGSizeMake(0, 4.0);
		}
		else {
			subview.layer.shadowOpacity = 0.0;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"ended");
	[self _shrink];
}

#pragma mark -
#pragma mark - Private methods
#pragma mark -

- (void)_expand {
	int startX = CGRectGetMidX(self.bounds);
	int startY = CGRectGetMidY(self.bounds);
	int R = 50;
	int relayR = 65;
	int viewCount = [self.gradationViews count];
	for (int i = 1; i < viewCount; i++) {
		UIView *view = [self.gradationViews objectAtIndex:i];
		CGFloat rad = i * 2 * M_PI / (float)(viewCount - 1);
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
	for (int i = 1; i < viewCount; i++) {
		UIView *view = [self.gradationViews objectAtIndex:i];
		CGFloat rad = i * 2 * M_PI / (float)(viewCount - 1);
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
