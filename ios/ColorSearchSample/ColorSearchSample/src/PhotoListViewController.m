//
//  PhotoListViewController.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/22/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "PhotoListViewController.h"
#import "AFNetworking/AFNetworking.h"

@implementation PhotoListViewController

- (void)dealloc {
	self.targetColor = nil;
	[super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"%@", self.targetColor);

	NSURL *url = [NSURL URLWithString:@"http://localhost:8000/mono/"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	AFJSONRequestOperation *operation =
		[AFJSONRequestOperation
			JSONRequestOperationWithRequest:request
									success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
				NSArray *photoList = JSON;
				for (NSString *path in photoList) {
					NSLog(@"%@", path);
				}
		} failure:nil];

	[operation start];		
}

@end
