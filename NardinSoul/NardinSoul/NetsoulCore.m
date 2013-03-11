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
        [keySelector setObject: @"receptLogout:" forKey: @"logout"];
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
    [[NardinPool sharedObject] addPacket: packet];
}

- (void) receptWho: (NSPacket *) packet
{
    if ([packet.parameters count] == 12)
    {
        User *who = [[User alloc] initWithWhoInformationsWithArray: packet.parameters];
        [[NardinPool sharedObject] addContactInfo: who];
        [who release];
    }
}

- (void) receptLogout: (NSPacket *) packet
{
    [[NardinPool sharedObject] removeContactInfo: packet.from];
}

- (void) receptState: (NSPacket *) packet
{
    if ([packet.parameters count] > 0)
    {
        NSString *para = [packet.parameters objectAtIndex: 0];
        NSArray *arr = [para componentsSeparatedByString: @":"];
        if ([arr count] > 0)
        {
            if ([[arr objectAtIndex: 0] isEqualToString: @"actif"])
            {
                // ajouter nouvelle connexion -> packet.from
                [[NardinPool sharedObject] addContactInfo: packet.from];
            }
            else
                [[NardinPool sharedObject] updateContactInfo: packet.from withNewStatus: [arr objectAtIndex: 0]];
        }
    }

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
