//
//  CreditsViewController.h
//  NardinSoul
//
//  Created by Morgan Collino on 08/03/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditsViewController : UIViewController
{
    
}

@property (nonatomic, retain) IBOutlet UIButton *linkedin;
@property (nonatomic, retain) IBOutlet UIButton *twitter;
@property (nonatomic, retain) IBOutlet UIButton *epitech;


- (IBAction)routeToMediaLink:(id)sender;

@end
