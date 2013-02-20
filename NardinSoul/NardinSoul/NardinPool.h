//
//  NardinPool.h
//  NardinSoul
//
//  Created by Morgan Collino on 20/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetsoulViewProtocol.h"

@class NSPacket;

@interface NardinPool : NSObject
{
    NSMutableDictionary *messageReceived;
    // NSMutableDictionary *userData;
}

+ (NardinPool *) sharedObject;
- (void) addPacket:(NSPacket *)packet;
- (void) removePacket: (NSPacket *) packet;
- (void) removeKey: (NSString *) key;
@property (nonatomic, assign) NSMutableDictionary *messageReceived;

@end
