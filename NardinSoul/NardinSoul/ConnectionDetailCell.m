//
//  ConnectionDetailCell.m
//  NardinSoul
//
//  Created by Morgan Collino on 05/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "ConnectionDetailCell.h"
#import "User.h"

@implementation ConnectionDetailCell

@synthesize location, ip, comment, loggedin, state, group;

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

- (void) printUser: (User *) connection
{
    NSArray *status = [connection.status componentsSeparatedByString: @":"];
    NSString *str;
    
    if ([status count] > 1)
    {
        str = [status objectAtIndex: 1];
        long long timestamp = [str longLongValue];
    
        long long res = [[NSDate date] timeIntervalSince1970] - timestamp;
        
        int _res =  ((int)res / 60); // minutes
        int _minutes = _res % 60;
        int _hours = _res / 60; // hours
        int _days = _hours / 24; // jours
            
        NSString *str = @"";
        
        if (_days > 0)
            str = [NSString stringWithFormat: @"%dj/", _days];
        if (_hours > 0)
            str = [str stringByAppendingFormat: @"%dh/", _hours];
        if (_res >= 0)
            str = [str stringByAppendingFormat: @"%dm", _minutes];
            
        NSString *stat = [NSString stringWithFormat: @"%@", [status objectAtIndex:0]];
        [state setText: stat];
        [loggedin setText: str];
    }
    else
        [state setText: connection.status];

    [location setText: connection.location];
    [ip setText: connection.userHost];
    [comment setText: connection.userData];
    [group setText: connection.group];
}

@end
