//
//  MessageViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 05/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSPacket;

@interface MessageViewController : UIViewController
{
    NSPacket *packet;
}

@property(nonatomic, retain) NSPacket *packet;

@property (nonatomic, retain) IBOutlet UILabel *lcmd;
@property (nonatomic, retain) IBOutlet UILabel *lparams;
@property (nonatomic, retain) IBOutlet UILabel *lfrom;

- (void) dealloc;

@end
