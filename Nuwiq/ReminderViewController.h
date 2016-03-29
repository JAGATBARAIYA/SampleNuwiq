//
//  ReminderViewController.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/16/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController

@property (assign, nonatomic) BOOL isReminder;
@property (strong, nonatomic) NSString *eventID;

-(IBAction)btnBack:(id)sender;

@end
