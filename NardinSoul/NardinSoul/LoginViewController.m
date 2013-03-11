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
#import "SettingsViewController.h"
#import "ContactsViewController.h"
#import "NardinPool.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize login, password, req, settings, checkbox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isConnected = NO;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    @synchronized([NardinPool sharedObject])
    {
        [[NardinPool sharedObject] flushInfo];
    }
    
    NetsoulProtocol *netsoul = [NetsoulProtocol sharePointer];
    [[[self navigationController] navigationBar] setHidden: YES];

    [netsoul setDelegate: self];
    [super viewWillAppear: animated];
}

- (IBAction)launchSettingsView:(id)sender
{
    SettingsViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier: @"settingsViewController"];
    
    [[self navigationController] pushViewController: mainView animated: YES];
}

- (void)viewDidLoad
{
    [[self navigationController] navigationBar].tintColor = [UIColor grayColor];

    isChecked = false;
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
    if (isUp)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGRect bounds = [[self view] frame];
        bounds.origin.y += 100;
        [[self view] setFrame: bounds];
        [UIView commitAnimations];
        
        isUp = NO;
    }
    [login resignFirstResponder];
    [password resignFirstResponder];
    NetsoulProtocol *protocol = [NetsoulProtocol sharePointer];
    [protocol authentificateWithLogin: login.text andPassword: password.text];
}

- (void) didReceivePaquetFromNS: (NSPacket *) packet
{
    
}

- (IBAction)checkBoxTouched:(id)sender
{
    if (!isChecked)
    {
        [checkbox setImage: [UIImage imageNamed: @"checkbox_checked.png"] forState: UIControlStateNormal];
        isChecked = YES;
    }
    else
    {
        [checkbox setImage: [UIImage imageNamed: @"checkbox.png"] forState: UIControlStateNormal];
        isChecked = NO;
    }
}

- (void) didAuthentificate: (bool) real
{
    NSLog(@"Auth: %d", real ? 1 : 0);
    if (real)
    {
        ContactsViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier: @"contactsViewController"];
        [[NetsoulProtocol sharePointer] watchUsers:[[NardinPool sharedObject] contacts]];
        [[NetsoulProtocol sharePointer] whoUsers: [[NardinPool sharedObject] contacts]];
        [[self navigationController] pushViewController: mainView animated: YES];
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!isUp)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGRect bounds = [[self view] frame];
        bounds.origin.y -= 100;
        [[self view] setFrame: bounds];
        [UIView commitAnimations];

        isUp = YES;
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (isUp)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGRect bounds = [[self view] frame];
        bounds.origin.y += 100;
        [[self view] setFrame: bounds];
        [UIView commitAnimations];

        isUp = NO;
    }
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
    [checkbox release];
    [super dealloc];
}

@end
