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

- (void) didReceivePaquetFromNS: (NSPacket *) packet;

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void) dealloc;
@end
