//
//  MovingObjectView.h
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/29/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParticleView.h"

@interface MovingObjectView : UIView

@property (nonatomic, retain) UIView *wrapper;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) BOOL cancel;
@property (nonatomic, retain) UIView *animView;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) ParticleView *particle;

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;
- (void)proc;
- (void)start;

@end
