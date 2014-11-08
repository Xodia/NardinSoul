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
    NSMutableDictionary *contactsInfo;
}

+ (NardinPool *) sharedObject;
- (void) addPacket:(NSPacket *)packet;
- (void) removePacket: (NSPacket *) packet;
- (void) removeKey: (NSString *) key;

- (void)  addContact: (NSString *) contact;
- (void)  removeContact: (NSString *) contact;
- (NSSet *) contacts;
- (BOOL) isAContact: (NSString *) contact;

- (void)  addContactInfo: (User *) contact;
- (void)  removeContactInfo: (User *) contact;
- (void) updateContactInfo: (User *) contact withNewStatus: (NSString *) status;
- (void) removeContactInfoByName: (NSString *) name;
- (NSMutableDictionary *) contactsInfo;

- (int) numbersOfMessage;
- (void) flushInfo;

- (void) createAccount: (NSString *) accountName;

@property (nonatomic, strong) NSMutableDictionary *messageReceived;
@property (nonatomic, strong) NSMutableDictionary *contactsInfo;
@end
