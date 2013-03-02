//
//  UserPrezCell.m
//  NardinSoul
//
//  Created by Morgan Collino on 27/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "UserPrezCell.h"
#import "User.h"

@implementation UserPrezCell

@synthesize login = _login, location = _location, status = _status, group = _group, comments = _comments, host = _host;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUser: (User *) user
{
    [_login setText: user.login];
    [_location setText: user.location];
    [_status setText: user.status];
    [_group setText: user.group];
    [_comments setText: user.userData];
    [_host setText: user.userHost];
}

@end
