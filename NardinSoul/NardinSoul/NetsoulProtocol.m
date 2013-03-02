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
#import "NetsoulCore.h"

@implementation NetsoulProtocol

@synthesize delegate;

static NetsoulProtocol *sharePointer = nil;

- (id) init
{
    if (self)
    {
        if (!cmdSelector)
        {
            cmdSelector = [[NSMutableDictionary alloc] init];
            
            [cmdSelector setObject: @"didReceiveMessage:" forKey: @"msg"];
            [cmdSelector setObject: @"didReceiveTypingFrom:" forKey: @"dotnetSoul_UserTyping"];
            [cmdSelector setObject: @"didCancelTypingFrom:" forKey: @"dotnetSoul_UserCancelledTyping"];
            [cmdSelector setObject: @"didReceiveWhoInformations:" forKey: @"who"];
            [cmdSelector setObject: @"didReceiveListUserInformations:" forKey: @"list_users"];
            [cmdSelector setObject: @"didReceiveLogOfUser:" forKey: @"watch_log"];
            [cmdSelector setObject: @"didAuthentificate:" forKey: @"auth"];
            [cmdSelector setObject: @"didDisconnect:" forKey: @"disc"];
        }
        
        if (!treatSelector)
        {
            treatSelector = [[NSMutableDictionary alloc] init];
            [treatSelector setObject: @"parseCommand:" forKey: @"user_cmd"];
            [treatSelector setObject: @"sendPing:" forKey: @"ping"];
        }
        
    }
    return (self);
}

+ (NetsoulProtocol *)sharePointer
{
    if (sharePointer == nil)
    {
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
    // recup les params des methods
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
    
    NSString *str = [cmdSelector objectForKey: [array objectAtIndex: 3]];

    // Message && Who && State
    [[NetsoulCore sharedObject] receptPacket: packet];
    
    if (str && [delegate respondsToSelector: NSSelectorFromString(str)])
    {
        [delegate performSelector: NSSelectorFromString(str) withObject: packet];
    }
    else if ([delegate respondsToSelector: @selector(didReceivePaquetFromNS:)])
    {
        [delegate didReceivePaquetFromNS: packet];
    }
    
    
    // local notifications
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive && [[packet command] isEqualToString: @"msg"])
    {
        UILocalNotification *localNF = [[UILocalNotification alloc] init];
        localNF.fireDate = nil;
        localNF.timeZone = [NSTimeZone defaultTimeZone];
        
		localNF.alertBody = [NSString stringWithFormat: @"%@: %@", [[packet from] login], [[packet parameters] objectAtIndex: 0]];
        localNF.alertAction = nil;
        localNF.soundName = UILocalNotificationDefaultSoundName;
        localNF.applicationIconBadgeNumber = localNF.applicationIconBadgeNumber + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNF];
    }
    
    NSLog(@"_____PACKET: %@", array);
}

- (void) sendPing: (NSArray *) array
{
    [_socket writeData: [@"ping 600\n" dataUsingEncoding: NSUTF8StringEncoding] withTimeout: -1 tag: 42];
    NSLog(@"SEND PING !");
    [_socket readDataWithTimeout: -1 tag: 42];
}

- (void) interpretCommand: (NSString *) command
{
    NSArray *listPacket = [command componentsSeparatedByString: @"\n"];
        
    for (NSString *p in listPacket)
    {
        NSArray *array = [p componentsSeparatedByString: @" "];
    
        if ([array count] > 0)
        {
            if ([treatSelector objectForKey: [array objectAtIndex: 0]])
            {
                [self performSelector: NSSelectorFromString([treatSelector objectForKey: [array objectAtIndex: 0]]) withObject: array];
            }
        }
    }
}

/*
 
 Create hash for the authentification and write it to the socket.
 
 */

- (void) authentificateWithLogin: (NSString *) login andPassword: (NSString *) password
{
    [self connect];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:login forKey:@"login"];
    [prefs setObject:password forKey:@"pass"];
}

#pragma  TODO DO_CONNECT_METH 
- (void) connect
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *port = [prefs stringForKey: @"port"];
    NSString *server = [prefs stringForKey: @"server"];
    
    [self resetSocketWithPort: [port intValue] andAdress: server];
}

#pragma  TODO DO_DISCONNECT_METH
- (void) disconnect
{
    [_socket disconnect];
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

- (void) sendMsg:(NSString *)msg to:(NSArray *)users
{
    NSString *escapedUrlString =[msg stringByAddingPercentEscapesUsingEncoding:
     NSASCIIStringEncoding];
    NSString *varUser = @"";
    
    if ([users count] > 0)
         varUser = [self stringForGroupOfUsers: users];
    else
        return;
    
    /*
    
        one user : "user_cmd msg_user user msg test\n"
        +user : "user_cmd msg_user {user, user2, user3} msg test\n"
     
     */
    
    NSString *real = [NSString stringWithFormat: @"user_cmd msg_user %@ msg %@\n", varUser, escapedUrlString];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout:-1 tag: SEND_MSG];
    [_socket readDataWithTimeout: -1 tag: 42];
}

/*
    Set status (away, lock, actif, ...)
 
 */


- (void) setStatus: (NSString *) newStatus
{
    NSDate *date = [NSDate date];
    NSString *real = [NSString stringWithFormat: @"state %@:%li\n", newStatus, (long)[date timeIntervalSince1970]];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout: 20 tag:MDFY_STATUS];
    [_socket readDataWithTimeout: 20 tag: MDFY_STATUS];
}


