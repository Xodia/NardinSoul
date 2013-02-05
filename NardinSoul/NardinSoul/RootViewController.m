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
#import "MessageViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

//@synthesize cmd, params, from;

- (void)viewDidLoad
{
    msgReceived = [[NSMutableArray alloc] init];
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
    /*User *user = [packet from];
    NSString *login = [user login];
    NSString *paramsString = [[[packet parameters] objectAtIndex: 0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *cmdString = [packet command];

    [cmd setText: cmdString];
    [params setText: paramsString];
    [from setText: login];*/
    
    NSLog(@"Packet recu par la vue !");
    
    if ([[packet command] isEqualToString: @"msg"])
    {
        [msgReceived addObject: packet];
        NSLog(@"Reload");
        [[self tableView] reloadData];
        NSLog(@"didReload");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSPacket *packet = [msgReceived objectAtIndex: indexPath.row];
    
    // push view -> avec le packet
    
    MessageViewController *messageViewController = [[self storyboard] instantiateViewControllerWithIdentifier: @"MessageViewController"];
    
    [messageViewController setPacket: packet];
    
    [[self navigationController] pushViewController: messageViewController animated:YES];
    
    [msgReceived removeObjectAtIndex: indexPath.row];
    [[self tableView] reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Messages";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [msgReceived count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
        
    NSPacket *packet = [msgReceived objectAtIndex: indexPath.row];
    
    cell.textLabel.text = [packet.from login];    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
