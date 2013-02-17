//
//  LoginViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 08/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "LoginViewController.h"
#import "NetsoulProtocol.h"
#import "RootViewController.h"
#import "MainViewController.h"
#import "SettingsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize login, password, req, settings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isConnected = NO;
    }
    return self;
}

- (IBAction)launchSettingsView:(id)sender
{
    SettingsViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier: @"settingsViewController"];
    
    [[self navigationController] pushViewController: mainView animated: YES];
}

- (void)viewDidLoad
{
    NetsoulProtocol *netsoul = [NetsoulProtocol sharePointer];
    [netsoul resetSocketWithPort: 4242 andAdress: @"ns-server.epita.fr"];
    
    [netsoul setDelegate: self];
    [netsoul connect];
    [super viewDidLoad];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *log = [prefs stringForKey:@"login"];
    NSString *pass = [prefs stringForKey:@"pass"];
    
    if (log)
        [login setText: log];
    if (pass)
            [password setText: pass];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchAuthentification:(id)sender
{
    NetsoulProtocol *protocol = [NetsoulProtocol sharePointer];
    [protocol authentificateWithLogin: login.text andPassword: password.text];
}

- (void) didReceivePaquetFromNS: (NSPacket *) packet
{
    
}

- (void) didAuthentificate: (bool) real
{
    if (real)
    {
        MainViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier: @"mainViewController"];
        
        [[self navigationController] pushViewController: mainView animated: YES];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) dealloc
{
    [login release];
    [password release];
    [req release];
    [settings release];
    [super dealloc];
}

@end
