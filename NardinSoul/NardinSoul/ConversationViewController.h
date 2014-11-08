//
//  ConversationViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 19/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetsoulViewProtocol.h"
#import <JSQMessagesViewController/JSQMessages.h>

@class  NSPacket;

@interface ConversationViewController : JSQMessagesViewController <NetsoulViewProtocol>
{
    NSMutableArray *arrayMsg;
}

- (void) addMessage: (NSArray *) arrayMessages;
@end
