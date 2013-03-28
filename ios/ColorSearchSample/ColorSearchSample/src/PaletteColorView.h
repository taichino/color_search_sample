//
//  PaletteColorView.h
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/26/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaletteColorView : UIView

@property (nonatomic, retain) UIColor *baseColor;
@property (nonatomic, retain) PaletteColorView *centerCircle;
@property (nonatomic, retain) NSArray *gradationViews;
@property (nonatomic, assign) BOOL center;

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor center:(BOOL)center;

@end
