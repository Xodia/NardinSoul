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
    
        NSLog(@"Timestamp: %lld - LoginTimeStamp: %ld", timestamp, connection.lastStatusChangeTimestamp);
    
        int _res =  (res / 60);
    
        NSLog(@"RES : %d", _res);
    
        NSString *stat = [NSString stringWithFormat: @"%@(%d)", [status objectAtIndex:0], _res];
        [state setText: stat];
    }
    else
        [state setText: connection.status];

    [location setText: connection.location];
    [ip setText: connection.userHost];
    [comment setText: connection.userData];
    [loggedin setText: @"ToSet"];
   // [state setText: stat];
    [group setText: connection.group];
}


- (void) dealloc
{
    [location release];
    [ip release];
    [comment release];
    [loggedin release];
    [state release];
    [group release];
    [super dealloc];
}

@end
