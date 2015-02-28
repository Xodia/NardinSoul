//
//  NardinPool.m
//  NardinSoul
//
//  Created by Morgan Collino on 20/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "NardinPool.h"
#import "NetsoulProtocol.h"
#import "User.h"
#import "NSPacket.h"
#import "NSContact.h"
#import "Account.h"
#import "Contact.h"

@implementation NardinPool
@synthesize messageReceived = _messageReceived, contactsInfo = _contactsInfo;

static NardinPool *pool = nil;

- (id) init {
   if (self = [super init]) {
       _messageReceived = [[NSMutableDictionary alloc] init];
       _contactsInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (NardinPool *) sharedObject {
	
	static dispatch_once_t once = 0;
	dispatch_once(&once, ^{
		pool = [[NardinPool alloc] init];
	});
	
    return  pool;
}

#pragma ADD_MSG_PACKET_TO_THE_POOL

- (void) addPacket:(NSPacket *)packet {
    id obj = [_messageReceived objectForKey:[[packet from] login]];
    NSMutableArray *array;
    if ([obj isKindOfClass: [NSMutableArray class]]) {
        array = (NSMutableArray *) obj;
    }
    else {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject: packet];
    [_messageReceived setObject: array forKey:[[packet from] login]];
}

- (void)removePacket: (NSPacket *) packet {
    id obj = [_messageReceived objectForKey: [[packet from] login]];
    if ([obj isKindOfClass: [NSMutableArray class]]) {
        NSMutableArray *array = (NSMutableArray *) obj;
		
        array = nil;
    }
    [_messageReceived removeObjectForKey:[[packet from] login]];
}

- (int)numbersOfMessage {
    int i = 0;
    
    for (NSString *x in _messageReceived) {
        NSMutableArray *arr = [_messageReceived objectForKey: x];
        i += [arr count];
    }
    
    // ajout BDD ?
    // si l'app plante -> on a encore les messages non lus
    // Message { _token, _hasBeenRead, _from, _to, _timestamp }
    // Predicate => _hasBeenRead == FALSE => return [NSSet count];
    
    return i;
}

- (void)removeKey:(NSString *)key
{
    id obj = [_messageReceived objectForKey: key];
    if ([obj isKindOfClass: [NSMutableArray class]]) {
        NSMutableArray *array = (NSMutableArray *) obj;
        
		array = nil;
    }
    [_messageReceived removeObjectForKey: key];
}


// Who & State
#pragma METHOD_INFO_ON_CONTACT

- (void)addContactInfo:(User *)contact {
    if (!_contactsInfo)
        _contactsInfo = [[NSMutableDictionary alloc] init];
    NSContact  *c = [_contactsInfo objectForKey:contact.login];
    if (c) {
        [c putConnection: contact];
    }
}

- (void) flushInfo {
    if (_contactsInfo) {
        for (NSString *k in _contactsInfo) {
            NSContact *c = [_contactsInfo objectForKey: k];
            [c flush];
        }
    }
}

- (void)removeContactInfo:(User *)contact {
    if (!_contactsInfo)
        return;
    NSContact  *c = [_contactsInfo objectForKey:contact.login];
    if (c) {
        [c removeConnection: contact];
    }
}

- (void)updateContactInfo:(User *)contact withNewStatus:(NSString *)status;
{
    if (!_contactsInfo)
        _contactsInfo = [[NSMutableDictionary alloc] init];
    NSContact  *c = [_contactsInfo objectForKey: contact.login];
    if (c) {
        [c updateConnection:contact withNewStatus:status];
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


- (void) createAccount: (NSString *) accountName
{
    NSManagedObjectContext *context = [[NetsoulProtocol sharePointer] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account"
                                              inManagedObjectContext: context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit: 1];
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name == %@", [[NetsoulProtocol sharePointer] loginNetsouled]];
    [fetchRequest setPredicate: predicate];
    
    NSError *error = nil;
    NSArray *fetchResults = [context
                             executeFetchRequest:fetchRequest
                             error:&error];
    
    if ([fetchResults count] == 0)
    {
        Account *account = [NSEntityDescription insertNewObjectForEntityForName: @"Account" inManagedObjectContext: context];
        
        account.name = accountName;
        account.pwd = accountName;
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
    }
    else
    {
       // NSLog(@"Account %@, already created ;)", accountName);
    }
    
    
    NSSet *arr = [self contacts];
    
    if (arr)
    {
        for (Contact *s in arr)
        {
            if (s.contactName)
            {
                NSContact *c = [[NSContact alloc] initWithLogin: s.contactName];
                [_contactsInfo setObject: c forKey: s.contactName];
            }
        }
    }

}

- (BOOL) isAContact:(NSString *)contact
{
    NSSet *set = [self contacts];

    for (Contact *cont in set)
    {
        if ([cont.contactName isEqualToString: contact])
            return YES;
    }
    
    return (NO);
}


- (void)  addContact: (NSString *) contact
{
    Account *account = [self contact];
    NSSet *contacts = [self contacts];
    
    for (Contact *c in contacts)
    {
        if ([c.contactName isEqualToString: contact])
        {
            return;
        }
    }
    NSManagedObjectContext *context = [[NetsoulProtocol sharePointer] managedObjectContext];

    Contact *_contact = [NSEntityDescription insertNewObjectForEntityForName: @"Contact" inManagedObjectContext: context];
    
    _contact.contactName = contact;
    
    [account addContactListObject: _contact];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    _contact = nil;
    NSContact *c = [[NSContact alloc] initWithLogin: contact];
    [_contactsInfo setObject: c forKey: contact];
}

- (void)  removeContact: (NSString *) contact
{
    NSManagedObjectContext *context = [[NetsoulProtocol sharePointer] managedObjectContext];
    
    NSSet *contacts = [self contacts];
    for (Contact *c in contacts)
    {
		NSLog(@"ContactName: %@ - Contact: %@", c.contactName, contact);
        if ([c.contactName isEqualToString: contact])
        {
            //[[self contact] removeContactListObject: c];
			[context deleteObject: c];
            [[NardinPool sharedObject] removeContactInfoByName: contact];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            }
            return;
        }
    }
}


- (NSSet *) contacts
{
    Account *account = [self contact];
    if (account)
    {
        //NSLog(@"Return: %@", account.contactList);
       // for (Contact *c in account.contactList)
        //{
            //NSLog(@"\tLogin: %@", c.contactName);
        //}

        return account.contactList;
    }
    return  nil;
}

- (Account *) contact
{
    NSManagedObjectContext *context = [[NetsoulProtocol sharePointer] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account"
                                              inManagedObjectContext: context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit: 1];
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name == %@", [[NetsoulProtocol sharePointer] loginNetsouled]];
    [fetchRequest setPredicate: predicate];
    
    NSError *error = nil;
    NSArray *fetchResults = [context
                             executeFetchRequest:fetchRequest
                             error:&error];
    
    if ([fetchResults count] > 0)
    {
        return [fetchResults objectAtIndex: 0];
    }
    return nil;
}

@end
