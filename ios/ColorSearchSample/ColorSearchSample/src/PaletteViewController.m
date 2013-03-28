//
//  PaletteViewController.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/22/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "PaletteViewController.h"
#import "AFNetWorking.h"
#import "PhotoListViewController.h"
#import "PaletteView.h"
#import "Common.h"

@implementation PaletteViewController

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if (self) {
		self.title = @"Select Color";
		[[NSNotificationCenter defaultCenter]
			addObserverForName:kColorSelectedNotification
						object:nil
						 queue:nil
					usingBlock:^(NSNotification *notif) {
				[self performSegueWithIdentifier:@"push_photolist"
										  sender:notif.userInfo[@"color"]];
			}];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIColor *)color {
	PhotoListViewController *vc = segue.destinationViewController;
	vc.targetColor = color;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[(PaletteView *)self.view shrinkAll];
}

@end
