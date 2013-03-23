//
//  PaletteView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/22/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "PaletteView.h"

@implementation PaletteView

#define COLOR(R, G, B)    [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

- (void)awakeFromNib {
	[super awakeFromNib];
	
	NSArray *colors = @[
		COLOR(0, 0, 0),
			 COLOR(157, 157, 157),
			 COLOR(255, 255, 255)
	];

	[colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			int row = idx / 3, col = idx % 3;
			int x = col * 100, y = row * 100;
			int w = 100, h = 100;
			btn.frame = CGRectMake(x, y, w, h);
			btn.backgroundColor = color;

			// paletteSelected is implemented in ViewController
			[btn addTarget:nil
					action:@selector(colorSelected:)
				 forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:btn];
		}];	
}

@end
