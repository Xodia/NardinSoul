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

- (void) didReceivePaquetFromNS: (NSPacket *) packet;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//@property (nonatomic, retain) IBOutlet UILabel *cmd;
//@property (nonatomic, retain) IBOutlet UILabel *params;
//@property (nonatomic, retain) IBOutlet UILabel *from;

@end
