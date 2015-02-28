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
#import "NardinPool.h"
#import "Message.h"
#import "NSString+HTML.h"

@implementation NetsoulProtocol

@synthesize delegate, managedObjectContext, loginNetsouled, socket = _socket;

static NetsoulProtocol *sharePointer = nil;

- (id) init
{
    if (self = [super init])
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
            //NSLog(@"Error connecting: %@", error);
        }
        else
        {
           // NSLog(@"Connected !");
        }
        
    }
    return self;
}

- (void) resetSocketWithPort:(int)port andAdress: (NSString *) address;
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    _socket =  [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue: mainQueue];
    NSError *error;
	NSLog(@"HERE");
    if (![_socket connectToHost: address onPort: port error: &error])
    {
        NSLog(@"Error connecting: %@", error);
    }
    else
    {
        NSLog(@"Connected !");
    }
}


/*
 
 Parse command given by the socket to an NSPacket
 and send it to delegate's methods.
 
 */

- (void) parseCommand: (NSArray *)  array
{    
    if ([array count] < 4) // Aucune commande en dessous de 4 elements
        return;
    
    User *user = [[User alloc] initWithUserInformations: [array objectAtIndex: 1]];
    NSMutableArray *params = [[NSMutableArray alloc] init];
    
    int it = 0;
    for (NSString *i in array)
    {
        if (it >= 4)
            [params addObject: i];
        it++;
    }
    
    NSPacket *packet = [[NSPacket alloc] initPacketWithUser: user withCommand: [array objectAtIndex:3] andParameters: params];
    NSString *str = [cmdSelector objectForKey: [array objectAtIndex: 3]];    
    [[NetsoulCore sharedObject] receptPacket: packet];
    if (str && [delegate respondsToSelector: NSSelectorFromString(str)])
    {
        [delegate performSelector: NSSelectorFromString(str) withObject: packet];
    }
    else if ([delegate respondsToSelector: @selector(didReceivePaquetFromNS:)])
    {
        // Methode obligatoirement implementer
		NSLog(@"Packet fetch : %@", packet);
		UIApplicationState state = [[UIApplication sharedApplication] applicationState];
		if ([[packet command] isEqual: @"msg"] && (state == UIApplicationStateBackground || state == UIApplicationStateInactive))
		{
			NSString *msg = [[packet parameters] objectAtIndex: 0];
			msg = [msg stringByReplacingPercentEscapesUsingEncoding: NSISOLatin1StringEncoding];
			msg = [msg stringByDecodingHTMLEntities];

			UILocalNotification *notification = [[UILocalNotification alloc] init];
			notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
			if (msg)
				notification.alertBody = [NSString stringWithFormat: @"%@: %@", packet.from.login, msg];
			
			notification.timeZone = [NSTimeZone defaultTimeZone];
			notification.soundName = UILocalNotificationDefaultSoundName;
			notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
			
			[[UIApplication sharedApplication] presentLocalNotificationNow: notification];
		}
        [delegate didReceivePaquetFromNS: packet];
    }
    //[params release];
    packet = nil;
}

- (void) sendPing: (NSArray *) array
{
    [_socket writeData: [@"ping 600\n" dataUsingEncoding: NSUTF8StringEncoding] withTimeout: -1 tag: 42];
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
				NSString *key = [array objectAtIndex:0];
				[self performSelector:NSSelectorFromString([treatSelector objectForKey:key])
						   withObject: array];
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
    loginNetsouled = @"";
    
    UIApplication  *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
}

/*
 
 Send message to a group of users.
 
 */


- (NSString *) stringForGroupOfUsers: (NSArray *) users {
    NSString *varUser = @"";
    if ([users count] == 1) {
        varUser = [users objectAtIndex: 0];
    }
    else if ([users count] > 1) {
        varUser = @"{";
        for (NSString *s in users) {
			varUser = [varUser isEqualToString: @"{"] ? [varUser stringByAppendingFormat: @"%@", s] : [varUser stringByAppendingFormat: @",%@", s];
        }
        varUser = [varUser stringByAppendingFormat: @"}"];
    }
    return varUser;
}

