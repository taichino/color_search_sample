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
@property (nonatomic, retain) NSArray *gradationColors;

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor;

@end
