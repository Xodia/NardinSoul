//
//  ConversationViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 19/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "ConversationViewController.h"
#import "NSPacket.h"
#import "User.h"
#import "NetsoulProtocol.h"
#import "MessageToken.h"
#import "NardinPool.h"
#import "Message.h"
#import "NSString+HTML.h"

@interface ConversationViewController ()
{
	JSQMessagesBubbleImage *incoming, *outgoing;
}
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
		
		JSQTextMessage *message = [[JSQTextMessage alloc] initWithSenderId: packet.from.location
														 senderDisplayName: packet.from.login
																	  date: [NSDate date]
																	  text: msg];
		
		
        [arrayMsg addObject: message];
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
/*
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
 */

#pragma mark UIViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [[NetsoulProtocol sharePointer] setDelegate: self];
}

/*
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
*/

- (void) addContact: (id) sender
{
   /* [[NardinPool sharedObject] addContact: self.title];
    [[NetsoulProtocol sharePointer] watchUsers: @[self.title]];
    [[NetsoulProtocol sharePointer] whoUsers: @[self.title]];
    
    [self.navigationItem setRightBarButtonItem: nil];*/
}

- (void)viewDidLoad
{
    
    if (!arrayMsg)
        arrayMsg = [[NSMutableArray alloc] init];
    
    //[self loadPreviousMessage];
	JSQMessagesBubbleImageFactory *factory = [[JSQMessagesBubbleImageFactory alloc] init];
	
	incoming = [factory incomingMessagesBubbleImageWithColor: [UIColor colorWithRed: 0.1 green:0.8 blue:0.1 alpha: 0.9]];
	outgoing = [factory outgoingMessagesBubbleImageWithColor: [UIColor colorWithRed:0.22 green:0.42 blue:0.66 alpha: 0.8]];
	[super viewDidLoad];
    
    //[_sendButton addTarget:self action: @selector(sendPushed:) forControlEvents: UIControlEventTouchUpInside];
    
    
    /*if (![[NardinPool sharedObject] isAContact: self.title])
    {
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addContact:)];
        [self.navigationItem setRightBarButtonItem:  add];
		add = nil;
	}*/
    
	//self.title = [[_packet from] login];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}
	return YES;
}


#pragma mark SSMessagesViewController
/*
- (SSMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageToken *token = (MessageToken *) [arrayMsg objectAtIndex: indexPath.row];
    
    if (!token)
        return SSMessageStyleLeft;
    
	if (!token.isExtern) {
		return SSMessageStyleRight;
	}
	return SSMessageStyleLeft;
}*/


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
	arrayMsg = nil;
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
    //[_tableView scrollToRowAtIndexPath:someRowAtIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
			JSQTextMessage *message = [[JSQTextMessage alloc] initWithSenderId: pkg.from.location
															 senderDisplayName: pkg.from.login
																		  date: [NSDate date]
																		  text: msg];
			
			
			[arrayMsg addObject: message];

			[self.collectionView reloadData];
			[self finishReceivingMessage];
            [[NardinPool sharedObject] removePacket: pkg];
            //[self performSelector:@selector(animation) withObject:nil afterDelay:0.3];
        }
    }
}


