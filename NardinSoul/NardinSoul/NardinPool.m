//
//  NardinPool.m
//  NardinSoul
//
//  Created by Morgan Collino on 20/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "NardinPool.h"
#import "User.h"
#import "NSPacket.h"
#import "NSContact.h"

@implementation NardinPool
@synthesize messageReceived = _messageReceived;

static NardinPool *pool = nil;

- (id) init
{
   if (self = [super init])
   {
       _messageReceived = [[NSMutableDictionary alloc] init];
       contactData = [[NSMutableDictionary alloc] init];
       NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey: @"contacts"];
       
       if (arr)
       {
           for (NSString *s in arr)
           {
               NSContact *c = [[NSContact alloc] initWithLogin: s];
               [contactData setObject: c forKey: s];
           }
       }
   }
    return self;
}

+ (NardinPool *) sharedObject
{
    if (!pool)
        pool = [[NardinPool alloc] init];
    return  pool;
}

- (void) addPacket:(NSPacket *)packet
{
    id obj = [_messageReceived objectForKey: [[packet from] login]];
    NSMutableArray *array;
    if ([obj isKindOfClass: [NSMutableArray class]])
    {
        array = (NSMutableArray *) obj;
    }
    else
    {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject: packet];
    [_messageReceived setObject: array forKey: [[packet from] login]];
}

- (void) removePacket: (NSPacket *) packet
{
    id obj = [_messageReceived objectForKey: [[packet from] login]];
    if ([obj isKindOfClass: [NSMutableArray class]])
    {
        NSMutableArray *array = (NSMutableArray *) obj;
        
        for (id object in array)
        {
            [object release];
        }
        
        [array release];
    }
    [_messageReceived removeObjectForKey: [[packet from] login]];
}

- (int) numbersOfMessage
{    
    int i = 0;
    
    for (NSString *x in _messageReceived)
    {
        NSMutableArray *arr = [_messageReceived objectForKey: x];
        i += [arr count];
    }
    
    return i;
}

- (void) removeKey: (NSString *) key
{
    id obj = [_messageReceived objectForKey: key];
    if ([obj isKindOfClass: [NSMutableArray class]])
    {
        NSMutableArray *array = (NSMutableArray *) obj;
        
        for (id object in array)
        {
            [object release];
        }
        
        [array release];
    }
    [_messageReceived removeObjectForKey: key];
}

- (void)  addContactInfo: (User *) contact
{
    if (!contactData)
        contactData = [[NSMutableDictionary alloc] init];
    
    NSContact  *c = [contactData objectForKey: contact.login];
    if (c)
    {
        [c putConnection: contact];
    }
}

- (void)  removeContactInfo: (User *) contact
{
    if (!contactData)
        return;
    NSContact  *c = [contactData objectForKey: contact.login];
    if (c)
    {
        [c removeConnection: contact];
    }
}

- (void) updateContactInfo: (User *) contact withNewStatus: (NSString *) status;
{
    if (!contactData)
        contactData = [[NSMutableDictionary alloc] init];
    
    NSContact  *c = [contactData objectForKey: contact.login];
    if (c)
    {
        [c updateConnection: contact withNewStatus: status];
    }
}

- (void) removeContactInfoByName: (NSString *) name
{    
    if (!contactData)
        return;
    [contactData removeObjectForKey: name];
}

- (NSMutableDictionary *) contactsInfo
{
    if (!contactData)
    {
        contactData = [[NSMutableDictionary alloc] init];
    }
    return (contactData);
}

- (void)  addContact: (NSString *) contact
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"contacts"]];
        
    for (NSString *u in arr)
    {
        if ([contact isEqualToString: u])
            return;
    }
    
    //[[[NSUserDefaults standardUserDefaults] objectForKey: @"contacts"] release];
    
    NSLog(@"CLASS: %@", [arr class]);
    
    [arr addObject: contact];
    
    NSLog(@"______");
    NSContact *c = [[NSContact alloc] initWithLogin: contact];
    [contactData setObject: c forKey: contact];

    [[NSUserDefaults standardUserDefaults] setObject: arr forKey: @"contacts"];
}

- (void)  removeContact: (NSString *) contact
{
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey: @"contacts"];
    
    if (!arr)
        return;
    for (NSString *u in arr)
    {
        if ([u isEqualToString: contact])
            [arr removeObject: u];
    }
    [[NSUserDefaults standardUserDefaults] setObject: arr forKey: @"contacts"];
}


- (NSMutableArray *) contacts
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = (NSMutableArray *)[prefs objectForKey: @"contacts"];
    if (!array)
    {
        array = [[NSMutableArray alloc] init];
        [prefs setObject: array forKey: @"contacts"];
    }
    return (array);
}


- (void) dealloc
{
    if (_messageReceived)
        [_messageReceived release] ;
    
    [super dealloc];
}

@end
