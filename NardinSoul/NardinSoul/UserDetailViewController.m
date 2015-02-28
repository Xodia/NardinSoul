//
//  UserDetailViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 03/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "UserDetailViewController.h"
#import "NSContact.h"
#import "User.h"
#import "ConversationViewController.h"
#import "NetsoulProtocol.h"
#import "ConnectionDetailCell.h"
#import "NSPacket.h"
#import "NardinPool.h"
#import "UIImageView_XDShape.h"
#import "UIButton_XDShape.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface UserDetailViewController ()
{
    NSArray *items;
}

@end

@implementation UserDetailViewController

@synthesize user = _user, eraseContact = _eraseContact, login = _login, image = _image, toConversation = _toConversation, round = _round, connected = _connected, tableView = _tableView, line = _line;

- (void) didReceivePaquetFromNS:(NSPacket *)packet
{
   // NSLog(@"Packetcmd: %@", packet.command);
    if (([[packet command] isEqualToString: @"state"] || [[packet command] isEqualToString: @"logout"]) && [[[packet from] login] isEqualToString: _user.login])
    {
        NSContact *c = [[[NardinPool sharedObject] contactsInfo] objectForKey: [packet.from login]];
        if (c)
            [c flush];
        [[NetsoulProtocol sharePointer] whoUsers: @[[[packet from] login]]];
    }
}

- (void) didDisconnect
{
    [[self navigationController] popToRootViewControllerAnimated: YES];
}

- (void) didReceiveWhoInformations:(NSPacket *)info
{
    //NSLog(@"Infos: %@",_user.infos);
   if ([[info parameters] count] >= 2 && [[[info parameters] objectAtIndex: 1] isEqualToString: _user.login])
    {
        if ([_user infos])
        {
			items = nil;
			items = [[NSArray alloc] initWithArray:[_user infos]];
            [[self tableView] reloadData];
            
            if ([items count] > 0)
            {
                //NSLog(@"Count :%d", items.count);
                if ([items count] < 3 && !IS_IPHONE5)
                {
                    [_tableView setScrollEnabled: NO];
                    
                    [_tableView setHidden: NO];
                    int sz = ((int)[items count]) * 102;
                    int pos = 125;
                    
                    CGRect frame = [_tableView frame];
                    frame.size.height = sz;
                    frame.origin.y = pos;
                    [_tableView setFrame: frame];
                }
                else if ([items count] < 4 && IS_IPHONE5)
                {
                    [_tableView setScrollEnabled: NO];
                    
                    [_tableView setHidden: NO];
					int sz = ((int)[items count]) * 102;
                    int pos = 136;
                    CGRect frame = [_tableView frame];
                    frame.size.height = sz;
                    frame.origin.y = pos;
                    [_tableView setFrame: frame];
                }
                else
                {
                    [_tableView setScrollEnabled: YES];

                    [_tableView setHidden: NO];                        
                    int sz = 291 + (IS_IPHONE5 ? 77 : 0);
                    CGRect frame = [_tableView frame];
                    
                    if (IS_IPHONE5)
                        frame.origin.y = 136;
                    frame.size.height = sz;
                    [_tableView setFrame: frame];
                }
                [_round setImage: [UIImage imageNamed: @"rect_green.png"]];
                [_connected setText: @"connected"];
            }
            else
            {
                [_round setImage: [UIImage imageNamed: @"rect_red.png"]];
                [_connected setText: @"disconnected"];
				
            }
			[_round toRoundImageView];
        }
		[_round toRoundImageView];
	}
}

- (IBAction)pushToConversation:(id)sender
{
    ConversationViewController *ctrl = [[ConversationViewController alloc] initWithNibName:nil bundle:nil];
	NSLog(@"Login : %@", self.title);
	[ctrl setTitle: self.title]; // login
    [[self navigationController] pushViewController: ctrl animated: YES];
    ctrl = nil;
}

- (IBAction)addRemoveContact:(id)sender
{
    if ([[NardinPool sharedObject] isAContact: self.title])
	{
        [[NardinPool sharedObject] removeContact: self.title];
		[self.navigationController popViewControllerAnimated: YES];
	}
    else
        [[NardinPool sharedObject] addContact: self.title];
    [self putRightButton: [[NardinPool sharedObject] isAContact: self.title]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden: NO];
    [[NetsoulProtocol sharePointer] setDelegate: self];
    [super viewWillAppear: animated];
}

- (void)viewDidLoad
{
    items = [[NSArray alloc] initWithArray:[_user infos]];
    
    [super viewDidLoad];

	
    [_tableView setHidden: YES];
    self.title = _user.login;
    [_login setText: _user.login];
    [_image setImage: _user.img];
	[_toConversation toRoundImageView];
	[_eraseContact toRoundImageView];
	[_image toRoundImageView];

    [[NetsoulProtocol sharePointer] whoUsers: @[_user.login]];
    
    [self putRightButton:[[NardinPool sharedObject] isAContact: self.title]];
}

- (void)putRightButton:(BOOL)b {

	NSString *s = b ? @"cross.png" : @"icon-add.png";
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, 30, 30)];
    [bt setImage:[UIImage imageNamed:s] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(addRemoveContact:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:bt];
    [self.navigationItem setRightBarButtonItem: leftButton];
	leftButton = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ConnectionDetailCell *cell = (ConnectionDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    User *u = [items objectAtIndex: indexPath.row];    

    [cell printUser: u];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
