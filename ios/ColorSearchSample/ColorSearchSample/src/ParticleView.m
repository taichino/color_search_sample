//
//  ParticleView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 4/4/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "ParticleView.h"

@implementation ParticleView

const NSInteger BallBaseSize = 10;

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
		self.color = color;
		CGRect rect1 = RECT(0, 0, BallBaseSize, BallBaseSize);
		CGRect rect2 = RECT(CGRectGetMaxX(self.bounds) - BallBaseSize,
							CGRectGetMaxY(self.bounds) - BallBaseSize,
							BallBaseSize,
							BallBaseSize);
		self.ball1 = [[[UIView alloc] initWithFrame:rect1] _AR_];
		self.ball2 = [[[UIView alloc] initWithFrame:rect2] _AR_];
		self.ball1.backgroundColor = color;
		self.ball2.backgroundColor = color;
		self.ball1.layer.cornerRadius = BallBaseSize / 2;
		self.ball2.layer.cornerRadius = BallBaseSize / 2;
		[self addSubview:self.ball1];
		[self addSubview:self.ball2];
    }
    return self;
}

- (void)dealloc {
	self.ball1 = nil;
	self.ball2 = nil;
	self.color = nil;
	[super dealloc];
}

- (void)doAnimation {
	CGFloat duration = 1.6;
	CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.duration = duration;
	scaleAnimation.values = @[@1.0, @0.0, @1.0];
	CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.duration = duration;
	rotateAnimation.values = @[@0.0, @(2*M_PI), @(-2*M_PI)];
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.duration = duration;
	[group setAnimations:@[scaleAnimation, rotateAnimation]];
	group.delegate = self;
	[self.layer addAnimation:group forKey:@"test"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
	if (!self.cancel) {
		[self doAnimation];
	}
}


@end
