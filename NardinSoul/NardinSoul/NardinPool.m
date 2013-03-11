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
@synthesize messageReceived = _messageReceived, contactsInfo = _contactsInfo;

static NardinPool *pool = nil;

- (id) init
{
   if (self = [super init])
   {
       _messageReceived = [[NSMutableDictionary alloc] init];
       _contactsInfo = [[NSMutableDictionary alloc] init];
       NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey: @"contacts"];
       
       if (arr)
       {
           for (NSString *s in arr)
           {
               NSContact *c = [[NSContact alloc] initWithLogin: s];
               [_contactsInfo setObject: c forKey: s];
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

#pragma ADD_MSG_PACKET_TO_THE_POOL

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
    
    // ajout BDD ?
    // si l'app plante -> on a encore les messages non lus
    // Message { _token, _hasBeenRead, _from, _to, _timestamp }
    // Predicate => _hasBeenRead == FALSE => return [NSSet count];
    
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


// Who & State
#pragma METHOD_INFO_ON_CONTACT

- (void)  addContactInfo: (User *) contact
{
    if (!_contactsInfo)
        _contactsInfo = [[NSMutableDictionary alloc] init];
    NSContact  *c = [_contactsInfo objectForKey: contact.login];
    NSLog(@"Contact : %@ %d", c, c.retainCount);
    if (c)
    {
        [c putConnection: contact];
    }
}

- (void) flushInfo
{
    if (_contactsInfo)
    {
        for (NSString *k in _contactsInfo)
        {
            NSContact *c = [_contactsInfo objectForKey: k];
            [c flush];
        }
    }
}

- (void)  removeContactInfo: (User *) contact
{
    if (!_contactsInfo)
        return;
    NSContact  *c = [_contactsInfo objectForKey: contact.login];
    if (c)
    {
        [c removeConnection: contact];
    }
}

- (void) updateContactInfo: (User *) contact withNewStatus: (NSString *) status;
{
    if (!_contactsInfo)
        _contactsInfo = [[NSMutableDictionary alloc] init];
    NSContact  *c = [_contactsInfo objectForKey: contact.login];
    if (c)
    {
        [c updateConnection: contact withNewStatus: status];
    }
}

- (void) removeContactInfoByName: (NSString *) name
{
    @synchronized(_contactsInfo)
    {
        if (!_contactsInfo)
            return;
        [_contactsInfo removeObjectForKey: name];
    }
}

#pragma METHOD_CONTACT

#pragma TODO_CONTACT_ON_BDD

- (void)  addContact: (NSString *) contact
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"contacts"]];
        
    for (NSString *u in arr)
    {
        if ([contact isEqualToString: u])
            return;
    }
        
    [arr addObject: contact];
    NSContact *c = [[NSContact alloc] initWithLogin: contact];
    [_contactsInfo setObject: c forKey: contact];

    [[NSUserDefaults standardUserDefaults] setObject: arr forKey: @"contacts"];
    [arr release];
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
        [array release];
        array = (NSMutableArray *)[prefs objectForKey: @"contacts"];
    }
    return (array);
}


- (void) dealloc
{
    if (_messageReceived)
        [_messageReceived release] ;
    if (_contactsInfo)
        [_contactsInfo release];
    [super dealloc];
}

@end
