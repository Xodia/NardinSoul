//
//  CollectionIcon.m
//  NardinSoul
//
//  Created by Morgan Collino on 09/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "CollectionIcon.h"

@implementation CollectionIcon

@synthesize key, path, img;

- (id) initWithPath:(NSString *)_path andKey:(NSString *)_key
{
    if (self = [super init])
    {
        key = [[NSString alloc] initWithString: _key];
        path =[[NSString alloc] initWithString: _path];
        
        img = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"no.jpg"]];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:  path]]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [img setImage: image];
                isLoad = YES;
            });
        });

    }
    return (self);
}

- (void) dealloc
{
    [path release];
    [key release];
    if (isLoad)
        [img release];
    [super dealloc];
}

@end
