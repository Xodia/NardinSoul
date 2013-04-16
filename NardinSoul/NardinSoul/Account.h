//
//  Account.h
//  NardinSoul
//
//  Created by Morgan Collino on 17/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pwd;
@property (nonatomic, retain) NSSet *contactList;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addContactListObject:(Contact *)value;
- (void)removeContactListObject:(Contact *)value;
- (void)addContactList:(NSSet *)values;
- (void)removeContactList:(NSSet *)values;

@end
