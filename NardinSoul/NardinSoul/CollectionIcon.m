//
//  CollectionIcon.m
//  NardinSoul
//
//  Created by Morgan Collino on 09/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "CollectionIcon.h"
#import "UIImage+XDShape.h"
#import "UIImageView_XDShape.h"

@implementation CollectionIcon

@synthesize key, path, img;

- (id)initWithPath:(NSString *)_path andKey:(NSString *)_key
{
    if (self = [super init])
    {
        key = [[NSString alloc] initWithString: _key];
        path =[[NSString alloc] initWithString: _path];
        
        img = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"no.jpg"]];
		
		__weak typeof(self)weakSelf = self;
		[UIImage loadFromURL:[NSURL URLWithString:path] callback:^(UIImage *iimage) {
			if (iimage) {
				[weakSelf.img setImage:iimage];
			} else {
				[weakSelf.img setImage: [UIImage imageNamed: @"no.jpg"]];
			}
			[weakSelf.img toRoundImageView];
			weakSelf.isLoad = YES;
		}];

		

    }
    return (self);
}


@end
