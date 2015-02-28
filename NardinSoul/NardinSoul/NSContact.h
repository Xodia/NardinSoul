//
//  NSContact.h
//  NardinSoul
//
//  Created by Morgan Collino on 27/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface NSContact : NSObject

- (id) initWithLogin: (NSString *) log andInfos: (NSMutableArray *) info;
- (id) initWithLogin: (NSString *) log;

- (void) putConnection: (User *) connection;
- (void) removeConnection: (User *) connection;
- (void) updateConnection: (User *) connection withNewStatus: (NSString *) status;
- (void) flush;

- (BOOL) isImageLoaded;
- (void) loadImage;
- (void) setIsImageLoaded: (BOOL) b;

@property (nonatomic, retain) NSMutableArray *infos;
@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) UIImage *img;
@property (nonatomic) BOOL    imgLoaded;



@end
