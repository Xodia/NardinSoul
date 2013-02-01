//
//  RootViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 21/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

#import "NetsoulViewProtocol.h"

@interface RootViewController : UIViewController <NetsoulViewProtocol>
{

}

- (void) didReceivePaquetFromNS: (NSPacket *) packet;

@property (nonatomic, retain) IBOutlet UILabel *cmd;
@property (nonatomic, retain) IBOutlet UILabel *params;
@property (nonatomic, retain) IBOutlet UILabel *from;

@end
