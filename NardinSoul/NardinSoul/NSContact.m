//
//  NSContact.m
//  NardinSoul
//
//  Created by Morgan Collino on 27/02/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "NSContact.h"
#import "User.h"
#import "UIImage+XDShape.h"

@implementation NSContact
@synthesize login = _login, infos = _infos, img = _img;

- (id) initWithLogin: (NSString *) log andInfos: (NSMutableArray *) info
{
    if (self = [super init])
    {
        _img = [UIImage imageNamed: @"no.jpg"];
        _login = [[NSString alloc] initWithString: log];
        _infos = [[NSMutableArray alloc] initWithArray: info copyItems: YES];
        [self loadImage];
    }
    return self;
}

- (id) initWithLogin: (NSString *) log
{
    if (self = [super init])
    {
        _login = [[NSString alloc] initWithString: log];
        _infos = [[NSMutableArray alloc] init];
        //[self loadImage];
    }
    return self;
}

- (void) putConnection: (User *) connection
{
    for (User *u in _infos)
        if (connection.socket == u.socket)
            return;
    [_infos addObject: connection];
}

- (void) updateConnection:(User *)connection withNewStatus:(NSString *)status
{
    for (User *u in _infos)
    {
        if (u.socket == connection.socket && [u.login isEqualToString: connection.login])
        {
			u.status = nil;
            [u setStatus: [[NSString alloc] initWithString: status]];
        }
    }
}

- (void) setIsImageLoaded: (BOOL) b
{
    self.imgLoaded = b;
}

- (void) removeConnection:(User *)connection
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
        
    for (User *u in _infos)
    {
        if (u.socket == connection.socket)
        {
            [arr addObject:u];
        }
    }
        
    for (User *u in arr)
        [_infos removeObject: u];

	arr = nil;
}

- (void) flush
{
    [_infos removeAllObjects];
}

- (void) loadImage
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://cdn.local.epitech.net/userprofil/profilview/%@.jpg", _login]];
	__weak typeof(self)weakSelf = self;
	[UIImage loadFromURL:url callback:^(UIImage *image) {
		if (image)
		{
			weakSelf.img = image;
			weakSelf.imgLoaded = YES;
		}
		else
		{
			NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"no" ofType:@"jpg"];
			if (imageFilePath)
			{
				weakSelf.img = [[UIImage alloc] initWithContentsOfFile: imageFilePath];
				weakSelf.imgLoaded = YES;
			}
		}
	}];
}

- (BOOL) isImageLoaded
{
    return self.imgLoaded;
}

@end
