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
- (void) didReceiveMessage: (NSPacket *) pkg;
- (void) didReceiveTypingFrom: (NSPacket *) from;
- (void) didCancelTypingFrom: (NSPacket *) from;
- (void) didReceiveWhoInformations: (NSPacket*) info;
- (void) didReceiveListUserInformations: (NSPacket *) info;
- (void) didReceiveLogOfUser: (NSPacket*) info;
- (void) didReceiveStatusResponse: (bool) response;
- (bool) reconnectIfDisconnected;

@end
