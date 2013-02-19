//
//  ConversationViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 19/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "ConversationViewController.h"
#import "SSMessageTableViewCell.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) sendPushed: (id) sender
{
    NSLog(@"SEND PUSHED");
    UITextField *textfield = (UITextField *) _textField;
    
    if (![textfield.text isEqualToString: @""])
    {
        [arrayMsg addObject: textfield.text];
        [textfield setText: @""];
        [self.tableView reloadData];
        NSIndexPath * someRowAtIndexPath = [NSIndexPath indexPathForRow:[arrayMsg count] - 1 inSection: 0];
        [_tableView scrollToRowAtIndexPath:someRowAtIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
        [textfield resignFirstResponder];
}

#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    arrayMsg = [[NSMutableArray alloc] init];
    [_sendButton addTarget:self action: @selector(sendPushed:) forControlEvents: UIControlEventTouchUpInside];
	self.title = @"Messages";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}
	return YES;
}


#pragma mark SSMessagesViewController

- (SSMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row % 2) {
		return SSMessageStyleRight;
	}
	return SSMessageStyleLeft;
}


- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath {
	return ([arrayMsg objectAtIndex: indexPath.row]);
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayMsg count];
}


@end
