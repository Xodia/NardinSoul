//
//  NSContact.m
//  NardinSoul
//
//  Created by Morgan Collino on 27/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "NSContact.h"
#import "User.h"

@implementation NSContact
@synthesize login = _login, infos = _infos, img = _img;

- (id) initWithLogin: (NSString *) log andInfos: (NSMutableArray *) info
{
    if (self = [super init])
    {
        _login = [[NSString alloc] initWithString: log];
        _infos = [[NSMutableArray alloc] initWithArray: info copyItems: YES];
        [self loadImage];
    }
    return self;
}

- (id) initWithLogin: (NSString *) log
{
    if (self = [super init])
    {
        _login = [[NSString alloc] initWithString: log];
        _infos = [[NSMutableArray alloc] init];
        [self loadImage];
    }
    return self;
}

- (void) putConnection: (User *) connection
{
    for (User *u in _infos)
        if (connection.socket == u.socket)
            return;
    [_infos addObject: connection];
}

- (void) updateConnection:(User *)connection withNewStatus:(NSString *)status
{
    for (User *u in _infos)
    {
        if (u.socket == connection.socket && [u.login isEqualToString: connection.login])
        {
            [[u status] release];
            [u setStatus: [[NSString alloc] initWithString: status]];
        }
    }
}

- (void) removeConnection:(User *)connection
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
        
    for (User *u in _infos)
    {
        if (u.socket == connection.socket)
        {
            [arr addObject:u];
        }
    }
        
        
    for (User *u in arr)
        [_infos removeObject: u];
}

- (void) flush
{
    [_infos removeAllObjects];
}

- (void) loadImage
{
    _img = [UIImage imageNamed: @"no.jpg"];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        
        UIImage *image = [[UIImage alloc ] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://www.epitech.eu/intra/photos/%@.jpg", _login]]]];

        NSLog(@"Login: %@", _login);
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (image)
            {
                _img = [image retain];
                [image release];
                imgLoaded = YES;
            }
            else
            {
                _img = [UIImage imageNamed: @"no.jpg"];
                imgLoaded = YES;
            }
        });
    });
}

- (BOOL) isImageLoaded
{
    return imgLoaded;
}

- (void) dealloc
{
    NSLog(@"Dealloc NScontact :%@", _login);
    [_login release];
    [_infos release];
    [super dealloc];
}
@end
