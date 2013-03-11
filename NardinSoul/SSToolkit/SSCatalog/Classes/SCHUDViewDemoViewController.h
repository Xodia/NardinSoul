//
//  SCHUDViewDemoViewController.h
//  SSCatalog
//
//  Created by Sam Soffes on 11/18/09.
//  Copyright 2009 Sam Soffes, Inc. All rights reserved.
//

@class SSHUDView;

@interface SCHUDViewDemoViewController : UIViewController {

	SSHUDView *_hud;
}

+ (NSString *)title;

- (void)complete:(id)sender;
- (void)pop:(id)sender;

@end
