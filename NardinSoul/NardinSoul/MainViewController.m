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
    
    // reset le tableau des outlets
    // Messages | Fonctionalite1 | Fonctionalite2 | Fonctionalite3 | GroupeX | + Ajout Groupe 
    
    items = [[NSArray alloc] initWithArray: @[@"Message", @"Who", @"Statut", @"Contacts", @"Recherche", @"Groupe1", @"+Ajout groupe", @"Deconnection"]];
    
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
    
    cell.label.text = [items objectAtIndex: (indexPath.section * 3) + indexPath.row] ;
    //cell.image.image = [UIImage imageNamed: @"nardin.jpg"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row: %d in section: %d", indexPath.row, indexPath.section);
        
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        RootViewController *rootView = [[self storyboard] instantiateViewControllerWithIdentifier:@"rootViewController"];
        [rootView setMsgReceived: msgReceived];
        
        [[self navigationController] pushViewController: rootView animated: YES];
    }
    
}

@end
