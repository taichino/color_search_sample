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


@implementation PaletteViewController

- (void)colorSelected:(UIButton *)sender {
	[self performSegueWithIdentifier:@"push_photolist" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
	PhotoListViewController *vc = segue.destinationViewController;
	vc.targetColor = sender.backgroundColor;
}


@end
