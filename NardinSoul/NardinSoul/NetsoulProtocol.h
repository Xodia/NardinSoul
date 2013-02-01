//
//  NetsoulProtocol.h
//  NardinSoul
//
//  Created by Morgan Collino on 25/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "NetsoulViewProtocol.h"


/*
 
 Type of commands (use as tag for socket's methods.)
 
 
 More info about Netsoul protocol : https://github.com/0xbaadf00d/ShadowSoul/blob/master/docs/netsoul_spec.txt
 
 */

enum NS_ACTION {
    AUTH = 0,
    AUTORISE_CO,
    CONNECT,
    DISCONNECT,
    SEND_MSG,
    RECV_MSG,
    MDFY_STATUS,
    LIST_USERS,
    WATCH_USERS,
    WHO_USERS
    };


@interface NetsoulProtocol : NSObject <GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_socket;
    
    NSString *socketNumber;
    NSString *hashMD5;
    NSString *hostClient;
    NSString *portClient;
    NSString *timestamp;
    
    id <NetsoulViewProtocol> delegate;
}


@property(nonatomic, assign, readwrite ) id<NetsoulViewProtocol> delegate;


/* 
 socket methods from delegate
 */

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;

/*
 
    This class is a singleton. Simply because we only want to have access on this
    single var in every part of the code. (like GCDAsyncSocket for background actions)
 
 */

+ (NetsoulProtocol *)sharePointer;

/*
 
 Delegate conforms to the NetsoulViewProtocol
 
 */

- (void) setDelegate: (id) delegate;
- (id)   delegate;


/*
 
 
 public methods
 
 */

- (id)   initWithPort: (int) port andAddress: (NSString *) address;
- (void) resetSocketWithPort:(int)port andAdress: (NSString *) address;
- (bool) connect;
- (bool) disconnect;
- (bool) sendMsg:(NSString *)msg to:(NSArray *)users;
- (NSString *) hashForAuthentificationWithLogin: (NSString *) login andPassword: (NSString *) password;

@end
