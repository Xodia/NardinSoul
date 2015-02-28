//
//  CollectionViewCell.m
//  NardinSoul
//
//  Created by Morgan Collino on 08/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "CollectionViewCell.h"
#import "NSContact.h"
#import "UIImageView_XDShape.h"
#import "UIImage+XDShape.h"

@implementation CollectionViewCell

@synthesize label, image, round, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touchSample = [[event allTouches] anyObject];
    CGPoint touchLocation = [touchSample locationInView: self.window];
    
    if (CGRectContainsPoint(self.window.frame, touchLocation))
    {
        dragging = YES;
        oldX = touchLocation.x;
        oldY = touchLocation.y;
    }
    [super touchesBegan: touches withEvent: event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView: self.window];
    
    
    if (CGRectContainsPoint(self.window.frame, touchLocation) && dragging)
    {
        float x = oldX - touchLocation.x;
        if (x < 0 && !isMenuShowed && [delegate respondsToSelector: @selector(_showMenu)])
            [delegate _showMenu];
       
        dragging = NO;
    }
    [super touchesMoved: touches withEvent: event];
}

- (void)setContact:(NSContact *)contact
{    
    if ([[contact infos] count] > 0) {
        [round setImage: [UIImage imageNamed: @"rect_green.png"]];
    }
    else {
        [round setImage: [UIImage imageNamed: @"rect_red.png"]];
    }
	[round toRoundImageView];
    label.text = contact.login;
    
	if (contact.isImageLoaded && contact.img) {
        [image setImage: contact.img];
		[image toRoundImageView];
	}
    else {
		__weak typeof(self)weakSelf = self;
		__weak typeof(contact)weakContact = contact;
		[UIImage loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.local.epitech.net/userprofil/profilview/%@.jpg", contact.login]] callback:^(UIImage *iimage) {
			if (iimage) {
				[weakSelf.image setImage:iimage];
				weakContact.img = iimage;
				weakContact.isImageLoaded = YES;
			} else {
				[weakSelf.image setImage: [UIImage imageNamed: @"no.jpg"]];
				weakContact.isImageLoaded = YES;
			}
			[weakSelf.image toRoundImageView];
		}];
		
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
