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

@property (nonatomic) NSString *login;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *group;
@property (nonatomic) NSString *workstationType;
@property (nonatomic) NSString *userHost;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *userData;
@property (nonatomic) long loginTimestamp;
@property (nonatomic) long lastStatusChangeTimestamp;
@property (nonatomic) int  trustLevelHigh;
@property (nonatomic) int     trustLevelLow;
@property (nonatomic) int     socket;


- (id) initWithUserInformations: (NSString *) infos;
- (id) initWithListUserInformations: (NSString *) whoInfo;
- (id) initWithWhoInformations: (NSString *) info;
- (id) initWithWhoInformationsWithArray:(NSArray *) array;

- (void) dealloc;
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
