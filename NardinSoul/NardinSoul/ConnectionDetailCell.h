//
//  ConnectionDetailCell.h
//  NardinSoul
//
//  Created by Morgan Collino on 05/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface ConnectionDetailCell : UITableViewCell

- (void) printUser: (User *) connection;


@property (nonatomic, retain) IBOutlet UILabel *location;
@property (nonatomic, retain) IBOutlet UILabel *ip;
@property (nonatomic, retain) IBOutlet UILabel *comment;
@property (nonatomic, retain) IBOutlet UILabel *loggedin;
@property (nonatomic, retain) IBOutlet UILabel *state;
@property (nonatomic, retain) IBOutlet UILabel *group;

@end
