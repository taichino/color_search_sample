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

	NSURL *url = [NSURL URLWithString:@"http://localhost:8000/mono/"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	AFJSONRequestOperation *operation =
		[AFJSONRequestOperation
			JSONRequestOperationWithRequest:request
			success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
				NSArray *photoList = JSON;
				[photoList enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL *stop) {
						int row = idx / 3, col = idx % 3;
						int x = col * 100;
						int y = row * 100;
						NSString *imageURL = [NSString stringWithFormat:@"http://localhost:8000%@", path];
						UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 100, 100)];
						[imageView setImageWithURL:[NSURL URLWithString:imageURL]];
						[self.view addSubview:imageView];
					}];
			}
		    failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ) {
				NSLog(@"failed");
			}];

	[operation start];		
}

@end
