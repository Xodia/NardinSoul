//
//  NSPacket.h
//  NardinSoul
//
//  Created by Morgan Collino on 27/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface NSPacket : NSObject
{
    NSString *command;
    NSArray  *parameters;
    User     *from;
}
// if list_users -> command == @"list_users" -> parameters[] = list User -> from == 0

@property (nonatomic, assign) NSString *command;
@property (nonatomic, retain) NSArray  *parameters;
@property (nonatomic, retain) User     *from;

- (id) initPacketWithUser: (User *) sender withCommand:(NSString *) command andParameters: (NSArray *) params;

@end
