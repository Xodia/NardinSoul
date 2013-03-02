//
//  UserPrezCell.h
//  NardinSoul
//
//  Created by Morgan Collino on 27/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface UserPrezCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *login;
@property (nonatomic, retain) IBOutlet UILabel *location;
@property (nonatomic, retain) IBOutlet UILabel *host;
@property (nonatomic, retain) IBOutlet UILabel *comments;
@property (nonatomic, retain) IBOutlet UILabel *group;
@property (nonatomic, retain) IBOutlet UILabel *status;

- (void) setUser: (User *) user;
@end
