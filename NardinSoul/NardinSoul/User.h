//
//  User.h
//  NardinSoul
//
//  Created by Morgan Collino on 27/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    int     socket;
    int     trustLevelLow;
    int     trustLevelHigh;
    NSString *login;
    NSString *location;
    NSString *group;
    NSString *workstationType;
    NSString *userHost;
    NSString *status;
    NSString *userData;
    long loginTimestamp;
    long lastStatusChangeTimestamp;
}

@property (nonatomic, retain) NSString *login;

- (id) initWithUserInformations: (NSString *) infos;
- (id) initWithWhoInformations: (NSString *) whoInfo;


#pragma TODO PROPERTY_4_OTHERS_VAR

/*
 
    initWithUserInformations will parse this king of string
    receive ex: "909:user:1/3:forest_f@82.244.34.94:~:On%20Debian:epitech_2015"
 
*/

/*
    initWithWhoInformations will parse this kind of string
    <socket> <login> <user host> <login timestamp> <last status change timestamp> <trust level low> <trust level high> <workstation type> <location> <group> <status> <user data>
 */

@end
