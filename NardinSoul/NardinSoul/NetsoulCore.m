//
//  NetsoulCore.m
//  NardinSoul
//
//  Created by Morgan Collino on 01/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "NetsoulCore.h"
#import "NSPacket.h"
#import "NardinPool.h"
#import "NetsoulProtocol.h"
#import "User.h"

@implementation NetsoulCore

static NetsoulCore *shared = nil;

- (id) init
{
    if (self = [super init])
    {
        keySelector = [[NSMutableDictionary alloc] init];
        [keySelector setObject: @"receptMessage:" forKey: @"msg"];
        [keySelector setObject: @"receptWho:" forKey: @"who"];
        [keySelector setObject: @"receptState:" forKey: @"state"];
    }
    return  self;
}

+ (NetsoulCore *) sharedObject
{
    if (!shared)
    {
        shared = [[NetsoulCore alloc] init];
    }
    return shared;
}

- (void) receptMessage: (NSPacket *) packet
{
    NSLog(@"Receive message");
    [[NardinPool sharedObject] addPacket: packet];
}

- (void) receptWho: (NSPacket *) packet
{
    NSLog(@"Receive who");
    if ([packet.parameters count] == 12)
    {
        User *who = [[User alloc] initWithWhoInformationsWithArray: packet.parameters];
        [[NardinPool sharedObject] addContactInfo: who];
    }
}

- (void) receptState: (NSPacket *) packet
{
    NSLog(@"Receive State move");
}

- (void) receptPacket:(NSPacket *)packet
{
    if (packet && [keySelector objectForKey: packet.command])
    {
        NSString *key = (NSString *)[keySelector objectForKey: packet.command];
        if (key)
            [self performSelector: NSSelectorFromString(key) withObject: packet];
    }
}

- (void) dealloc
{
    [keySelector release];
    [super dealloc];
}

@end
