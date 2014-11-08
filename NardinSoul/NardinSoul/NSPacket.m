//
//  NSPacket.m
//  NardinSoul
//
//  Created by Morgan Collino on 27/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "NSPacket.h"
#import "User.h"

@implementation NSPacket

@synthesize from, command, parameters;

- (id) initPacketWithUser: (User *) _sender withCommand:(NSString *) _command andParameters: (NSArray *) _params;
{
    if (self = [super init])
    {
        command = [[NSString alloc] initWithString: _command];
        from = _sender;
        parameters = _params;
    }
    return self;
}

- (void) dealloc
{
	command = nil;
	from = nil;
}

@end
