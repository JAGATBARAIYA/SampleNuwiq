//
//  AppDelegate.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/14/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    NSString                   *m_pDatabaseName;
    NSString                   *m_pDatabasePath;
    

}

@property (strong, nonatomic) UIWindow *window;


#pragma mark- Local DataBase Methods
- (NSString *) getDBPath;
- (void)copyDatabaseIfNeeded;
- (void) genrateDB;
- (void)checkAndCreateDatabase;
- (sqlite3_stmt *) getStatement:(NSString *) SQLStrValue;
-(BOOL)InsUpdateDelData:(NSString*)SqlStr;


@end

