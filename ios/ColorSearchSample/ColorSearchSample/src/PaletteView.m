//
//  PaletteView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/22/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "PaletteView.h"
#import "PaletteColorView.h"

@implementation PaletteView

#define COLOR(R, G, B)    [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

- (void)awakeFromNib {
	[super awakeFromNib];
	
	NSArray *colors = @[
		COLOR(157, 157, 157),
			 COLOR(190, 38, 51),
			 COLOR(224, 111, 139),
			 COLOR(73, 60, 43),
			 COLOR(164, 100, 34),
			 COLOR(235, 137, 49),
			 COLOR(247, 226, 107),
			 COLOR(47, 72, 78),
			 COLOR(68, 137, 26),
			 COLOR(163, 206, 39),
			 COLOR(27, 38, 50),
			 COLOR(0, 87, 132),
			 COLOR(49, 162, 242)
	];

	[colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {

			int row = idx / 2;
			int col = idx % 2;
			int y_margin = 50;
			int w = 50;
			int h = 50;
			int x = (160 - w) / 2 + ((col % 2) ? 160 : 0);
			int y = row * 100 + y_margin;
			PaletteColorView *pcv = [[[PaletteColorView alloc]
										 initWithFrame:CGRectMake(x, y, w, h)
											 baseColor:color
												center:YES] autorelease];

			// paletteSelected is implemented in ViewController
			// [btn addTarget:nil
			// 		action:@selector(colorSelected:)
			// 	 forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:pcv];
		}];	
}

@end
