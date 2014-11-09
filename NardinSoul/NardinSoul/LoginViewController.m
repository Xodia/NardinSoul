//
//  LoginViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 08/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "LoginViewController.h"
#import "NetsoulProtocol.h"
#import "SettingsViewController.h"
#import "ContactsViewController.h"
#import "NardinPool.h"
#import "Contact.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)


@interface LoginViewController ()
{
    NSArray *arrTextfield;
}

@end

@implementation LoginViewController

@synthesize login, password, req, settings, checkbox, activity, checkboxLabel, passLabel, loginLabel;

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
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    @synchronized([NardinPool sharedObject])
    {
        [[NardinPool sharedObject] flushInfo];
    }
    
    NetsoulProtocol *netsoul = [NetsoulProtocol sharePointer];
    [[[self navigationController] navigationBar] setHidden: YES];

    [netsoul setDelegate: self];
    [super viewWillAppear: animated];
    isConnected = NO;
    
}

- (IBAction)launchSettingsView:(id)sender
{
    SettingsViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier: @"settingsViewController"];
    
    [[self navigationController] pushViewController: mainView animated: YES];
}

- (void) viewWillLayoutSubviews
{
    if (IS_IPHONE5)
    {
        [self.login setFrame: CGRectMake(84, 249, 197, 30)];
        [self.password setFrame: CGRectMake(84, 318, 197, 30)];
        [self.req setFrame: CGRectMake(193, 384, 91, 29)];
        [self.checkbox setFrame: CGRectMake(15, 429, 25, 25)];
        [self.loginLabel setFrame: CGRectMake(15, 253, 61, 21)];
        [self.passLabel setFrame: CGRectMake(15, 326, 42, 22)];
        [self.checkboxLabel setFrame: CGRectMake(50, 429, 144, 21)];
        [self.activity setFrame: CGRectMake(151, 491, 20, 20)];
        [self.settings setFrame: CGRectMake(282, 507, 18, 19)];
    }
}

- (void)viewDidLoad
{
   [[self navigationController] navigationBar].tintColor = [UIColor colorWithRed: 0 green: 99.0/255.0 blue: 205.0/255.0 alpha: 1];
    isChecked = false;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    if (![prefs objectForKey: @"server"])
        [prefs setObject: @"ns-server.epita.fr" forKey:@"server"];
    if (![prefs objectForKey: @"port"])
        [prefs setObject: @"4242" forKey:@"port"];
    if (![prefs objectForKey: @"location"])
        [prefs setObject: @"@NSoul.v1.1" forKey:@"location"];
    if (![prefs objectForKey: @"comments"])
        [prefs setObject: @"Somewhere on earth !" forKey:@"comments"];

    NetsoulProtocol *netsoul = [NetsoulProtocol sharePointer];
    //[netsoul resetSocketWithPort: 4242 andAdress: @"ns-server.epita.fr"];
    
    [netsoul setDelegate: self];
    [super viewDidLoad];
    arrTextfield = [[NSArray alloc] initWithObjects: login, password, nil];
	
    NSString *log = [prefs stringForKey:@"login"];
    NSString *pass = [prefs stringForKey:@"pass"];
    
    BOOL is = [prefs boolForKey: @"checkbox"];
    if (is)
    {
        [checkbox setImage: [UIImage imageNamed: @"icon-checked.png"] forState: UIControlStateNormal];
        isChecked = YES;

        if (log)
            [login setText: log];
        if (pass)
            [password setText: pass];
    }
	
	if (log && pass)
	{
		// try autologin
		// I know, not the sexiest way to do it :P
		[self launchAuthentification: nil];
	}
    
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
    [activity startAnimating];
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    if (!isChecked)
    {
        [checkbox setImage: [UIImage imageNamed: @"icon-checked.png"] forState: UIControlStateNormal];
        isChecked = YES;
        [prefs setBool: YES forKey: @"checkbox"];
    }
    else
    {
        [checkbox setImage: [UIImage imageNamed: @"icon-unchecked.png"] forState: UIControlStateNormal];
        isChecked = NO;
        [prefs setBool: NO forKey: @"checkbox"];
    }
}

- (void) didAuthentificate: (NSNumber *) real
{
	NSLog(@"DidAuthenticate: %@", real);
	
    [activity stopAnimating];
    if (real.integerValue)
    {
        if (!isChecked)
        {
            login.text = @"";
            password.text = @"";
        }
        
        [[NardinPool sharedObject] flushInfo];
        
        ContactsViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier: @"contactsViewController"];
        
        [[NardinPool sharedObject] createAccount: [[NetsoulProtocol sharePointer] loginNetsouled]];
        
        NSSet *set = [[NardinPool sharedObject] contacts];
        NSArray *arr = [set allObjects];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (Contact *c in arr)
        {
			if ([c contactName])
				[array addObject: [c contactName]];
        }
        
        [[NetsoulProtocol sharePointer] watchUsers: array];
        [[NetsoulProtocol sharePointer] whoUsers: array];
		array = nil;
		
        [mainView setItem: [[NSArray alloc] initWithArray: [[[[NardinPool sharedObject] contactsInfo] allKeys] sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)]]];
        [[self navigationController] pushViewController: mainView animated: YES];
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{    
    for (UITextField *t in arrTextfield)
        if (t != textField)
            [t setBackground: [UIImage imageNamed: @"white_form.png"]];
    [textField setBackground: [UIImage imageNamed: @"blue_form.png"]];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect bounds = [[self view] frame];
    float b = 216.0 - ([[self view] frame].size.height - (textField.frame.origin.y + textField.frame.size.height));
    if (b > 0.0)
        bounds.origin.y = b * -1;
    [[self view] setFrame: bounds];
    [UIView commitAnimations];
    
    isUp = YES;

    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    for (UITextField *t in arrTextfield)
        if (t != textField)
            [t setBackground: [UIImage imageNamed: @"white_form.png"]];
    [textField setBackground: [UIImage imageNamed: @"blue_form.png"]];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField setBackground: [UIImage imageNamed: @"white_form.png"]];
    [textField resignFirstResponder];
    
    if (isUp)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGRect bounds = [[self view] frame];
        bounds.origin.y = 0;
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
    login = nil;
    password = nil;
    req = nil;
    settings = nil;
    checkbox = nil;
    loginLabel = nil;
    passLabel = nil;
    checkboxLabel = nil;
    arrTextfield = nil;
}

@end
