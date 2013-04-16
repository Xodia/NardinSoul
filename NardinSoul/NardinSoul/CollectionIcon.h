//
//  CollectionIcon.h
//  NardinSoul
//
//  Created by Morgan Collino on 09/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionIcon : NSObject
{
    NSString *path;
    NSString *key;
    BOOL isLoad;
}

@property (nonatomic, assign) NSString *path;
@property (nonatomic, assign) NSString *key;
@property (nonatomic, assign) UIImageView *img;

- (id) initWithPath: (NSString *) _path andKey: (NSString *) _key;
- (void) dealloc;
@end
