//
//  BleedingLogsFormViewController.m
//  Nuwiq
//
//  Created by Manish on 27/08/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "BleedingLogsFormViewController.h"
#import "SQLiteManager.h"
#import "TKAlertCenter.h"
#import "MSTextField.h"
#import "SIAlertView.h"

#define kDateEmpty      @"Please select date."
#define kTimeEmpty      @"Please select time."

#define kErrorImage     [UIImage imageNamed:@"error"]

@interface BleedingLogsFormViewController ()

@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *lblPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UIButton *btnTime;
@property (strong, nonatomic) IBOutlet UIButton *btnCheck;

@property (strong, nonatomic) IBOutlet MSTextField *txtTime;
@property (strong, nonatomic) IBOutlet MSTextField *txtDate;
@property (strong, nonatomic) IBOutlet MSTextField *txtNote;

@end

@implementation BleedingLogsFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_bleedlogs) {
        _txtDate.text = _bleedlogs.strBleedingDate;
        _txtTime.text = _bleedlogs.strBleedingTime;
        _txtNote.text = _bleedlogs.strBleedingNote;
        _btnCheck.selected = _bleedlogs.isReport;
        
        if ([_txtNote.text isEqualToString:@"-"]) {
            _txtNote.text = @"";
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Click Event

-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDateTapped:(id)sender{
    [_txtNote resignFirstResponder];
    _btnDate.selected = YES;
    _btnTime.selected = NO;
    [self showDatePickerView];
}

- (IBAction)btnTimeTapped:(id)sender{
    [_txtNote resignFirstResponder];
    _btnTime.selected = YES;
    _btnDate.selected = NO;
    [self showDatePickerView];
}

- (IBAction)btnCheckTapped:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (IBAction)btnRightTapped:(id)sender{
    _pickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    if (_datePicker.datePickerMode == UIDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }else if (_datePicker.datePickerMode == UIDatePickerModeTime){
        [dateFormatter setDateFormat:@"hh:mm a"];
    }
    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    if (_btnTime.selected) {
        _txtTime.text = value;
    }else if (_btnDate.selected){
        _txtDate.text = value;
    }
}

- (IBAction)btnCloseTapped:(id)sender{
    _pickerView.hidden = YES;
}

- (IBAction)btnDoneTapped:(id)sender{
    if ([self isValidDetails]) {
        if (_bleedlogs) {
            NSString *updateSQL = [NSString stringWithFormat: @"UPDATE tblBleedingLogs set bleedDate = '%@',bleedTime = '%@',bleedNote = '%@',isReport = %d WHERE bleedID = %ld",_txtDate.text,_txtTime.text,_txtNote.text,_btnCheck.selected,(long)_bleedlogs.intBleedingID];
            [[SQLiteManager singleton] executeSql:updateSQL];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Log Updated." image:[UIImage imageNamed:@"right"]];
        }else{
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblBleedingLogs (bleedDate,bleedTime,bleedNote,isReport) VALUES ('%@','%@','%@',%d)",_txtDate.text,_txtTime.text,([_txtNote.text isEqualToString:@""])?@"-":_txtNote.text,_btnCheck.selected];
            [[SQLiteManager singleton] executeSql:insertSQL];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Log Saved." image:[UIImage imageNamed:@"right"]];
           // [self addReport];
        }
        [self clearFields];
        [self btnBack:nil];
    }
}

- (IBAction)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark - Show Picker View

- (void)showDatePickerView{
    _pickerView.hidden = NO;
    _datePicker.hidden = NO;
    [self.view bringSubviewToFront:_datePicker];

    if (_btnDate.selected) {
        _lblPicker.text = @"SELECT DATE";
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }else if (_btnTime.selected){
        _lblPicker.text = @"SELECT TIME";
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
}

- (void)addReport{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"REPORT" andMessage:@"Are you sure to add this log in Report?"];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [self btnBack:nil];
                          }];
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              [self btnBack:nil];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (BOOL)isValidDetails{
    if ([_txtDate.text isEmptyString]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kDateEmpty image:kErrorImage];
        return NO;
    }else if ([_txtTime.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kTimeEmpty image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _pickerView.hidden = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)clearFields{
    _txtDate.text = @"";
    _txtTime.text = @"";
    _txtNote.text = @"";
}
@end
