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
		COLOR(190, 38, 51),
		COLOR(224, 111, 139),
		COLOR(235, 137, 49),
		COLOR(247, 226, 107),
		COLOR(68, 137, 26),
		COLOR(163, 206, 39),
		COLOR(140, 44, 181),
		COLOR(49, 162, 242),
	];

	__block int height = 0;
	[colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {

			int row = idx / 2;
			int col = idx % 2;
			int y_margin = 50;
			int w = 40;
			int h = 40;
			int x = (160 - w) / 2 + ((col % 2) ? 160 : 0);
			int y = row * 100 + y_margin;
			PaletteColorView *pcv = [[[PaletteColorView alloc]
										 initWithFrame:CGRectMake(x, y, w, h)
											 baseColor:color] autorelease];
			pcv.delegate = self;
			[self addSubview:pcv];

			height = y + h;
		}];

	self.backgroundColor = [UIColor blackColor];
	self.contentSize = CGSizeMake(320, height + 60);
}

- (void)shrinkAll {
	for (UIView *view in [self subviews]) {
		if ([view isKindOfClass:[PaletteColorView class]]) {
			[(PaletteColorView *)view shrink];
		}
	}
}

- (void)paletteColorViewTouchesBegan:(PaletteColorView *)pcv {
	self.scrollEnabled = NO;
}

- (void)paletteColorViewTouchesEnded:(PaletteColorView *)pcv {
	self.scrollEnabled = YES;
}


@end
