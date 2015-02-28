//
//  UIImage+XDShape.m
//  NardinSoul
//
//  Created by Morgan Collino on 2/26/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "UIImage+XDShape.h"

@implementation UIImage (XDShape)

+ (void)loadFromURL:(NSURL*)url callback:(void (^)(UIImage *image))callback {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSData * imageData = [NSData dataWithContentsOfURL:url];
		dispatch_async(dispatch_get_main_queue(), ^{
			UIImage *image = [UIImage imageWithData:imageData];
			callback(image);
		});
	});
}

@end
