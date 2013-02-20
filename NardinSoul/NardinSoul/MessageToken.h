//
//  MessageToken.h
//  NardinSoul
//
//  Created by Morgan Collino on 20/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageToken : NSObject
{
    NSString    *msg;
    BOOL        isExtern;
}

@property (nonatomic, assign) NSString *msg;
@property (nonatomic) BOOL isExtern;

- (id) initWithMessage: (NSString *) __msg andFrom: (BOOL) outcome;

@end
