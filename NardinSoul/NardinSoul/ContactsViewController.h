//
//  ContactsViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 26/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetsoulViewProtocol.h"
#import "CollectionViewCell.h"

@class MenuViewController;

@interface ContactsViewController : UIViewController <NetsoulViewProtocol, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, MenuViewProtocol>
{
    BOOL                isMenuShowed;
}

- (IBAction)showMenu:(id)sender;

@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) IBOutlet UICollectionView *collectionView;

@end