#pragma mark JSQMessagesCollectionViewDataSource



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [arrayMsg objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
	/**
	 *  You may return nil here if you do not want bubbles.
	 *  In this case, you should set the background color of your collection view cell's textView.
	 *
	 *  Otherwise, return your previously created bubble image data objects.
	 */
	
	JSQMessage *message = [arrayMsg objectAtIndex:indexPath.item];
	
	if ([message.senderId isEqualToString:self.senderId]) {
		return outgoing;
	}
	
	return incoming;
	
	return nil;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
	/**
	 *  Return `nil` here if you do not want avatars.
	 *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
	 *
	 *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
	 *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
	 *
	 *  It is possible to have only outgoing avatars or only incoming avatars, too.
	 */
	
	/**
	 *  Return your previously created avatar image data objects.
	 *
	 *  Note: these the avatars will be sized according to these values:
	 *
	 *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
	 *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
	 *
	 *  Override the defaults in `viewDidLoad`
	 */
	JSQMessage *message = [arrayMsg objectAtIndex:indexPath.item];
	
	/*if ([message.senderId isEqualToString:self.senderId]) {
		if (![NSUserDefaults outgoingAvatarSetting]) {
			return nil;
		}
	}
	else {
		if (![NSUserDefaults incomingAvatarSetting]) {
			return nil;
		}
	}
	
	
	return [self.demoData.avatars objectForKey:message.senderId];*/
	return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
	/**
	 *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
	 *  The other label text delegate methods should follow a similar pattern.
	 *
	 *  Show a timestamp for every 3rd message
	 */
	if (indexPath.item % 3 == 0) {
		JSQMessage *message = [arrayMsg objectAtIndex:indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
	}
	
	return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
	JSQMessage *message = [arrayMsg objectAtIndex:indexPath.item];
	
	/**
	 *  iOS7-style sender name labels
	 */
	if ([message.senderId isEqualToString:self.senderId]) {
		return nil;
	}
	
	if (indexPath.item - 1 > 0) {
		JSQMessage *previousMessage = [arrayMsg objectAtIndex:indexPath.item - 1];
		if ([[previousMessage senderId] isEqualToString:message.senderId]) {
			return nil;
		}
	}
	
	/**
	 *  Don't specify attributes to use the defaults.
	 */
	return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [arrayMsg count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	/**
	 *  Override point for customizing cells
	 */
	JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
	
	/**
	 *  Configure almost *anything* on the cell
	 *
	 *  Text colors, label text, label colors, etc.
	 *
	 *
	 *  DO NOT set `cell.textView.font` !
	 *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
	 *
	 *
	 *  DO NOT manipulate cell layout information!
	 *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
	 */
	
	JSQMessage *msg = [arrayMsg objectAtIndex:indexPath.item];
	
	if ([msg isKindOfClass:[JSQTextMessage class]]) {
		
		if ([msg.senderId isEqualToString:self.senderId]) {
			cell.textView.textColor = [UIColor whiteColor];
		}
		else {
			cell.textView.textColor = [UIColor whiteColor];
		}
		
		cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
											  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
	}
	
	return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
	/**
	 *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
	 */
	
	/**
	 *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
	 *  The other label height delegate methods should follow similarly
	 *
	 *  Show a timestamp for every 3rd message
	 */
	if (indexPath.item % 3 == 0) {
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	
	return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
	/**
	 *  iOS7-style sender name labels
	 */
	JSQMessage *currentMessage = [arrayMsg objectAtIndex:indexPath.item];
	if ([[currentMessage senderId] isEqualToString:self.senderId]) {
		return 0.0f;
	}
	
	if (indexPath.item - 1 > 0) {
		JSQMessage *previousMessage = [arrayMsg objectAtIndex:indexPath.item - 1];
		if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
			return 0.0f;
		}
	}
	
	return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
	return 0.0f;
}



#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
		   withMessageText:(NSString *)text
				  senderId:(NSString *)senderId
		 senderDisplayName:(NSString *)senderDisplayName
					  date:(NSDate *)date
{
	/**
	 *  Sending a message. Your implementation of this method should do *at least* the following:
	 *
	 *  1. Play sound (optional)
	 *  2. Add new id<JSQMessageData> object to your data source
	 *  3. Call `finishSendingMessage`
	 */
	[JSQSystemSoundPlayer jsq_playMessageSentSound];
	
	JSQTextMessage *message = [[JSQTextMessage alloc] initWithSenderId:senderId
													 senderDisplayName:senderDisplayName
																  date:date
																  text:text];
	
	[arrayMsg addObject:message];
	
	
	[[NetsoulProtocol sharePointer] sendMsg: text to: @[self.title]];
	
	NSManagedObjectContext *context = [[NetsoulProtocol sharePointer] managedObjectContext];
	
	
	Message *msg = [NSEntityDescription insertNewObjectForEntityForName: @"Message" inManagedObjectContext: context];
	msg.from = [NSString stringWithString:[[NetsoulProtocol sharePointer] loginNetsouled]];
	msg.to = [NSString stringWithString: self.title];
	msg.date = [NSDate date];
	
	msg.msg = [NSString stringWithString: text];
	
	
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Failed to save - error: %@", [error localizedDescription]);
	}

	
	[self finishSendingMessage];
}




#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
				header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
	NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
	NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}



@end
