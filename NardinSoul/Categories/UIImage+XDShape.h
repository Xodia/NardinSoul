//
//  UIImage+XDShape.h
//  NardinSoul
//
//  Created by Morgan Collino on 2/26/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XDShape)
+ (void)loadFromURL:(NSURL*)url callback:(void (^)(UIImage *image))callback;
@end
