//
//  RootAppDelegate.m
//  NardinSoul
//
//  Created by Morgan Collino on 21/01/13.
//  Copyright (c) 2013 Morgan Collino. All rights reserved.
//

#import "RootAppDelegate.h"
#import <CoreData/CoreData.h>
#import "NetsoulProtocol.h"

@implementation RootAppDelegate

@synthesize  managedObjectContext, managedObjectModel, persistentStoreCoordinator;

- (void)dealloc
{
    managedObjectContext = nil;
    managedObjectModel = nil;
    persistentStoreCoordinator = nil;
    
    _window = nil;
}

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"NardinSoul.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Error in AppDelegate::persistentStoreCoordinator [%@] [%@]\n", error, [error userInfo]);
		abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/* (...Existing Application Code...) */



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
	
	[[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Override point for customization after application launch.
	[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    [[NetsoulProtocol sharePointer] setManagedObjectContext: self.managedObjectContext];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    backgroundAccepted = NO;
}

- (void)backgroundHandler
{

    /*
     
        Simulating infinite loop for keeping network working in background
        Pseudo hack to keep the socket alive.
     */
    
    backgroundAccepted = YES;
    while (backgroundAccepted == YES && [[NetsoulProtocol sharePointer] isConnected])
    {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateActive)
            backgroundAccepted = NO;
        
        usleep(300);
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	
	NSLog(@"DidEnterBackground !");
	socket = [NetsoulProtocol sharePointer].socket;
	//socket.delegate = self;
	
	[socket performBlock:^{
		[socket enableBackgroundingOnSocket];
	}];
	NSLog(@"Socket: %@, isConnected: %d", socket, socket.isConnected);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
/*
    [application beginBackgroundTaskWithExpirationHandler:^{
        
        [self backgroundHandler];
    }];
    
    UIApplication  *app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    // Create a new notification.
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm && [[NetsoulProtocol sharePointer] isConnected])
    {
        NSTimeInterval ti = [[UIApplication sharedApplication]backgroundTimeRemaining];
        ti -= 60;
                
        NSDate *date = [NSDate date];
        date = [date dateByAddingTimeInterval: ti];
        alarm.fireDate = date;        
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        alarm.alertBody = @"Tu vas etre deconnecter dans une minute si tu ne relances pas l'application ;)";
        alarm.soundName = UILocalNotificationDefaultSoundName;

        [app scheduleLocalNotification:alarm];
    }
    alarm = nil;*/
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    backgroundAccepted = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    backgroundAccepted = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    backgroundAccepted = NO;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
	NSString *dataStr = [NSString stringWithUTF8String: [data bytes]];
	
	NSLog(@"String: %@", dataStr);
}

- (void) socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"Socket didWriteDataWithTag");
}

- (void) socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
	NSLog(@"Socket didReadPartialDataOfLength");
}

- (void) socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"Socket socketDidDisconnect");

}
@end
