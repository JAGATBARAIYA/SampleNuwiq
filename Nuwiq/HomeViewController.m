//
//  HomeViewController.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/14/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "HomeViewController.h"
#import "GuideViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Nuwiq";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark IBACTION methods

-(IBAction)btnDoctors:(id)sender{
    DoctorsViewController *vc = [[DoctorsViewController alloc]initWithNibName:@"DoctorsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnReminders:(id)sender{
    
    ReminderViewController *vc = [[ReminderViewController alloc]initWithNibName:@"ReminderViewController" bundle:nil];
    vc.isReminder = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnBleedings:(id)sender{
    
    BleedingsViewController *vc = [[BleedingsViewController alloc]initWithNibName:@"BleedingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnBarcode:(id)sender{
    BarcodeViewController *vc = [[BarcodeViewController alloc]initWithNibName:@"BarcodeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnAddDoctor:(id)sender{
    GuideViewController *vc = [[GuideViewController alloc]initWithNibName:@"GuideViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
