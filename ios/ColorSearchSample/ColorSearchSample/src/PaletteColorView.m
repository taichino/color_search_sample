//
//  PaletteColorView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/26/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "PaletteColorView.h"
#import "PaletteColorCircleView.h"
#import "UIColor+Gradation.h"

@interface PaletteColorView (Private)

- (void)_expand;
- (void)_shrink;
- (void)_go;

@end

@implementation PaletteColorView

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor {
    self = [super initWithFrame:frame];
    if (self) {
		self.baseColor = baseColor;
		NSMutableArray *gradationViews = [NSMutableArray array];
		
		NSArray *gradationColors = [self.baseColor gradationColors];
		PaletteColorCircleView *centerCircle =
			[[[PaletteColorCircleView alloc] initWithFrame:self.bounds
													 color:self.baseColor] autorelease];
		[self addSubview:centerCircle];
		[gradationViews addObject:centerCircle];
			
		for (UIColor *color in gradationColors) {
			PaletteColorCircleView *view =
				[[[PaletteColorCircleView alloc] initWithFrame:self.bounds
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
	self.selectedCircleView = nil;
	self.animView = nil;
	[super dealloc];
}

- (void)setSelectedCircleView:(PaletteColorCircleView *)newObj {
	if (_selectedCircleView != newObj) {
		PaletteColorCircleView *oldObj = _selectedCircleView;
		if (oldObj) {
			oldObj.selected = NO;
		}
		_selectedCircleView = [newObj retain];
		if (_selectedCircleView) {
			_selectedCircleView.selected = YES;
		}
		[oldObj release];
	}
}

- (void)shrink {
	if (self.selectedCircleView) {
		[self _shrink];
	}
}


#pragma mark -
#pragma mark - UIResponder
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _expand];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	for (PaletteColorCircleView *subview in self.gradationViews) {
		BOOL selected = [subview pointInside:[touch locationInView:subview] withEvent:event];
		if (selected) {
			self.selectedCircleView = subview;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.selectedCircleView) {
		NSLog(@"selected");
		[self _go];
	}
	else {
		[self _shrink];
	}
}

#pragma mark -
#pragma mark - Animations
#pragma mark -

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
	[self.animView removeFromSuperview];
	self.animView = nil;

	[[NSNotificationCenter defaultCenter]
			postNotificationName:kColorSelectedNotification
						  object:self
						userInfo:@{@"color":self.selectedCircleView.color}];	
}

- (void)_go {
	if (!self.selectedCircleView) return;

	self.animView = [[[UIView alloc] initWithFrame:self.selectedCircleView.frame] autorelease];
	self.animView.backgroundColor = self.selectedCircleView.color;
	[self addSubview:self.animView];

	CABasicAnimation *sizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
	CGSize initialSize = self.animView.bounds.size;	
	sizeAnimation.duration = 0.3;
	CGFloat factor = 20;
	[sizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(initialSize.width * factor,
																  initialSize.height * factor)]];

	CABasicAnimation *opacAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacAnimation.duration = 0.3;
	[opacAnimation setToValue:[NSNumber numberWithFloat:0.1]];

	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.duration = 0.3;
	group.delegate = self;
	[group setAnimations:[NSArray arrayWithObjects:opacAnimation, sizeAnimation, nil]];
	
	[self.animView.layer addAnimation:group forKey:nil];
}

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

		CAKeyframeAnimation *posAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		posAnimation.duration = 0.3;
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, startX, startY);
		CGPathAddLineToPoint(path, NULL, relayX, relayY);
		CGPathAddLineToPoint(path, NULL, targetX, targetY);
		posAnimation.path = path;
		CGPathRelease(path);

		view.layer.position = CGPointMake(targetX, targetY);
		[view.layer addAnimation:posAnimation forKey:nil];
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

		CAKeyframeAnimation *posAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		posAnimation.duration = 0.3;
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, startX, startY);
		CGPathAddLineToPoint(path, NULL, relayX, relayY);
		CGPathAddLineToPoint(path, NULL, targetX, targetY);
		posAnimation.path = path;
		CGPathRelease(path);

		view.layer.position = CGPointMake(targetX, targetY);
		[view.layer addAnimation:posAnimation forKey:nil];
	}
	self.selectedCircleView = nil;
}

@end
