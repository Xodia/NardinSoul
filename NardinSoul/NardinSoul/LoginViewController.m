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

- (void)viewWillAppear:(BOOL)animated
{
    NetsoulProtocol *netsoul = [NetsoulProtocol sharePointer];
    //[netsoul resetSocketWithPort: 4242 andAdress: @"ns-server.epita.fr"];
    
    [netsoul setDelegate: self];
}

- (void)viewDidLoad
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (![prefs objectForKey: @"server"])
        [prefs setObject: @"ns-server.epita.fr" forKey:@"server"];
    if (![prefs objectForKey: @"port"])
        [prefs setObject: @"4242" forKey:@"port"];
    if (![prefs objectForKey: @"location"])
        [prefs setObject: @"@NardinSoul.v1" forKey:@"location"];
    if (![prefs objectForKey: @"comments"])
        [prefs setObject: @"Somewhere on earth !" forKey:@"comments"];

    NetsoulProtocol *netsoul = [NetsoulProtocol sharePointer];
    //[netsoul resetSocketWithPort: 4242 andAdress: @"ns-server.epita.fr"];
    
    [netsoul setDelegate: self];
    [super viewDidLoad];
    
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
    NSLog(@"Auth: %d", real ? 1 : 0);
    if (real)
    {
        MainViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier: @"mainViewController"];
        
        [[self navigationController] pushViewController: mainView animated: YES];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (textField == password)
        [prefs setObject: password.text forKey: @"pass"];
    if (textField == login)
        [prefs setObject: login.text forKey: @"login"];
    
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
