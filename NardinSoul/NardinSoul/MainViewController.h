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

@interface MainViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, NetsoulViewProtocol, UIAlertViewDelegate>
{
    NSArray  *items;
    NSMutableArray *msgReceived;
}

@end
