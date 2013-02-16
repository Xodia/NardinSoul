//
//  CollectionIcon.m
//  NardinSoul
//
//  Created by Morgan Collino on 09/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "CollectionIcon.h"

@implementation CollectionIcon

@synthesize key, path;

- (id) initWithPath:(NSString *)_path andKey:(NSString *)_key
{
    if (self = [super init])
    {
        key = [[NSString alloc] initWithString: _key];
        path =[[NSString alloc] initWithString: _path];
    }
    return (self);
}

- (void) dealloc
{
    [path release];
    [key release];
    [super dealloc];
}

@end
