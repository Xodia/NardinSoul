//
//  SettingsViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 17/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *location;
    UITextField *comments;
    UITextField *server;
    UITextField *port;
}

@property (nonatomic, retain) IBOutlet UITextField *location;
@property (nonatomic, retain) IBOutlet UITextField *comments;
@property (nonatomic, retain) IBOutlet UITextField *server;
@property (nonatomic, retain) IBOutlet UITextField *port;

@end
