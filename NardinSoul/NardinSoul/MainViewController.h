//
//  MainViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 08/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetsoulViewProtocol.h"
@class NSPacket;

@interface MainViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, NetsoulViewProtocol>
{
    NSArray  *items;
    NSMutableArray *msgReceived;
}

- (void) didReceivePaquetFromNS: (NSPacket *) packet;


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end
