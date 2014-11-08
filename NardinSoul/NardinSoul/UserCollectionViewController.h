//
//  UserCollectionViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 09/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetsoulViewProtocol.h"

@interface UserCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, NetsoulViewProtocol>
{
    NSMutableArray *msg;
    NSMutableArray *items;
}

@property (nonatomic, retain) NSMutableArray *msg;

@end
