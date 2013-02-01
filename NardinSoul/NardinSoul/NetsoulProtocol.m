//
//  NetsoulProtocol.m
//  NardinSoul
//
//  Created by Morgan Collino on 25/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "NetsoulProtocol.h"
#import "NSString+MD5.h"

#import "User.h"
#import "NSPacket.h"

@implementation NetsoulProtocol

@synthesize delegate;

static NetsoulProtocol *sharePointer = nil;


+ (NetsoulProtocol *)sharePointer
{
    if (sharePointer == nil) {
        sharePointer = [[NetsoulProtocol alloc] init];
    }
    return sharePointer;
}

- (id) initWithPort: (int) port andAddress:(NSString *) address
{
    if (self = [super init])
    {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        _socket =  [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue: mainQueue];
        NSError *error;
        if (![_socket connectToHost: address onPort: port error: &error])
        {
            NSLog(@"Error connecting: %@", error);
        }
        else
        {
            NSLog(@"Connected !");
        }
        
    }
    return self;
}

- (void) resetSocketWithPort:(int)port andAdress: (NSString *) address;
{
    if (sharePointer)
    {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        _socket =  [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue: mainQueue];
        NSError *error;
        if (![_socket connectToHost: address onPort: port error: &error])
        {
            NSLog(@"Error connecting: %@", error);
        }
        else
        {
            NSLog(@"Connected !");
        }
    }
}


/*
 
 Parse command given by the socket to an NSPacket
 and send it to delegate's methods.
 
 */

- (void) parseCommand: (NSArray *)  array
{    
    User *user = [[User alloc] initWithUserInformations: [array objectAtIndex: 1]];
    NSMutableArray *params = [[NSMutableArray alloc] init];
    
    int it = 0;
    for (NSString *i in array)
    {
        if (it >= 4)
        {
            [params addObject: i];
        }
        it++;
    }
    
    NSPacket *packet = [[NSPacket alloc] initPacketWithUser: user withCommand: [array objectAtIndex:3] andParameters: params];

    // call delegate's method.
    if ([delegate respondsToSelector: @selector(didReceivePaquetFromNS:)])
    {
        [delegate didReceivePaquetFromNS: packet];
    }
    
    /*
     
        To erase -> Notification when you get a message from the server
     
     */
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive && [[packet command] isEqualToString: @"msg"])
    {
        UILocalNotification *localNF = [[UILocalNotification alloc] init];
        localNF.fireDate = nil;
        localNF.timeZone = [NSTimeZone defaultTimeZone];
        
		localNF.alertBody = [NSString stringWithFormat: @"%@: %@", [[packet from] login], [[packet parameters] objectAtIndex: 0]];
        localNF.alertAction = nil;
        localNF.soundName = UILocalNotificationDefaultSoundName;
        localNF.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNF];
    }
}

- (void) interpretCommand: (NSString *) command
{
    NSArray *array = [command componentsSeparatedByString: @" "];
    
    if ([array count] > 0)
    {
        if ([[array objectAtIndex: 0] isEqualToString: @"user_cmd"])
            [self parseCommand: array];
        else if ([[array objectAtIndex: 0] isEqualToString: @"ping"])
        {
            [_socket writeData: [@"ping 600\n" dataUsingEncoding: NSUTF8StringEncoding] withTimeout: -1 tag: 42];
            [_socket readDataWithTimeout: -1 tag: 42];
        }
        else
        {
            // e.g. : "184 collin_m 92.138.99.155 1359318517 1359318517 3 1 ~ NardinSoul.v1 epitech_2015 actif:1359318591 Somewhere"
            NSArray *sub = [command componentsSeparatedByString: @"\n"];
            
            for (NSString *s in sub)
            {
                if ([[[s componentsSeparatedByString: @" "] objectAtIndex: 0] isEqualToString: @"rep"])
                {
                    break;
                }
                User *user = [[User alloc] initWithWhoInformations: s];
                // send user to an delegate's method
            }
        }
    }
    else
        NSLog(@"Command: %@", command);
}

/*
 
 Create hash for the authentification and write it to the socket.
 
 */

- (NSString *) hashForAuthentificationWithLogin: (NSString *) login andPassword: (NSString *) password
{    
    NSString *hash = [NSString stringWithFormat: @"%@-%@/%@%@", hashMD5, hostClient, portClient, password];
    NSString *hashr = [hash MD5String];
    
    NSString *str = [NSString stringWithFormat: @"ext_user_log %@ %@ %@ %@\n", login, [hashr lowercaseString], @"@NardinSoul.v1", @"Somewhere"];
    [_socket writeData: [str dataUsingEncoding: NSUTF8StringEncoding]  withTimeout: 20 tag: CONNECT];
    
    return @"";
}

#pragma  TODO DO_CONNECT_METH 
- (bool) connect
{
    return YES;
}

#pragma  TODO DO_DISCONNECT_METH
- (bool) disconnect
{
    return YES; 
}

/*
 
 Send message to a group of users.
 
 */


- (NSString *) stringForGroupOfUsers: (NSArray *) users
{
    NSString *varUser = @"";
    if ([users count] == 1)
    {
        varUser = [users objectAtIndex: 0];
    }
    else if ([users count] > 1)
    {
        varUser = @"{";
        for (NSString *s in users)
        {
            if ([varUser isEqualToString: @"{"])
                varUser = [varUser stringByAppendingFormat: @"%@", s];
            else
                varUser = [varUser stringByAppendingFormat: @",%@", s];
        }
        varUser = [varUser stringByAppendingFormat: @"}"];
    }
    return varUser;
}

