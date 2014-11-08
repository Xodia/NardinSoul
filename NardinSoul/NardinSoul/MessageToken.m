//
//  MessageToken.m
//  NardinSoul
//
//  Created by Morgan Collino on 20/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "MessageToken.h"

@implementation MessageToken

@synthesize msg = _msg;
@synthesize isExtern = _isExtern;

- (id) initWithMessage: (NSString *) __msg andFrom: (BOOL) outcome
{
    if (self = [super init])
    {
        _msg = __msg;
        _isExtern = outcome;
    }
    return self;
}

@end
