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

@interface RootViewController : UITableViewController <NetsoulViewProtocol, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *msgReceived;
}

@property (nonatomic, retain) NSMutableArray *msgReceived;

@end
