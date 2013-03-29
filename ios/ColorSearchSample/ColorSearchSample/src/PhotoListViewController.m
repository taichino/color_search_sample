//
//  PhotoListViewController.m
//  ColorSearchSample
//
//  Created by Matsumoto Taichi on 3/22/13.
//  Copyright (c) 2013 Matsumoto Taichi. All rights reserved.
//

#import "PhotoListViewController.h"
#import "AFNetworking/AFNetworking.h"

@interface PhotoListViewController (Private)

- (NSDictionary *)_colorParams;
- (void)_load;

@end

@implementation PhotoListViewController

- (void)dealloc {
	self.targetColor = nil;
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self _load];
}

- (NSDictionary *)_colorParams {
	if (!self.targetColor) return nil;

	CGFloat red, green, blue, alpha;
	BOOL res = [self.targetColor getRed:&red green:&green blue:&blue alpha:&alpha];
	if (!res) return nil;

	return @{
		@"R": [NSNumber numberWithInteger:red * 255],
		@"G": [NSNumber numberWithInteger:green * 255],
		@"B": [NSNumber numberWithInteger:blue * 255],
		@"A": [NSNumber numberWithInteger:alpha * 255]
	};
}

- (void)_load {
	NSURL *url = [NSURL URLWithString:@"http://localhost:8000"];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
	
	NSMutableURLRequest *request = [client requestWithMethod:@"GET"
														path:@"/mono/"
												  parameters:[self _colorParams]];
	AFJSONRequestOperation *operation =
		[AFJSONRequestOperation
			JSONRequestOperationWithRequest:request
			success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
				NSArray *photoList = JSON;
				__block int curY1 = 0, curY2 = 0;
				int MARGIN = 5;
				[photoList enumerateObjectsUsingBlock:^(NSDictionary *props, NSUInteger idx, BOOL *stop) {
						NSString *path = props[@"path"];
						NSNumber *width = props[@"width"];
						NSNumber *height = props[@"height"];
						
						int col = idx % 2;
						int x = ((col == 0) ? 0 : 160) + MARGIN;
						int y = ((col == 0) ? curY1 : curY2) + MARGIN;
						int w = [width intValue];
						int h = [height intValue];
						CGFloat factor = (160.0 - MARGIN * 2) / w;
						w = 160.0 - MARGIN * 2;
						h = h * factor;
						
						NSString *imageURL = [NSString stringWithFormat:@"http://localhost:8000/%@", path];
						UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
						NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
						[imageView setImageWithURLRequest:request
										 placeholderImage:nil
						  success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image) {
								CGSize newSize = CGSizeMake(w, h);
								UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
								[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
								UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
								UIGraphicsEndImageContext();
								
								dispatch_async(dispatch_get_main_queue(),^ {
										imageView.image = small;
									});
							}
						  failure: ^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error) {
								// just a sample code :P
							}];
						[self.view addSubview:imageView];

						if (col == 0) {
							curY1 += (h + MARGIN);
						}
						else {
							curY2 += (h + MARGIN);
						}
					}];
				((UIScrollView *)self.view).contentSize = CGSizeMake(320, MAX(curY1, curY2));
			}
		    failure:^( NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
				NSLog(@"failed");
			}];

	[operation start];		
}

@end
