//
//  RootViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 21/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "RootViewController.h"
#import <CoreFoundation/CoreFoundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "NetsoulProtocol.h"
#import "NSPacket.h"
#import "User.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize cmd, params, from;

- (void)viewDidLoad
{
    NetsoulProtocol *netsoul = [NetsoulProtocol sharePointer];
    [netsoul resetSocketWithPort: 4242 andAdress: @"ns-server.epita.fr"];
    
    //NetsoulProtocol *netsoul = [[NetsoulProtocol alloc] initWithPort: 4242 andAddress: @"ns-server.epita.fr"];
    
    [netsoul setDelegate: self];
    [netsoul connect];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* 
 
 Simple example 
 
 */

- (void) didReceivePaquetFromNS: (NSPacket *) packet;
{
    User *user = [packet from];
    NSString *login = [user login];
    NSString *paramsString = [[[packet parameters] objectAtIndex: 0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *cmdString = [packet command];

    [cmd setText: cmdString];
    [params setText: paramsString];
    [from setText: login];
}

@end
