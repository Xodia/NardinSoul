//
//  CollectionViewCell.m
//  NardinSoul
//
//  Created by Morgan Collino on 08/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "CollectionViewCell.h"

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) dealloc
{
    if (delegate)
        [delegate release];
    if (image)
        [image release];
    if (label)
        [label release];
    if (round)
        [round release];
    [super dealloc];
}

@end
