//
//  CreditsViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 08/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()

@end

@implementation CreditsViewController

@synthesize twitter, linkedin, epitech;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)routeToMediaLink:(id)sender
{
    UIButton *b = (UIButton *) sender;
    NSString *urlS = @"";
    if (b.tag == 0)
        urlS =  @"twitter://user?screen_name=Xod_CM";
    if (b.tag == 1)
        urlS = @"http://fr.linkedin.com/pub/morgan-collino/30/672/256/";
    if (b.tag == 2)
        urlS = @"https://intra.epitech.eu/user/collin_m/";
    
    NSURL *url = [NSURL URLWithString: urlS];
    if (url)
        [[UIApplication sharedApplication] openURL:url];
}

- (void)viewDidLoad
{
    self.title = @"Informations";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [twitter release];
    [linkedin release];
    [epitech release];
    [super dealloc];
}

@end
