//
//  NetsoulCore.h
//  NardinSoul
//
//  Created by Morgan Collino on 01/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPacket;

@interface NetsoulCore : NSObject
{
    NSMutableDictionary *keySelector;
}

+ (NetsoulCore *) sharedObject;

- (void) receptPacket: (NSPacket *) packet;
@end
