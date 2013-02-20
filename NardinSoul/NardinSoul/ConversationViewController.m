//
//  ConversationViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 19/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "ConversationViewController.h"
#import "SSMessageTableViewCell.h"
#import "NSPacket.h"
#import "User.h"
#import "NetsoulProtocol.h"
#import "MessageToken.h"
#import "NardinPool.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController


- (void) addMessage:(NSArray *)arrayMessages
{
    if (!arrayMsg)
        arrayMsg = [[NSMutableArray alloc] init];
    
    for (NSPacket *packet in arrayMessages)
    {
        NSString *msg = [[packet parameters] objectAtIndex: 0];
        msg = [msg stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        MessageToken *token = [[MessageToken alloc] initWithMessage:msg andFrom: YES];
        [arrayMsg addObject: token];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (void) setPacket:(NSPacket *)__packet
{
    _packet = __packet;
    
    if (!arrayMsg)
        arrayMsg = [[NSMutableArray alloc] init];
    
    NSString *msg = [[__packet parameters] objectAtIndex: 0];
    msg = [msg stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    MessageToken *token = [[MessageToken alloc] initWithMessage:msg andFrom: YES];
    [arrayMsg addObject: token];
}

*/
- (void) sendPushed: (id) sender
{
    NSLog(@"SEND PUSHED");
    UITextField *textfield = (UITextField *) _textField;
    
    if (![textfield.text isEqualToString: @""])
    {                
        MessageToken *token = [[MessageToken alloc] initWithMessage: textfield.text andFrom: NO];
        [arrayMsg addObject: token];
        
        [[NetsoulProtocol sharePointer] sendMsg: textfield.text to: @[self.title]];
        
        [textfield setText: @""];
        [self.tableView reloadData];
        NSIndexPath * someRowAtIndexPath = [NSIndexPath indexPathForRow:[arrayMsg count] - 1 inSection: 0];
        [_tableView scrollToRowAtIndexPath:someRowAtIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
        [textfield resignFirstResponder];
}

#pragma mark UIViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [[NetsoulProtocol sharePointer] setDelegate: self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    if (!arrayMsg)
        arrayMsg = [[NSMutableArray alloc] init];
    [_sendButton addTarget:self action: @selector(sendPushed:) forControlEvents: UIControlEventTouchUpInside];
	//self.title = [[_packet from] login];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}
	return YES;
}


#pragma mark SSMessagesViewController

- (SSMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageToken *token = (MessageToken *) [arrayMsg objectAtIndex: indexPath.row];
    
    if (!token)
        return SSMessageStyleLeft;
    
	if (!token.isExtern) {
		return SSMessageStyleRight;
	}
	return SSMessageStyleLeft;
}


- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageToken *token = (MessageToken *) [arrayMsg objectAtIndex: indexPath.row];
	return (token.msg);
    
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayMsg count];
}

- (void) dealloc
{
    if (arrayMsg)
        [arrayMsg release];

    [super dealloc];
}

- (void) didReceivePaquetFromNS:(NSPacket *)packet
{
    
}

- (void) didReceiveMessage:(NSPacket *)pkg
{
    if ([[[pkg from] login] isEqualToString: self.title])
    {
        NSString *msg = [[pkg parameters] objectAtIndex: 0];
        msg = [msg stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
        MessageToken *token = [[MessageToken alloc] initWithMessage:msg andFrom: YES];
        [arrayMsg addObject: token];
    
        [_tableView reloadData];
        NSIndexPath * someRowAtIndexPath = [NSIndexPath indexPathForRow:[arrayMsg count] - 1 inSection: 0];
        [_tableView scrollToRowAtIndexPath:someRowAtIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [[NardinPool sharedObject] removePacket: pkg];
    }
}


@end
