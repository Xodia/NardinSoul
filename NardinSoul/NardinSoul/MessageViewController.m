//
//  MessageViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 05/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "MessageViewController.h"
#import "User.h"
#import "NSPacket.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

@synthesize packet, lcmd, lparams, lfrom;

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
    User *user = [packet from];
    NSString *login = [user login];
    NSString *paramsString = [[[packet parameters] objectAtIndex: 0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *cmdString = [packet command];
    
    [lcmd setText: cmdString];
    [lparams setText: paramsString];
    [lfrom setText: login];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [[[self navigationController] navigationBar] setHidden: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [lcmd release];
    [lparams release];
    [lfrom release];
    [packet release];
    [super dealloc];
}

@end
