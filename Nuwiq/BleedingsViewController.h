//
//  BleedingsViewController.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/16/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BleedingCell.h"
#import "BleedingReport.h"
#import <MessageUI/MessageUI.h>

@interface BleedingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, BleedingReportDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tblView;
    NSMutableArray *allBleedings;
}

@property (strong, nonatomic) NSMutableArray *arrBleedingLogs;

- (IBAction)batnAddNew:(id)sender;
- (IBAction)btnBack:(id)sender;
- (IBAction)SendReportBtnClick:(UIButton *)sender;



@end