- (void) sendMsg:(NSString *)msg to:(NSArray *)users
{
    NSString *escapedUrlString = [msg stringByAddingPercentEscapesUsingEncoding: NSISOLatin1StringEncoding];
    
    escapedUrlString = [escapedUrlString stringByReplacingOccurrencesOfString: @"'" withString: @"%27"];
    escapedUrlString = [escapedUrlString stringByReplacingOccurrencesOfString: @"\"" withString: @"%22"];

    if (!escapedUrlString)
        escapedUrlString = msg;
    NSString *varUser = @"";
    
    if ([users count] > 0)
         varUser = [self stringForGroupOfUsers: users];
    else
        return; // just ignore - 0 user
    /*
    
        one user : "user_cmd msg_user user msg test\n"
        +user : "user_cmd msg_user {user, user2, user3} msg test\n"
     
     */
        
    NSString *real = [NSString stringWithFormat: @"user_cmd msg_user %@ msg %@\n", varUser, escapedUrlString];
    [_socket writeData: [real dataUsingEncoding: NSISOLatin1StringEncoding] withTimeout:-1 tag: SEND_MSG];
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
    lastExpression = [[NSString alloc] initWithString: real];
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
    isConnected = NO;
    if ([delegate respondsToSelector: NSSelectorFromString(@"didDisconnect")]) {
		[delegate didDisconnect];
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;
{
    [sock readDataWithTimeout: 50 tag: AUTH];
    
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
    {
        // Backgrounding doesn't seem to be supported on the simulator yet
        
        [_socket performBlock:^{
            //if ([sock enableBackgroundingOnSocket])
              //  NSLog(@"Enabled backgrounding on socket");
        }];
    }
#endif

    // ask for connection
    [_socket writeData: [@"auth_ag ext_user none none\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout: -1 tag: AUTORISE_CO];
}

- (void) receivedAuthToken: (NSString *) token
{
    NSArray *array = [token componentsSeparatedByString: @" "];
    //NSLog(@"receivedAuthToken: %@", array);
    
    if ([array count] > 5)
    {
        socketNumber = [[NSString alloc] initWithString: [array objectAtIndex: 1]];
        hashMD5 = [[NSString alloc] initWithString: [array objectAtIndex: 2]];
        hostClient = [[NSString alloc] initWithString: [array objectAtIndex: 3]];
        portClient = [[NSString alloc] initWithString: [array objectAtIndex: 4]];
        timestamp = [[NSString alloc] initWithString: [array objectAtIndex: 5]];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *login = [prefs stringForKey:@"login"];
        NSString *pass = [prefs stringForKey: @"pass"];
        
        loginNetsouled = login;
        
        NSString *hash = [NSString stringWithFormat: @"%@-%@/%@%@", hashMD5, hostClient, portClient, pass];
        NSString *hashr = [hash MD5String];
        NSString *str = [NSString stringWithFormat: @"ext_user_log %@ %@ %@ %@\n", login, [hashr lowercaseString], [[prefs stringForKey:@"location"] stringByAddingPercentEscapesUsingEncoding:
                                                                                                                                            NSASCIIStringEncoding], [[prefs stringForKey:@"comments"] stringByAddingPercentEscapesUsingEncoding:
                                                                                                                                                                     NSASCIIStringEncoding]];
        [_socket writeData: [str dataUsingEncoding: NSUTF8StringEncoding]  withTimeout: -1 tag: CONNECT];
        if ([token rangeOfString:@"cmd end"].location == NSNotFound)
            [_socket readDataWithTimeout: -1 tag: 42]; // rep 002 - cmd end -> AUTH
        [_socket readDataWithTimeout: -1 tag: CONNECT];
    }
    else
    {
        [_socket writeData: [@"auth_ag ext_user none none\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout: -1 tag: AUTORISE_CO];
        [_socket readDataWithTimeout: -1 tag: AUTH];
    }

}

- (void) receivedConnectToken: (NSString *) token
{
    NSArray *array = [token componentsSeparatedByString: @" "];
    NSString *res = [array objectAtIndex: 1];
	
	NSLog(@"Token : %@", token);
    if ([res isEqualToString: @"002"])
    {
        isConnected = YES;
        [self setStatus: @"actif"];
    }
    else if (!isConnected)
    {
        [self disconnect];
    }
    
    if ([delegate respondsToSelector: NSSelectorFromString([cmdSelector objectForKey: @"auth"])])
    {
        [delegate performSelector: NSSelectorFromString([cmdSelector objectForKey: @"auth"]) withObject: @(isConnected)];
    }

}

- (void) receivedToken: (NSString *) token
{
    if (![token rangeOfString:@"salut"].location == NSNotFound)
        [_socket readDataWithTimeout: -1 tag:42];
    if (!token)
    {
        if (lastExpression && ![lastExpression isEqualToString: @""])
        {
            [_socket writeData: [lastExpression dataUsingEncoding: NSUTF8StringEncoding] withTimeout: 10 tag: 42];
        }
    }
    else
        [self interpretCommand: token];
    
    [_socket readDataWithTimeout: -1 tag: 42];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
    NSString *dataStr = [NSString stringWithUTF8String: [data bytes]];
    
    if (tag == AUTH)
        [self receivedAuthToken: dataStr];
    else if (tag == CONNECT)
        [self receivedConnectToken: dataStr];
    else
        [self receivedToken: dataStr];
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
