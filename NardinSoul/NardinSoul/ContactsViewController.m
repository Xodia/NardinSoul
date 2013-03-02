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
#import "CollectionViewCell.h"
#import "NSContact.h"

@interface ContactsViewController ()
{
    NSArray *items;
}


@end

@implementation ContactsViewController

- (void) didReceivePaquetFromNS:(NSPacket *)packet
{
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
        NSLog(@"Add contact: %@", [alertView textFieldAtIndex: 0].text);        
        [[NardinPool sharedObject] addContact: [alertView textFieldAtIndex:0].text];
        [items release];

        items = [[[[[NardinPool sharedObject] contactsInfo] allKeys] sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)]  retain];
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
    [self.navigationController.navigationBar setHidden: NO];
    
    [[NetsoulProtocol sharePointer] setDelegate: self];
    [super viewWillAppear: animated];
}


- (void)viewDidLoad
{    
    items = [[[[[NardinPool sharedObject] contactsInfo] allKeys] sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)]  retain];
    
    [super viewDidLoad];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action:@selector(addContact:)];
    
    [self.navigationItem setRightBarButtonItem: add];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    
    NSString *contact = [items objectAtIndex: (indexPath.section * 3) + indexPath.row];
    
    
    cell.label.text = contact;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://www.epitech.eu/intra/photos/%@.jpg", contact]]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [cell.image setImage: image];
        });
    });
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath: indexPath];
    NSString *login = [[cell label] text];
    NSLog(@"Selected: %@", login);
}


- (void) dealloc
{
    [items release];
    [super dealloc];
}

@end
