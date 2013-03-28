//
//  PaletteColorView.h
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/26/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaletteColorCircleView.h"


@interface PaletteColorView : UIView

@property (nonatomic, retain) UIColor *baseColor;
@property (nonatomic, retain) NSArray *gradationViews;

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor;

@end
