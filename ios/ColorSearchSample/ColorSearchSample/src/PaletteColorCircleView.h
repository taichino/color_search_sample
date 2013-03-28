//
//  PaletteColorCircleView.h
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/27/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaletteColorCircleView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) UIColor *color;
- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;

@end
