//
//  NSContact.h
//  NardinSoul
//
//  Created by Morgan Collino on 27/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface NSContact : NSObject
{
    NSString *login;
    NSMutableArray *infos;
}

- (id) initWithLogin: (NSString *) log andInfos: (NSMutableArray *) info;
- (id) initWithLogin: (NSString *) log;

- (void) putConnection: (User *) connection;
- (void) removeConnection: (User *) connection;
- (void) updateConnection: (User *) connection withNewStatus: (NSString *) status;

@property (nonatomic, assign) NSMutableArray *infos;
@property (nonatomic, assign) NSString *login;

@end
