//
//  MainViewController.m
//  NardinSoul
//
//  Created by Morgan Collino on 08/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "MainViewController.h"
#import "CollectionViewCell.h"
#import "RootViewController.h"
#import "NSPacket.h"
#import "NetsoulProtocol.h"
#import "CollectionIcon.h"
#import "UserCollectionViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void) didReceivePaquetFromNS: (NSPacket *) packet
{
    if ([[packet command] isEqualToString: @"msg"])
    {
        if (!msgReceived)
            msgReceived = [[NSMutableArray alloc]init];
        [msgReceived addObject: packet];

       CollectionViewCell *cell = (CollectionViewCell *) [[self collectionView] cellForItemAtIndexPath: [NSIndexPath indexPathForItem: 0 inSection:0]];
        [[cell label] setText: [NSString stringWithFormat: @"Messages(%d)", [msgReceived count]]];
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void) viewWillAppear:(BOOL)animated
{
    [[[self navigationController] navigationBar] setHidden: YES];
    NetsoulProtocol *n = [NetsoulProtocol sharePointer];
    [n setDelegate: self];
    CollectionViewCell *cell = (CollectionViewCell *) [[self collectionView] cellForItemAtIndexPath: [NSIndexPath indexPathForItem: 0 inSection:0]];
    [[cell label] setText: [NSString stringWithFormat: @"Messages(%d)", [msgReceived count]]];

    
    // reset le tableau des outlets
    // Messages | Fonctionalite1 | Fonctionalite2 | Fonctionalite3 | GroupeX | + Ajout Groupe 
    
    if (!items)
    {
        CollectionIcon *obj1 = [[CollectionIcon alloc] initWithPath: @"msg.png" andKey: @"Message"];
        CollectionIcon *obj2 = [[CollectionIcon alloc] initWithPath: @"who.png" andKey: @"Who"];
        CollectionIcon *obj3 = [[CollectionIcon alloc] initWithPath: @"statut.png" andKey: @"Statut"];
        CollectionIcon *obj4 = [[CollectionIcon alloc] initWithPath: @"contacts.png" andKey: @"Contact"];
        CollectionIcon *obj5 = [[CollectionIcon alloc] initWithPath: @"search.png" andKey: @"Recherhe"];
        CollectionIcon *obj6 = [[CollectionIcon alloc] initWithPath: @"star.png" andKey: @"Groupe"];
        CollectionIcon *obj7 = [[CollectionIcon alloc] initWithPath: @"plus.png" andKey: @"Ajouter un groupe"];
        CollectionIcon *obj8 = [[CollectionIcon alloc] initWithPath: @"exit.png" andKey: @"Deconnection"];

        items = [[NSArray alloc] initWithArray: @[obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8]];

    }
    
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning
{
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
    NSLog(@"nbItemsInSection: %d", [items count] - (section * 3));

    if ([items count] < ((section + 1) * 3))
        return ([items count] % 3);
    else
        return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Bird *bird = [birds objectAtIndex:(indexPath.section*2 + indexPath.row)];
    cell.label.text = bird.birdName;
    cell.imageView.image = [UIImage imageNamed:bird.imageName];*/
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    NSLog(@"Init: %d", (indexPath.section * 3) + indexPath.row);
    
    CollectionIcon *icon = [items objectAtIndex: (indexPath.section * 3) + indexPath.row];
    
    cell.label.text = [icon key];
    cell.image.image = [UIImage imageNamed: [icon path]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{        
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        UserCollectionViewController *rootView = [[self storyboard] instantiateViewControllerWithIdentifier:@"userCollectionViewController"];
        [rootView setMsg: msgReceived];
        
        [[self navigationController] pushViewController: rootView animated: YES];
    }
    
}

@end
