//
//  LoginViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 08/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "NetsoulViewProtocol.h"

@interface LoginViewController : UIViewController <NetsoulViewProtocol, UITextFieldDelegate>
{
    UITextField *login;
    UITextField *password;
    BOOL        isConnected;
    UIButton    *req;
}

@property (nonatomic, retain) IBOutlet UITextField *login;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIButton *req;

- (IBAction)launchAuthentification:(id)sender;
- (void) didReceivePaquetFromNS: (NSPacket *) packet;
- (void) didAuthentificate: (bool) real;

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
@end
