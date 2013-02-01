//
//  NetsoulViewProtocol.h
//  NardinSoul
//
//  Created by Morgan Collino on 27/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPacket;
@class User;


@protocol NetsoulViewProtocol <NSObject>
@required

- (void) didReceivePaquetFromNS: (NSPacket *) packet;

@optional

- (void) didAuthentificate: (bool) real;
- (void) didDisconnect;
- (void) didReceiveMessageFrom: (User *) who content: (NSString *) msg;
- (void) didChangeStatusFrom: (NSString *) oldStatus to: (NSString *) newStatus;
- (void) didReceiveTypingFrom: (User *) from;
- (void) didCancelTypingFrom: (User *) from;
- (void) didReceiveWhoInformations: (NSArray *) arrayUser;
- (void) didReceiveListUserInformations: (NSArray *) arrayUser;
- (void) didReceiveLogOfUser: (NSArray *) arrayUser;
- (bool) reconnectIfDisconnected;
- (bool) didReceiveMsgInBackground: (User*) from withMsg: (NSString *)msg;

#pragma TODO  IMPLEMENT_METHOD_TO_NETSOUL_PROTOCOL
@end