- (bool) sendMsg:(NSString *)msg to:(NSArray *)users
{
    NSString *escapedUrlString =[msg stringByAddingPercentEscapesUsingEncoding:
     NSASCIIStringEncoding];
    NSString *varUser = @"";
    
    if ([users count] > 0)
         varUser = [self stringForGroupOfUsers: users];
    else
        return NO;
    
    /*
    
        one user : "user_cmd msg_user user msg test\n"
        +user : "user_cmd msg_user {user, user2, user3} msg test\n"
     
     */
    
    
    NSString *real = [NSString stringWithFormat: @"user_cmd msg_user %@ msg %@\n", varUser, escapedUrlString];

    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout:-1 tag: SEND_MSG];
    
    return YES;
}

/*
    Set status (away, lock, actif, ...)
 
 */


- (bool) setStatus: (NSString *) newStatus
{
    NSDate *date = [NSDate date];
    NSString *real = [NSString stringWithFormat: @"state %@:%li\n", newStatus, (long)[date timeIntervalSince1970]];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout: 20 tag:MDFY_STATUS];
    [_socket readDataWithTimeout: 20 tag: MDFY_STATUS];
    return true;
}


- (bool) listUsers: (NSArray *) users
{
    NSString *varUser = @"";
    
    if ([users count] > 0)
        varUser = [self stringForGroupOfUsers: users];
    else
        return NO;
    
    /*
        one user : "list_users toto\n"
        +user: "list_users {toto, toto2, toto3}\n"
     */
    
    NSString *real = [NSString stringWithFormat: @"list_users %@\n", varUser];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout: 20 tag: LIST_USERS];
    [_socket readDataWithTimeout: 20 tag: LIST_USERS];
    return true;
}

- (bool) watchUsers: (NSArray *) users
{
    NSString *varUser = @"";
    if ([users count] > 0)
        varUser = [self stringForGroupOfUsers: users];
    else
        return NO;
    
    /*
        one user: user_cmd watch_log_user toto\n"
        +user: user_cmd watch_log_user {toto, tata, lola}\n"
     */
    
    NSString *real = [NSString stringWithFormat: @"user_cmd watch_log_user %@\n", varUser];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout: -1 tag: WATCH_USERS];
    return (true);
}

- (bool) whoUsers: (NSArray *) users
{
    NSString *varUser = @"";
    if ([users count] > 0)
        varUser = [self stringForGroupOfUsers: users];
    else
        return NO;
    
    /*
     one user: user_cmd who toto\n"
     +user: user_cmd who {toto, tata, lola}\n"
     */
    
    NSString *real = [NSString stringWithFormat: @"user_cmd who %@\n", varUser];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout: -1 tag: WHO_USERS];
    return (true);
}


/*
    Delegate's methods (SOCKET)
 */


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
{
    NSLog(@"Error: Disconnected with error : %@", [err localizedDescription]);
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;
{
    NSLog(@"Connected: %@ on socket: %u", host, port);
    [sock readDataWithTimeout:20 tag: AUTH];
    
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
    {
        // Backgrounding doesn't seem to be supported on the simulator yet
        
        [_socket performBlock:^{
            if ([sock enableBackgroundingOnSocket])
                NSLog(@"Enabled backgrounding on socket");
        }];
    }
#endif

    // ask for connection
    [_socket writeData: [@"auth_ag ext_user none none\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout: -1 tag: AUTORISE_CO];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
    NSString *dataStr = [NSString stringWithUTF8String: [data bytes]];
        
    if (tag == AUTH)
    {        
        NSArray *array = [dataStr componentsSeparatedByString: @" "];
        
        socketNumber = [array objectAtIndex: 1];
        hashMD5 = [array objectAtIndex: 2];
        hostClient = [array objectAtIndex: 3];
        portClient = [array objectAtIndex: 4];
        timestamp = [array objectAtIndex: 5];
        
        
        // e.g. authentification : [self hashForAuthentificationWithLogin: @"login" andPassword: @"password"];
        //                         [_socket readDataWithTimeout: 30 tag: CONNECT];
    }
    else if (tag == CONNECT)
    {
        NSArray *array = [dataStr componentsSeparatedByString: @" "];
        NSString *res = [array objectAtIndex: 1];
        if ([res isEqualToString: @"002"])
        {
            NSLog(@"User connected successfully !");
            [self setStatus: @"actif"];
        }
        else
        {
            [self disconnect];
            NSLog(@"User failed to connect");
            return;
        }
    }
    else if (tag == AUTORISE_CO)
    {
        NSLog(@"AUTORISE_CO:[%@] with tag: %li", dataStr, tag);
    }
    else
    {
        NSLog(@"New read tag=%li", tag);
        [_socket readDataWithTimeout: -1 tag: 42];
        
        // parsecmd
        [self interpretCommand: dataStr];
    }
#pragma TODO DO_PTR_TO_SELECTOR
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;
{

}



/*
 
 Notification:
 (Server)
 user_cmd <socket>:user:<trust level>:<login>@<user host>:<workstation type>:<location>:<groupe> | <command> <command extension>

 <command> -> login, login, state, msg, new_mail (to ignore)
 
 (Server)
 After list_users
 <socket> <login> <user host> <login timestamp> <last status change timestamp> <trust level low> <trust level high> <workstation type> <location> <group> <status> <user data>

 (Server)
 who:
 user_cmd <socket>:user:<trust level>:<login>@<user host>:<workstation type>:<location>:<groupe> | who <socket> <login> <user host> <login timestamp> <last change timestamp> <trust level low> <trust level high> <workstation type> <location> <group> <status> <user data>
 
 (Server)
 server: ping 600
-> send "ping 600"
 
 */

@end