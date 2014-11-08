//
//  SettingsViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 17/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    NSArray *arrTextfield;
    BOOL isUp;
}
@end

@implementation SettingsViewController

@synthesize location = _location, port = _port, server = _server, comments = _comments;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [[[self navigationController] navigationBar] setHidden: NO];

    [super viewWillAppear: animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrTextfield = [[NSArray alloc] initWithObjects:_location, _port, _server, _comments, nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    [_location setText: [prefs stringForKey: @"location"]];
    [_port setText: [prefs stringForKey: @"port"]];
    [_comments setText: [prefs stringForKey: @"comments"]];
    [_server setText: [prefs stringForKey: @"server"]];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
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
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    for (UITextField *t in arrTextfield)
        [textField setBackground: [UIImage imageNamed: @"white_form.png"]];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    switch (textField.tag)
    {
        case 0:
            [prefs setObject: [textField text] forKey:@"server"];
            break;
        case 1:
            [prefs setObject: [textField text] forKey:@"port"];
            break;
        case 2:
            [prefs setObject: [textField text] forKey:@"location"];
            break;
        case 3:
            [prefs setObject: [textField text] forKey:@"comments"];
            break;
        default:
            break;
    }
    
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
    
    [textField resignFirstResponder];
    return YES;
}


@end
