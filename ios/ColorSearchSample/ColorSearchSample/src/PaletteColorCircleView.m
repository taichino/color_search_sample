//
//  PaletteColorCircleView.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/27/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "Common.h"
#import "PaletteColorCircleView.h"

@implementation PaletteColorCircleView

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
		CGFloat radius = frame.size.width / 2;
		self.layer.cornerRadius = radius;
		self.layer.shadowOffset = CGSizeMake(0, 4.0);
		self.layer.shadowColor = [UIColor whiteColor].CGColor;
		self.backgroundColor = color;
		self.color = color;

		[self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"selected"];
	self.color = nil;
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	if ([keyPath isEqualToString:@"selected"]) {
		if (self.selected) {
			self.layer.shadowOpacity = 0.3;
		}
		else {
			self.layer.shadowOpacity = 0.0;
		}
	}
}



@end
