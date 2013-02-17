//
//  SettingsViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 17/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
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
    
    [textField resignFirstResponder];
    return YES;
}

- (void) dealloc
{
    [_server release];
    [_port release];
    [_location release];
    [_comments release];
    
    [super dealloc];
}

@end
