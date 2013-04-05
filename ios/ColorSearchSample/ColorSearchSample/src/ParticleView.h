//
//  ParticleView.h
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 4/4/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface ParticleView : UIView

@property (nonatomic, retain) UIView *ball1;
@property (nonatomic, retain) UIView *ball2;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) BOOL cancel;

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;
- (void)doAnimation;

@end
