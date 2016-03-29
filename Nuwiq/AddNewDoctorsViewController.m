//
//  AddNewDoctorsViewController.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/15/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "AddNewDoctorsViewController.h"
#import "TKAlertCenter.h"
#import "NSString+extras.h"
#import "SQLiteManager.h"

#define kDoctorNameEmpty    @"Please enter name."
#define kHospitalNameEmpty  @"Please enter hospital."
#define kPhoneNoEmpty       @"Please enter mobile number."
#define kEmailIDEmpty       @"Please enter email."
#define kValidEmail         @"Please enter valid email address."
#define kValidPhoneNo       @"Please enter valid mobile number."

#define kErrorImage         [UIImage imageNamed:@"error"]

@interface AddNewDoctorsViewController ()

@end

@implementation AddNewDoctorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Nuwiq";
    if (_doctorInfo) {
        doctor_name.text = _doctorInfo.doctor_name;
        hospital_name.text = _doctorInfo.hospital_name;
        phone_number.text = _doctorInfo.contact_no;
        email_address.text = _doctorInfo.email_address;
    }
}

-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)btnAddNew:(id)sender{
    if ([self isValidDetails]){
        [self addNewDoctor];
    }
}

-(void)addNewDoctor{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (_doctorInfo) {
        NSString *updateSQL = [NSString stringWithFormat: @"UPDATE DoctorsInfo set doctor_name = '%@',hospital_name = '%@',contact_no = '%@',email_address = '%@' WHERE doctor_id = %d",doctor_name.text,hospital_name.text,phone_number.text,email_address.text,_doctorInfo.doctor_id];
        [[SQLiteManager singleton] executeSql:updateSQL];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Doctor Information Updated." image:[UIImage imageNamed:@"right"]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO DoctorsInfo(doctor_name,hospital_name,contact_no,email_address,is_my_doctor)values('%@','%@','%@','%@',%d)",doctor_name.text,hospital_name.text,phone_number.text,email_address.text,0];
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Doctor Information Added." image:[UIImage imageNamed:@"right"]];

        NSString *SqlStr = [NSString stringWithString:strQuery];
        BOOL retValue = [appDel InsUpdateDelData:SqlStr];
        if(retValue == TRUE )
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"Record not save.");
        }
    }
}

#pragma mark - Validation

- (BOOL)isValidDetails{
    if ([doctor_name.text isEmptyString]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kDoctorNameEmpty image:kErrorImage];
        return NO;
    }else if ([hospital_name.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kHospitalNameEmpty image:kErrorImage];
        return NO;
    }else if ([phone_number.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kPhoneNoEmpty image:kErrorImage];
        return NO;
    }else if ([email_address.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kEmailIDEmpty image:kErrorImage];
        return NO;
    }
    if(![email_address.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kValidEmail image:kErrorImage];
        return NO;
    }
    NSInteger length = [self getLength:phone_number.text];
    if(length < 10){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kValidPhoneNo image:kErrorImage];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == phone_number) {
        NSInteger length = [self getLength:textField.text];
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"%@- ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            
            textField.text = [NSString stringWithFormat:@"%@- %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@- %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    NSInteger length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    return mobileNumber;
}

-(NSInteger)getLength:(NSString*)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSInteger length = [mobileNumber length];
    
    return length;
}

@end
