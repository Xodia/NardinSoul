//
//  ContactsViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 26/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "ContactsViewController.h"
#import "NardinPool.h"
#import "NetsoulProtocol.h"
#import "NSPacket.h"
#import "User.h"
#import "NSContact.h"
#import "UserDetailViewController.h"
#import "UserCollectionViewController.h"
#import "CreditsViewController.h"

@interface ContactsViewController ()
{
    NSArray *items;
    
    NSMutableArray *menuItems;
    NSArray *keySelector;
    
    CGFloat oldX;
    CGFloat oldY;
    BOOL dragging;
}


@end

@implementation ContactsViewController

@synthesize tableView, collectionView;

- (void) didReceivePaquetFromNS:(NSPacket *)packet
{
    if ([[packet command] isEqualToString: @"msg"])
    {
        NSString *msg = [NSString stringWithFormat: @"Messages(%d)", [[NardinPool sharedObject] numbersOfMessage]];
            
            [menuItems setObject: msg atIndexedSubscript:0];
            [tableView reloadData];
    }
    
    if ([[packet command] isEqualToString: @"who"])
    {
        NSLog(@"From : %@ - Params: %@", [packet from], [packet parameters]);
        if ([[packet parameters] indexOfObject: @"end"] != NSNotFound)
            [[self collectionView] reloadData];
    }
}

- (void) didDisconnect
{
    [[self navigationController] popToRootViewControllerAnimated: YES];
}

- (void) addContact: (id) sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ajout contact" message:@"Login:" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Enter your name";
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[NardinPool sharedObject] addContact: [alertView textFieldAtIndex:0].text];
        [items release];

        items = [[NSArray alloc] initWithArray: [[[[NardinPool sharedObject] contactsInfo] allKeys] sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)]];
        
        [[NetsoulProtocol sharePointer] watchUsers: @[[alertView textFieldAtIndex: 0].text]];
        [[NetsoulProtocol sharePointer] whoUsers: @[[alertView textFieldAtIndex: 0].text]];
        [self.collectionView reloadData];
    }
    else
    {
        NSLog(@"user pressed Cancel");
    }
}




- (void) viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
    [self.navigationController.navigationBar setHidden: NO];
    [[NetsoulProtocol sharePointer] setDelegate: self];
    [super viewWillAppear: animated];
    isMenuShowed = NO;
    
    NSString *msg = [NSString stringWithFormat: @"Messages(%d)", [[NardinPool sharedObject] numbersOfMessage]];
    
    [menuItems setObject: msg atIndexedSubscript:0];
    [tableView reloadData];
}

- (void) _showMenu
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveLinear];
    [tableView setHidden: NO];
    
    CGRect bounds = [[self tableView] frame];
    bounds.origin.x += 216;
    [[self tableView] setFrame: bounds];
    
    bounds = [[self collectionView] frame];
    bounds.origin.x += 216;
    [[self collectionView] setFrame: bounds];
    
    [UIView commitAnimations];
    isMenuShowed = YES;
}

- (void) _hideMenu
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [tableView setHidden: NO];
    
    
    CGRect bounds = [[self tableView] frame];
    bounds.origin.x -= 216;
    [[self tableView] setFrame: bounds];
    
    bounds = [[self collectionView] frame];
    bounds.origin.x -= 216;
    [[self collectionView] setFrame: bounds];
    
    
    
    [UIView commitAnimations];
    isMenuShowed = NO;
}


- (IBAction)showMenu: (id) sender
{
    NSLog(@"Menu");
    if (!isMenuShowed)
        [self _showMenu];
    else
        [self _hideMenu];
    
}


- (void)viewDidLoad
{    
    //items = [[[[[NardinPool sharedObject] contactsInfo] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]  retain];
    
    self.title = @"NardinSoul";
    
    items = [[NSArray alloc] initWithArray: [[[[NardinPool sharedObject] contactsInfo] allKeys] sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)]];

    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"19-gear.png"];
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage: image style: UIBarButtonItemStyleBordered target:self action:@selector(showMenu:)];
    

    
    [self.navigationItem setLeftBarButtonItem: menu];
    
    [menu release];
    menuItems = [[NSMutableArray alloc] initWithArray: @[@"Messages", @"Ajouter un contact", @"Deconnexion", @"Informations"]];
    keySelector = [[NSArray alloc] initWithArray:@[@"toMessageView", @"addContact:", @"disconnect", @"toInformationView"]];

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touchSample = [[event allTouches] anyObject];
    CGPoint touchLocation = [touchSample locationInView:self.collectionView];
    
    if (CGRectContainsPoint(self.collectionView.frame, touchLocation))
    {
        dragging = YES;
        oldX = touchLocation.x;
        oldY = touchLocation.y;
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView: self.collectionView];
    
    
    if (CGRectContainsPoint(self.collectionView.frame, touchLocation) && dragging)
    {
        float x = oldX - touchLocation.x;
        if (x < 0 && !isMenuShowed)
            [self _showMenu];
        else if (isMenuShowed)
            [self _hideMenu];
        dragging = NO;
        NSLog(@"END");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int i = 0;
    
    i = [items count] % 3;

    return (([items count] / 3) + (i ? 1 : 0));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([items count] < ((section + 1) * 3))
        return ([items count] % 3);
    else
        return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    
    [cell setDelegate: self];
    
    NSString *contact = [items objectAtIndex: (indexPath.section * 3) + indexPath.row];
    NSContact *c = [[[NardinPool sharedObject] contactsInfo] objectForKey: contact];
    NSLog(@"Contact(c)=%@", c);

    if ([[c infos] count] > 0)
    {
        [cell.round setImage: [UIImage imageNamed: @"round_green.png"]];
    }
    else
    {
        [cell.round setImage: [UIImage imageNamed: @"round_red.png"]];
    }
    cell.label.text = contact;
    [cell.image setImage: c.img];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isMenuShowed)
        return [self _hideMenu];
    
    CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath: indexPath];
    NSString *login = [[cell label] text];
    
    UserDetailViewController *rootView = [[self storyboard] instantiateViewControllerWithIdentifier:@"userDetailViewController"];
    
    NSContact *u = [[[NardinPool sharedObject] contactsInfo] objectForKey: login];
    NSLog(@"U: %@", u);
    [u flush];
    [[NetsoulProtocol sharePointer] whoUsers: @[login]];
    [rootView setUser: u];
    [[self navigationController] pushViewController: rootView animated: YES];
    
}

- (void) toMessageView
{
    UserCollectionViewController *rootView = [[self storyboard] instantiateViewControllerWithIdentifier:@"userCollectionViewController"];
    [[self navigationController] pushViewController: rootView animated: YES];
}


- (void) disconnect
{
    [[NetsoulProtocol sharePointer] disconnect];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) toInformationView
{
    CreditsViewController  *rootView = [[self storyboard] instantiateViewControllerWithIdentifier:@"creditsViewController"];
    [[self navigationController] pushViewController: rootView animated: YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.textLabel setText: [menuItems objectAtIndex: indexPath.row]];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector: NSSelectorFromString([keySelector objectAtIndex: indexPath.row])];
}




- (void) dealloc
{
    [menuItems release];
    [keySelector release];
    [items release];
    [super dealloc];
}

@end
