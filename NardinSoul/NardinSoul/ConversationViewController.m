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
#import "Message.h"
#import "NSString+HTML.h"

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
        msg = [msg stringByDecodingHTMLEntities];
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
    UITextField *textfield = (UITextField *) _textField;
    
    if (![textfield.text isEqualToString: @""])
    {                
        MessageToken *token = [[MessageToken alloc] initWithMessage: textfield.text andFrom: NO];
        [arrayMsg addObject: token];
        
        [[NetsoulProtocol sharePointer] sendMsg: textfield.text to: @[self.title]];
    
        NSManagedObjectContext *context = [[NetsoulProtocol sharePointer] managedObjectContext];
        
        
        Message *message = [[NSEntityDescription insertNewObjectForEntityForName: @"Message" inManagedObjectContext: context] retain];
        message.from = [NSString stringWithString:[[NetsoulProtocol sharePointer] loginNetsouled]];
        message.to = [NSString stringWithString: self.title];
        message.date = [NSDate date];

        message.msg = [NSString stringWithString: textfield.text];
        
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
        
        [message release];
        
        
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

- (void) loadPreviousMessage
{
    NSManagedObjectContext *context = [[NetsoulProtocol sharePointer] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message"
                                              inManagedObjectContext: context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit: 5];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date"
                                        ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(to == %@ AND from == %@) OR (to == %@ AND from == %@)", [[NetsoulProtocol sharePointer] loginNetsouled], self.title, self.title,[[NetsoulProtocol sharePointer] loginNetsouled]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchResults = [context
                             executeFetchRequest:fetchRequest
                             error:&error];
    
    
    NSArray *reversed = [[fetchResults reverseObjectEnumerator] allObjects];
    for (Message *msg in reversed)
    {
        if (msg.msg)
        {
            MessageToken *token = [[MessageToken alloc] initWithMessage:msg.msg andFrom: [msg.from isEqualToString: self.title] ? YES : NO];
            [arrayMsg addObject: token];
        }
    }
}

- (void) addContact: (id) sender
{
    [[NardinPool sharedObject] addContact: self.title];
    [[NetsoulProtocol sharePointer] watchUsers: @[self.title]];
    [[NetsoulProtocol sharePointer] whoUsers: @[self.title]];
    
    [self.navigationItem setRightBarButtonItem: nil];
}

- (void)viewDidLoad
{
    
    if (!arrayMsg)
        arrayMsg = [[NSMutableArray alloc] init];
    
    //[self loadPreviousMessage];
    
    
	[super viewDidLoad];
    
    [_sendButton addTarget:self action: @selector(sendPushed:) forControlEvents: UIControlEventTouchUpInside];
    
    
    if (![[NardinPool sharedObject] isAContact: self.title])
    {
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addContact:)];
        [self.navigationItem setRightBarButtonItem:  add];
        [add release];
    }
    
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
    {
        [arrayMsg release];
    }

    [super dealloc];
}

- (void) didReceivePaquetFromNS:(NSPacket *)packet
{
    
}

- (void) didDisconnect
{
    [[self navigationController] popToRootViewControllerAnimated: YES];
}

- (void) animation
{
    NSIndexPath * someRowAtIndexPath = [NSIndexPath indexPathForRow:[arrayMsg count] - 1 inSection: 0];
    [_tableView scrollToRowAtIndexPath:someRowAtIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void) didReceiveMessage:(NSPacket *)pkg
{
    if ([[[pkg from] login] isEqualToString: self.title])
    {
        NSString *msg = [[pkg parameters] objectAtIndex: 0];
        msg = [msg stringByReplacingPercentEscapesUsingEncoding: NSISOLatin1StringEncoding];
        msg = [msg stringByDecodingHTMLEntities];
        if (msg)
        {
            MessageToken *token = [[MessageToken alloc] initWithMessage:msg andFrom: YES];
            [arrayMsg addObject: token];
            [_tableView reloadData];
            [[NardinPool sharedObject] removePacket: pkg];
            [self performSelector:@selector(animation) withObject:nil afterDelay:0.3];
        }
    }
}



@end
