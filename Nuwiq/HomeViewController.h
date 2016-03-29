//
//  HomeViewController.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/14/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorsViewController.h"
#import "BarcodeViewController.h"
#import "ReminderViewController.h"
#import "BleedingsViewController.h"
#import "AddNewDoctorsViewController.h"
@interface HomeViewController : UIViewController


-(IBAction)btnDoctors:(id)sender;
-(IBAction)btnReminders:(id)sender;
-(IBAction)btnBleedings:(id)sender;
-(IBAction)btnBarcode:(id)sender;
-(IBAction)btnAddDoctor:(id)sender;


@end
