//
//  User.m
//  NardinSoul
//
//  Created by Morgan Collino on 27/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize  login, loginTimestamp, location, group, lastStatusChangeTimestamp, socket, status, trustLevelHigh, trustLevelLow, userData, userHost, workstationType;

- (id) initWithUserInformations:(NSString *)infos
{
    if (self = [super init])
    {
        // receive ex: "909:user:1/3:forest_f@82.244.34.94:~:On%20Debian:epitech_2015"
        NSArray *array = [infos componentsSeparatedByString: @":"];
        
        /*
         
            0: 909 -> socketFD
            1: user -> ignored
            2: 1/3  -> lowLevel/HighLevel
            3: forest_f@82.244.34.94 -> login@host
            4: ~ -> Machintype
            5: On%20Debian -> location
            6: epitech_2015 -> group
         
         */
        
        if ([array count] == 7)
        {
            socket = [[array objectAtIndex: 0] intValue];
            NSArray *subar = [[array objectAtIndex: 2] componentsSeparatedByString: @"/"];
            trustLevelLow = [[subar objectAtIndex:0] intValue];
            trustLevelHigh = [[subar objectAtIndex:1] intValue];
            subar = [[array objectAtIndex: 3] componentsSeparatedByString: @"@"];
            login = [[NSString alloc] initWithString: [subar objectAtIndex: 0]];
            userHost = [[NSString alloc] initWithString:[subar objectAtIndex: 1]];

            workstationType = [array objectAtIndex: 4];
            location = [[NSString alloc] initWithString:[array objectAtIndex: 5]];
            group = [[NSString alloc] initWithString: [array objectAtIndex: 6]];
        }
        else
            NSLog(@"Error: User Information error");
    }
    return (self);
}

/*
 <socket> <login> <user host> <login timestamp> <last status change timestamp> <trust level low> <trust level high> <workstation type> <location> <group> <status> <user data>
 */

- (id) initWithListUserInformations:(NSString *)whoInfo
{
    if (self = [super init])
    {
        NSArray *array = [whoInfo componentsSeparatedByString: @" "];

        if ([array count] > 11)
        {
            socket = [[array objectAtIndex: 0] intValue];
            login = [[NSString alloc] initWithString: [array objectAtIndex: 1]];
            userHost = [[NSString alloc] initWithString: [array objectAtIndex: 2]];
            
            loginTimestamp = [[array objectAtIndex: 3] longLongValue];
            lastStatusChangeTimestamp = [[array objectAtIndex: 4] longLongValue];
            trustLevelLow = [[array objectAtIndex: 5] intValue];
            trustLevelHigh = [[array objectAtIndex: 6] intValue];
            workstationType = [array objectAtIndex: 7];
            location = [[NSString alloc] initWithString: [array objectAtIndex: 8]];
            group = [[NSString alloc] initWithString: [array objectAtIndex: 9]];
            status = [[NSString alloc] initWithString: [array objectAtIndex: 10]];
            userData = [[NSString alloc] initWithString: [array objectAtIndex: 11]];
        }
        else
            NSLog(@"Error: List user Information error");
    }
    return (self);
}

- (id) initWithWhoInformationsWithArray:(NSArray *) array
{
    if (self = [super init])
    {
        if ([array count] == 12)
        {
            socket = [[array objectAtIndex: 0] intValue];
            login = [[NSString alloc] initWithString: [array objectAtIndex: 1]];
            userHost = [[NSString alloc] initWithString: [array objectAtIndex: 2]];
            
            loginTimestamp = [[array objectAtIndex: 3] longLongValue];
            lastStatusChangeTimestamp = [[array objectAtIndex: 4] longLongValue];
            trustLevelLow = [[array objectAtIndex: 5] intValue];
            trustLevelHigh = [[array objectAtIndex: 6] intValue];
            workstationType = [array objectAtIndex: 7];
            location = [[NSString alloc] initWithString: [[array objectAtIndex: 8]  stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            group = [[NSString alloc] initWithString: [[array objectAtIndex: 9]  stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            status = [[NSString alloc] initWithString: [[array objectAtIndex: 10]  stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            userData = [[NSString alloc] initWithString: [[array objectAtIndex: 11] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        }
        else
            NSLog(@"Error: Who Information error");
    }
    return (self);
}

- (void) dealloc
{
    if (location) [location release];
    if (group) [group release];
    if (status) [status release];
    if (userData) [userData release];
    if (userHost) [userHost release];
    if (login) [login release];
    [super dealloc];
}

@end
