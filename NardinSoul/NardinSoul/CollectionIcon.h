//
//  CollectionIcon.h
//  NardinSoul
//
//  Created by Morgan Collino on 09/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionIcon : NSObject

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, retain) UIImageView *img;
@property (nonatomic) BOOL isLoad;

- (id)initWithPath: (NSString *) _path andKey: (NSString *) _key;
@end
