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
{
    NSString *login;
    NSMutableArray *infos;
    UIImage *img;
    BOOL    imgLoaded;
}

- (id) initWithLogin: (NSString *) log andInfos: (NSMutableArray *) info;
- (id) initWithLogin: (NSString *) log;

- (void) putConnection: (User *) connection;
- (void) removeConnection: (User *) connection;
- (void) updateConnection: (User *) connection withNewStatus: (NSString *) status;
- (void) flush;

- (BOOL) isImageLoaded;
- (void) loadImage;
- (void) setIsImageLoaded: (BOOL) b;

@property (nonatomic, assign) NSMutableArray *infos;
@property (nonatomic, assign) NSString *login;
@property (nonatomic, retain) UIImage *img;


@end
