//
//  UserCollectionViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 09/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "UserCollectionViewController.h"
#import "CollectionViewCell.h"
#import "NSPacket.h"
#import "NetsoulProtocol.h"
#import "CollectionIcon.h"
#import "User.h"
#import "ConversationViewController.h"
#import "NardinPool.h"
#import "NSContact.h"

@implementation UserCollectionViewController
@synthesize msg;

- (void) didReceivePaquetFromNS: (NSPacket *) packet
{
    if ([[packet command] isEqualToString: @"msg"])
    {
        if (!msg)
            msg = [[NSMutableArray alloc] init];
        if (!items)
            items = [[NSMutableArray alloc] init];
        [msg addObject: packet];
        NSString *str = [NSString stringWithFormat: @"http://cdn.local.epitech.net/userprofil/profilview/%@.jpg", [[packet from] login]];
        CollectionIcon *collection = [[CollectionIcon alloc] initWithPath: str andKey: [packet.from login]];
        
        [items addObject: collection];
        
        [[self collectionView] reloadData];
    }
}

- (void) didReceiveMessage:(NSPacket *)pkg
{
    NSMutableDictionary *dic = [[NardinPool sharedObject] messageReceived];
        
    if ([dic count] == [items count])
        return [self.collectionView reloadData];
    
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    for (NSString *key in dic)
    {
        CollectionIcon *collection = [[CollectionIcon alloc] initWithPath: [NSString stringWithFormat:@"http://cdn.local.epitech.net/userprofil/profilview/%@.jpg", key] andKey: key];
        
        [a addObject: collection];
    }
    
    NSMutableArray *tmp = items;

	items = a;
    for (CollectionIcon *collection in tmp)
    {
        [tmp removeObject: collection];
    }
    tmp = nil;
    [self.collectionView reloadData];
}

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
	self.title = @"Messagerie";
	// Do any additional setup after loading the view.
}


- (void) viewWillAppear:(BOOL)animated
{
    [[[self navigationController] navigationBar] setHidden: NO];
    NetsoulProtocol *n = [NetsoulProtocol sharePointer];
    [n setDelegate: self];
    
    if (!items)
        items = [[NSMutableArray alloc] init];
    // release les ptrs
    
    [items removeAllObjects];
    NSMutableDictionary *dic = [[NardinPool sharedObject] messageReceived];
    
    for (NSString *key in dic)
    {
        CollectionIcon *collection = [[CollectionIcon alloc] initWithPath: [NSString stringWithFormat:@"http://cdn.local.epitech.net/userprofil/profilview/%@.jpg", key] andKey: key];
            
        [items addObject: collection];
    }
    
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    //NSLog(@"DidReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didDisconnect
{
    [[self navigationController] popToRootViewControllerAnimated: YES];
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
    else if ([items count] != 0)
        return 3;
    else
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    CollectionIcon *icon = [items objectAtIndex: (indexPath.section * 3) + indexPath.row];
    NSArray *array = [[[NardinPool sharedObject] messageReceived] objectForKey: icon.key];
    
    cell.label.text = [NSString stringWithFormat: @"%@(%ld)", [icon key], (long)[array count]];

    NSContact *c = [[[NardinPool sharedObject] contactsInfo] objectForKey: [icon key]];

    if (c)
        [cell.image setImage: c.img];
    else if (icon)
        [cell.image setImage: icon.img.image];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    ConversationViewController *ctrl = [[ConversationViewController alloc] initWithNibName: nil bundle:nil];
    CollectionIcon *icon = [items objectAtIndex: (indexPath.section * 3) + indexPath.row];

    NSArray *array = [[[NardinPool sharedObject] messageReceived] objectForKey: icon.key];
    [ctrl addMessage: array];
    [ctrl setTitle: icon.key];
    [items removeObjectAtIndex: (indexPath.section * 3) + indexPath.row];
    [[NardinPool sharedObject] removeKey: icon.key];
    icon = nil;

    [[self navigationController] pushViewController: ctrl animated:YES];
    [[self collectionView] reloadData];
}

- (void) dealloc
{
    if (msg)
        msg = nil;;
    if (items)
        items = nil;;
    //[super dealloc];
}

@end
