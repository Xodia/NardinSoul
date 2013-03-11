//
//  Message.h
//  NardinSoul
//
//  Created by Morgan Collino on 09/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSDate * date;

@end
