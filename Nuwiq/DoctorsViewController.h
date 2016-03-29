//
//  DoctorsViewController.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/15/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewDoctorsViewController.h"
#import "DoctorsInfo.h"
#import "AppDelegate.h"
#import "BadgeCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface DoctorsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>{
    
    IBOutlet UITableView  *tblView;
    NSMutableArray        *allDoctors;
    
    BOOL edit;
    
    NSIndexPath *selectedIndex;
    
}

@property (strong, nonatomic) IBOutlet UIButton *btnBleeding;
@property (strong, nonatomic) IBOutlet UIButton *btnReminder;
@property (strong, nonatomic) IBOutlet UIButton *btnBarcode;

-(IBAction)btnAddNew:(id)sender;
-(IBAction)btnBack:(id)sender;

-(void)getAllDoctors;



@end
