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
@synthesize login = _login, infos = _infos;

- (id) initWithLogin: (NSString *) log andInfos: (NSMutableArray *) info
{
    if (self = [super init])
    {
        _login = [[NSString alloc] initWithString: log];
        _infos = [[NSMutableArray alloc] initWithArray: info copyItems: YES];
    }
    return self;
}

- (id) initWithLogin: (NSString *) log
{
    if (self = [super init])
    {
        _login = [[NSString alloc] initWithString: log];
        _infos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) putConnection: (User *) connection
{
    for (User *u in _infos)
    {
        if (u.socket == connection.socket)
            [_infos removeObject: u];
    }
    [_infos addObject: connection];
}

- (void) updateConnection:(User *)connection withNewStatus:(NSString *)status
{
    for (User *u in _infos)
    {
        if (u.socket == connection.socket && [u.login isEqualToString: connection.login])
        {
            [[u login] release];
            [u setStatus: [[NSString alloc] initWithString: status]];
        }
    }
}

- (void) removeConnection:(User *)connection
{
    for (User *u in _infos)
    {
        if (u.socket == connection.socket)
            [_infos removeObject: u];
    }
}

- (void) dealloc
{
    [_login release];
    [_infos release];
    [super dealloc];
}
@end
