//
//  CollectionViewCell.h
//  NardinSoul
//
//  Created by Morgan Collino on 08/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSContact;
@protocol MenuViewProtocol <NSObject>

@optional
- (void) _showMenu;
- (void) _hideMenu;

@end

@interface CollectionViewCell : UICollectionViewCell
{
    UILabel *label;
    UIImageView *image;
    BOOL        isMenuShowed, dragging;
    float       oldX, oldY;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UIImageView *round;

@property (nonatomic, retain) id<MenuViewProtocol> delegate;

- (void) setContact: (NSContact *) contact;

@end
