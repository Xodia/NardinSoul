//
//  UserCollectionViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 09/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "UserCollectionViewController.h"
#import "CollectionViewCell.h"
#import "RootViewController.h"
#import "NSPacket.h"
#import "NetsoulProtocol.h"
#import "CollectionIcon.h"
#import "MessageViewController.h"
#import "User.h"
#import "ConversationViewController.h"
#import "NardinPool.h"

@implementation UserCollectionViewController
@synthesize msg;

- (void) didReceivePaquetFromNS: (NSPacket *) packet
{
    /*if ([[packet command] isEqualToString: @"msg"])
    {
        if (!msg)
            msg = [[NSMutableArray alloc] init];
        if (!items)
            items = [[NSMutableArray alloc] init];
        [msg addObject: packet];
        NSString *str = [NSString stringWithFormat: @"https://www.epitech.eu/intra/photos/%@.jpg", [[packet from] login]];
        CollectionIcon *collection = [[CollectionIcon alloc] initWithPath: str andKey: [packet.from login]];
        
        [items addObject: collection];
        
        [[self collectionView] reloadData];
    }*/
}

- (void) didReceiveMessage:(NSPacket *)pkg
{
    NSMutableDictionary *dic = [[NardinPool sharedObject] messageReceived];
    
    NSLog(@"Count: %d/%d", [dic count], [items count]);
    
    if ([dic count] == [items count])
        return;
    
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    for (NSString *key in dic)
    {
        CollectionIcon *collection = [[CollectionIcon alloc] initWithPath: [NSString stringWithFormat:@"https://www.epitech.eu/intra/photos/%@.jpg", key] andKey: key];
        
        [a addObject: collection];
    }
    
    NSMutableArray *tmp = items;
    items = a;
    
    for (CollectionIcon *collection in tmp)
    {
        [tmp removeObject: collection];
        [collection release];
    }
    [tmp release];
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
        CollectionIcon *collection = [[CollectionIcon alloc] initWithPath: [NSString stringWithFormat:@"https://www.epitech.eu/intra/photos/%@.jpg", key] andKey: key];
            
        [items addObject: collection];
    }
    
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"DidReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.label.text = [icon key];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [icon path]]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [cell.image setImage: image];
        });
    });
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSPacket *packet = [msg objectAtIndex: indexPath.row];
    
    ConversationViewController *ctrl = [[ConversationViewController alloc] initWithNibName: nil bundle:nil];
    //[ctrl setPacket: packet];
    
    
   // NSPacket *pkt = [msg objectAtIndex: (indexPath.section * 3) + indexPath.row];
    CollectionIcon *icon = [items objectAtIndex: (indexPath.section * 3) + indexPath.row];
   // [msg removeObjectAtIndex: (indexPath.section * 3) + indexPath.row];

    NSArray *array = [[[NardinPool sharedObject] messageReceived] objectForKey: icon.key];
    [ctrl addMessage: array];
    [ctrl setTitle: icon.key];
    [items removeObjectAtIndex: (indexPath.section * 3) + indexPath.row];
    //[pkt release];
    [[NardinPool sharedObject] removeKey: icon.key];

    [icon release];
    
    [[self navigationController] pushViewController: ctrl animated:YES];
    
    
    [[self collectionView] reloadData];
    
}

- (void) dealloc
{
    if (msg)
        [msg release];
    if (items)
     [items release];
    [super dealloc];
}

@end
