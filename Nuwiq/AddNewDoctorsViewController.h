//
//  AddNewDoctorsViewController.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/15/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DoctorsInfo.h"

@interface AddNewDoctorsViewController : UIViewController{
    IBOutlet UITextField *doctor_name;
    IBOutlet UITextField *hospital_name;
    IBOutlet UITextField *phone_number;
    IBOutlet UITextField *email_address;
}

@property (strong, nonatomic) DoctorsInfo *doctorInfo;

-(IBAction)btnAddNew:(id)sender;
-(IBAction)btnBack:(id)sender;




@end
