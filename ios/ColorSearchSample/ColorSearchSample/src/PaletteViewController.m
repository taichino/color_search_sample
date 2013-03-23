//
//  PaletteViewController.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/22/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "PaletteViewController.h"
#import "AFNetWorking.h"


@implementation PaletteViewController

- (void)colorSelected:(UIButton *)sender {
	UIColor *color = sender.backgroundColor;
	NSLog(@"%@", color);

	NSURL *url = [NSURL URLWithString:@"http://httpbin.org/ip"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	AFJSONRequestOperation *operation =
		[AFJSONRequestOperation
			JSONRequestOperationWithRequest:request
									success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
			NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
		} failure:nil];

	[operation start];	
}

@end
