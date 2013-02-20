//
//  NardinPool.m
//  NardinSoul
//
//  Created by Morgan Collino on 20/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "NardinPool.h"
#import "User.h"
#import "NSPacket.h"

@implementation NardinPool
@synthesize messageReceived = _messageReceived;

static NardinPool *pool = nil;

- (id) init
{
   if (self = [super init])
   {
       _messageReceived = [[NSMutableDictionary alloc] init];
   } 
    return self;
}

+ (NardinPool *) sharedObject
{
    if (!pool)
        pool = [[NardinPool alloc] init];
    return  pool;
}

- (void) addPacket:(NSPacket *)packet
{
    NSLog(@"ADDPACKET");
    id obj = [_messageReceived objectForKey: [[packet from] login]];
    NSMutableArray *array;
    if ([obj isKindOfClass: [NSMutableArray class]])
    {
        array = (NSMutableArray *) obj;
    }
    else
    {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject: packet];
    [_messageReceived setObject: array forKey: [[packet from] login]];
    NSLog(@"MESSG: %@", _messageReceived);
}

- (void) removePacket: (NSPacket *) packet
{
    id obj = [_messageReceived objectForKey: [[packet from] login]];
    if ([obj isKindOfClass: [NSMutableArray class]])
    {
        NSMutableArray *array = (NSMutableArray *) obj;
        
        for (id object in array)
        {
            [object release];
        }
        
        [array release];
    }
    [_messageReceived removeObjectForKey: [[packet from] login]];
}

- (void) removeKey: (NSString *) key
{
    id obj = [_messageReceived objectForKey: key];
    if ([obj isKindOfClass: [NSMutableArray class]])
    {
        NSMutableArray *array = (NSMutableArray *) obj;
        
        for (id object in array)
        {
            [object release];
        }
        
        [array release];
    }
    [_messageReceived removeObjectForKey: key];
}

- (void) dealloc
{
    if (_messageReceived)
        [_messageReceived release];
    
    [super dealloc];
}

@end
