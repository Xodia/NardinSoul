//
//  UserDetailViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 03/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSContact;

@interface UserDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UILabel *login;
@property (nonatomic, retain) IBOutlet UIButton *toConversation;
@property (nonatomic, retain) IBOutlet UIButton *eraseContact;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSContact *user;

- (IBAction)pushToConversation:(id)sender;
@end
