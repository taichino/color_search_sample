//
//  MovingViewController.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/29/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "Common.h"
#import "MovingViewController.h"
#import "PhotoListViewController.h"

@interface MovingViewController ()

- (void)_start;
- (void)_stop;

@end


@implementation MovingViewController

- (void)awakeFromNib {
	[super awakeFromNib];

	self.title = @"Tap color ball :P";
	self.view.backgroundColor = [UIColor blackColor];
	
	self.movers = [NSMutableArray array];

	[[NSNotificationCenter defaultCenter]
			addObserverForName:kMoverSelectedNotification
						object:nil
						 queue:nil
					usingBlock:^(NSNotification *notif) {
			[self performSegueWithIdentifier:@"push_photolist_from_mover"
									  sender:notif.userInfo[@"color"]];
		}];
}

- (void)dealloc {
	self.timer = nil;
	self.movers = nil;
	self.mover = nil;
	[super dealloc];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIColor *)color {
	PhotoListViewController *vc = segue.destinationViewController;
	CIColor *cicolor = [[[CIColor alloc] initWithColor:color] _AR_];
	vc.title = [NSString stringWithFormat:@"%.2f %.2f %.2f", cicolor.red, cicolor.green, cicolor.blue];
	vc.targetColor = color;
}

- (void)_start {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30
												  target:self
												selector:@selector(timerProc:)
												userInfo:nil
												 repeats:YES];
	for (MovingObjectView *mover in self.movers) {
		[mover start];
	}
}

- (void)_stop {
	[self.timer invalidate];
	for (MovingObjectView *mover in self.movers) {
		[mover cancel];
		[mover removeFromSuperview];
	}
	self.movers = [NSMutableArray array];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self _start];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self _stop];
}


- (void)timerProc:(id)userInfo {
	static int idx = 1;
	static int curve = 68;
	static int baseAngle = 0;
	static int cnt = 70;
	
	for (MovingObjectView *mover in self.movers) {
		[mover proc];
	}

	baseAngle += 5;
	
	CGFloat angle = baseAngle * 2 * M_PI / 360.0;
	int x = 160 + 37 * cos(angle) / 10;
	int y = 160 - 298 * sin(angle) / 10;

	BOOL insert = NO;
	MovingObjectView *mover = nil;
	if ([self.movers count] >= idx) {
		mover = [self.movers objectAtIndex:idx-1];
		mover.cancel = YES;
		[mover removeFromSuperview];
		[self.movers removeObjectAtIndex:idx-1];
		insert = YES;
	}

	long long rgba = idx*(0xffffffff/11);
	CGFloat r = (rgba >> 24) & 0xff;
	CGFloat g = (rgba >> 16) & 0xff;
	CGFloat b = (rgba >> 8) & 0xff;
	// CGFloat a = (rgba >> 0) & 0xff;
	mover = [[[MovingObjectView alloc] initWithFrame:RECT(x, y, 30, 30) color:COLOR(r, g, b)] _AR_];
	mover.delegate = self;
	[mover start];
	[self.view addSubview:mover];
	if (insert) {
		[self.movers insertObject:mover atIndex:idx-1];
	}
	else {
		[self.movers addObject:mover];
	}

	mover.scale = (float)idx / 15.0;
	mover.rotation = (curve * idx) % 360;
	mover.alpha = idx / 100.0;

	if (idx > cnt) {
		idx = 1;
	}

	idx += 1;
}

@end