- (void) listUsers: (NSArray *) users
{
    NSString *varUser = @"";
    
    if ([users count] > 0)
        varUser = [self stringForGroupOfUsers: users];
    else
        return;
    
    /*
        one user : "list_users toto\n"
        +user: "list_users {toto, toto2, toto3}\n"
     */
    
    NSString *real = [NSString stringWithFormat: @"list_users %@\n", varUser];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout: 20 tag: LIST_USERS];
    [_socket readDataWithTimeout: 20 tag: LIST_USERS];
}

- (void) watchUsers: (NSArray *) users
{
    NSString *varUser = @"";
    if ([users count] > 0)
        varUser = [self stringForGroupOfUsers: users];
    else
        return;
    
    /*
        one user: user_cmd watch_log_user toto\n"
        +user: user_cmd watch_log_user {toto, tata, lola}\n"
     */
    
    NSString *real = [NSString stringWithFormat: @"user_cmd watch_log_user %@\n", varUser];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout: -1 tag: WATCH_USERS];
    [_socket readDataWithTimeout: -1 tag: 42];
}

- (void) whoUsers: (NSArray *) users
{
    NSString *varUser = @"";
    if ([users count] > 0)
        varUser = [self stringForGroupOfUsers: users];
    else
        return;
    
    /*
     one user: user_cmd who toto\n"
     +user: user_cmd who {toto, tata, lola}\n"
     */
    
    NSString *real = [NSString stringWithFormat: @"user_cmd who %@\n", varUser];
    [_socket writeData: [real dataUsingEncoding: NSUTF8StringEncoding] withTimeout: -1 tag: WHO_USERS];
    [_socket readDataWithTimeout: -1 tag: 42];
}


/*
    Delegate's methods (SOCKET)
 */

- (BOOL) isConnected
{
    return isConnected;
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
{
    NSLog(@"Nardin Error: Disconnected with error : %@", [err localizedDescription]);
    isConnected = NO;
    if ([delegate respondsToSelector: NSSelectorFromString(@"didDisconnect")])
    {
        [delegate performSelector: NSSelectorFromString(@"didDisconnect") withObject: nil];
    }
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
    NSLog(@"didReadData");
    if (tag == AUTH)
    {
        NSArray *array = [dataStr componentsSeparatedByString: @" "];
        NSLog(@"Array: %@", array);
        
        if ([array count] > 5)
        {
            socketNumber = [[NSString alloc] initWithString: [array objectAtIndex: 1]];
            hashMD5 = [[NSString alloc] initWithString: [array objectAtIndex: 2]];
            hostClient = [[NSString alloc] initWithString: [array objectAtIndex: 3]];
            portClient = [[NSString alloc] initWithString: [array objectAtIndex: 4]];
            timestamp = [[NSString alloc] initWithString: [array objectAtIndex: 5]];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

            
            NSString *hash = [NSString stringWithFormat: @"%@-%@/%@%@", hashMD5, hostClient, portClient, [prefs stringForKey: @"pass"]];
            NSString *hashr = [hash MD5String];
            NSString *str = [NSString stringWithFormat: @"ext_user_log %@ %@ %@ %@\n", [prefs stringForKey:@"login"], [hashr lowercaseString], [[prefs stringForKey:@"location"] stringByAddingPercentEscapesUsingEncoding:
                                                                                                                        NSASCIIStringEncoding], [[prefs stringForKey:@"comments"] stringByAddingPercentEscapesUsingEncoding:
                                                                                                                                                 NSASCIIStringEncoding]];
            [_socket writeData: [str dataUsingEncoding: NSUTF8StringEncoding]  withTimeout: 20 tag: CONNECT];
            [_socket readDataWithTimeout: 30 tag: CONNECT];

        }
        // e.g. authentification : [self authentificateWithLogin: @"login" andPassword: @"password"];
        //                         [_socket readDataWithTimeout: 30 tag: CONNECT];
    }
    else if (tag == CONNECT)
    {
        NSArray *array = [dataStr componentsSeparatedByString: @" "];
        NSString *res = [array objectAtIndex: 1];
        if ([res isEqualToString: @"002"])
        {
            NSLog(@"User connected successfully !");
            
            isConnected = YES;
            [self setStatus: @"actif"];
        }
        else
        {
            isConnected = NO;
            [self disconnect];
            NSLog(@"User failed to connect");
            return;
        }
        
        if ([delegate respondsToSelector: NSSelectorFromString([cmdSelector objectForKey: @"auth"])])
        {
            [delegate performSelector: NSSelectorFromString([cmdSelector objectForKey: @"auth"]) withObject: isConnected];
        }
    }
    else if (tag == AUTORISE_CO)
    {
        NSLog(@"AUTORISE_CO:[%@] with tag: %li", dataStr, tag);
    }
    else
    {        
        // parsecmd
        [_socket readDataWithTimeout: -1 tag: 42];

        [self interpretCommand: dataStr];
        
        [_socket readDataWithTimeout: -1 tag: 42];

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

- (void) dealloc
{
    if (sharePointer)
        [sharePointer release];
    if (cmdSelector)
        [cmdSelector release];
    if (treatSelector)
        [treatSelector release];
    
    
    [socketNumber release];
    [hashMD5 release];
    [hostClient release];
    [portClient release];
    [timestamp release];

    [super dealloc];
}

@end
