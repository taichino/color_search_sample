//
//  MovingViewController.h
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/29/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovingObjectView.h"

@interface MovingViewController : UIViewController

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSMutableArray *movers;
@property (nonatomic, retain) MovingObjectView *mover;

@end
