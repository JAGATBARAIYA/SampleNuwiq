//
//  AppDelegate.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/14/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "SIAlertView.h"
#import "ReminderViewController.h"
#import "TKAlertCenter.h"
#import "NSObject+Extras.h"
#import "SQLiteManager.h"
#import "HomeViewController.h"
#import "Helper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
sqlite3 *database=nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:0.0];
    sleep(0.0);
    
    [self copyDatabaseIfNeeded];
    [self genrateDB];
    [self checkAndCreateDatabase];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }

    if ([Helper getBoolFromUserDefaults:@"IsLocalNotification"]) {
        
    }else{
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [Helper addBoolToUserDefaults:YES forKey:@"IsLocalNotification"];
    }
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        application.applicationIconBadgeNumber = 0;
        
        ReminderViewController *vc = [[ReminderViewController alloc]initWithNibName:@"ReminderViewController" bundle:nil];
        if (locationNotification.userInfo[@"HourBefore"]){
            vc.isReminder = NO;
        }else{
            vc.isReminder = YES;
        }
        vc.eventID = locationNotification.userInfo[@"eventID"];
        
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        [navController setViewControllers:[NSArray arrayWithObjects:[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil], vc, nil]];
    }
    
    return YES;
}

#pragma mark sqlite Methods
#pragma mark local database Mehods

- (void) copyDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if(!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Nuwiq.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (NSString *) getDBPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"Nuwiq.sqlite"];
}


- (void) genrateDB
{
    
    NSString *dbFilePath = [self getDBPath];
    if(sqlite3_open([dbFilePath UTF8String],&database) == SQLITE_OK)
        NSLog(@"CONNECTION SUCCESSFUL\n\n");
    else
        NSLog(@"CONNECTION FAILURE");
}

- (void)checkAndCreateDatabase
{
    //Check if the SQL database is available on the Iphone, if not the copy it over
    BOOL the_bSuccess;
    m_pDatabaseName = @"Nuwiq.sqlite";
    
    //Get the path to documents directory and append the database name
    NSArray *the_pDocumentPaths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *the_pDocumentsDir2 = [the_pDocumentPaths2 objectAtIndex:0];
    m_pDatabasePath = [the_pDocumentsDir2 stringByAppendingPathComponent:m_pDatabaseName];
    //Crete filemaker object and we will use to check if the database is available on the user’s iPhone, if not the copy it over
    NSFileManager *the_pFileManager = [NSFileManager defaultManager];
    
    //Check if the database is already exists in the user’s filesystem i.e documents directory of the application
    
    the_bSuccess=[ the_pFileManager fileExistsAtPath:m_pDatabasePath];
    
    //If database is already exist then return without doing anything
    if(the_bSuccess) return;
    
    //If not then proceed to copy the database from the application to user’s filesystem
    //Get the path to the database in the application package
    NSString *the_pDatabasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Nuwiq.sqlite"];
    
    //Copy the database from the package to the user’s filesystem
    //    NSData *strte=[NSData  dataWithContentsOfFile:@"Icon.png"];
    [the_pFileManager copyItemAtPath:the_pDatabasePathFromApp toPath:m_pDatabasePath error:nil];
}

- (sqlite3_stmt *) getStatement:(NSString *) SQLStrValue
{
    if([SQLStrValue isEqualToString:@""])
        return NO;
    
    sqlite3_stmt * OperationStatement;
    sqlite3_stmt * ReturnStatement = nil;
    
    const char *sql = [SQLStrValue cStringUsingEncoding: NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(database, sql, -1, &OperationStatement, NULL) == SQLITE_OK)
    {
        ReturnStatement = OperationStatement;
    }
    return ReturnStatement;
}

-(BOOL)InsUpdateDelData:(NSString*)SqlStr
{
    if([SqlStr isEqual:@""])
        return NO;
    
    BOOL RetrunValue;
    RetrunValue = NO;
    const char *sql = [SqlStr cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK)
        RetrunValue = YES;
    
    if(RetrunValue == YES)
    {
        if(sqlite3_step(stmt) != SQLITE_DONE) {
            
        }
        sqlite3_finalize(stmt);
    }
    return RetrunValue;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#ifdef isAtLeastiOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{
    if ([identifier isEqualToString:@"declineAction"]){
    } else if ([identifier isEqualToString:@"answerAction"]){
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#endif

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if (application.applicationState == UIApplicationStateInactive )
    {
        NSLog(@"app not running");
        [self localNotificationPushViewController:notif];
    }
    else if(application.applicationState == UIApplicationStateActive )
    {
        if (notif.userInfo[@"HourBefore"]){
            
        }else{
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Nuwiq" andMessage:@"Have you taken your medicine?"];
            alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
            [alertView addButtonWithTitle:@"YES"
                                     type:SIAlertViewButtonTypeDestructive
                                  handler:^(SIAlertView *alert) {
                                      [self performBlock:^{
                                          NSString *updateSQL = [NSString stringWithFormat: @"UPDATE tblEvent set isMedicineTaken = %d WHERE eventID = %ld",1,(long)[notif.userInfo[@"eventID"] integerValue]];
                                          [[SQLiteManager singleton] executeSql:updateSQL];
                                          [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Record added successfully." image:[UIImage imageNamed:@"right"]];
                                          [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                                      } afterDelay:0.5];
                                      
                                  }];
            [alertView addButtonWithTitle:@"NO"
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alert) {
                                      [self performBlock:^{
                                          NSString *updateSQL = [NSString stringWithFormat: @"UPDATE tblEvent set isMedicineTaken = %d WHERE eventID = %ld",0,(long)[notif.userInfo[@"eventID"] integerValue]];
                                          [[SQLiteManager singleton] executeSql:updateSQL];
                                          [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Take your medicine as soon as possible." image:[UIImage imageNamed:@"error"]];
                                          [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                                      } afterDelay:0.5];
                                  }];
            alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
            [alertView show];
        }

    }else if(application.applicationState == UIApplicationStateBackground){
        NSLog(@"back running");
        [self localNotificationPushViewController:notif];
    }
}

- (void)localNotificationPushViewController:(UILocalNotification *)userInformation{
    ReminderViewController *vc = [[ReminderViewController alloc]initWithNibName:@"ReminderViewController" bundle:nil];
    
    if (userInformation.userInfo[@"HourBefore"]){
        vc.isReminder = NO;
    }else{
        vc.isReminder = YES;
    }
    vc.eventID = userInformation.userInfo[@"eventID"];
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    [navController pushViewController:vc animated:YES];
    
    [UIApplication sharedApplication].scheduledLocalNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
}

@end
