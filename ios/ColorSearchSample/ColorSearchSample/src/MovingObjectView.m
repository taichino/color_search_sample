//
//  MovingObjectView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/29/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "Common.h"
#import "MovingObjectView.h"

@interface MovingObjectView ()

- (void)_go;

@end

@implementation MovingObjectView

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
		self.rotation = 0;
		self.scale = 1.0;

		self.color = color;
		self.wrapper = [[[UIView alloc] initWithFrame:self.bounds] _AR_];
		[self addSubview:self.wrapper];

		self.particle = [[[ParticleView alloc] initWithFrame:self.bounds color:color] _AR_];
		[self.wrapper addSubview:self.particle];
    }
    return self;
}

- (void)dealloc {
	self.wrapper = nil;
	self.animView = nil;
	self.color = nil;
	self.delegate = nil;
	self.particle = nil;
	[super dealloc];
}

- (void)start {
	self.cancel = NO;
	[self.particle doAnimation];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
	[[NSNotificationCenter defaultCenter]
			postNotificationName:kMoverSelectedNotification
						  object:self
						userInfo:@{@"color":self.color}];
}

- (void)proc {
	int _x = CGRectGetMidX(self.frame);
	int _y = CGRectGetMidY(self.frame);
	int moveX = (_x < 37) ? 2 : -1;
	int moveY = (_y < 298) ? 2 : -1;
	self.rotation += 1;
	
	CGAffineTransform rotate = CGAffineTransformMakeRotation(self.rotation * 2 * M_PI / 360.0);
	CGAffineTransform scale = CGAffineTransformMakeScale(self.scale, self.scale);
	self.wrapper.transform = CGAffineTransformConcat(scale, rotate);
	
	CGRect frame = self.frame;
	frame.origin = CGPointMake(frame.origin.x + moveX, frame.origin.y + moveY);
	self.frame = frame;
}

#pragma mark -
#pragma mark - UIResponder
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _go];
}

- (void)_go {
	self.animView = [[[UIView alloc] initWithFrame:self.frame] _AR_];
	self.animView.backgroundColor = self.color;
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
	[group setAnimations:@[opacAnimation, sizeAnimation]];
	[group setValue:@"go" forKey:@"key"];
	
	[self.animView.layer addAnimation:group forKey:nil];
}


@end
