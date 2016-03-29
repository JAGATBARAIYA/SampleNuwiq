//
//  TimeViewController.m
//  Nuwiq
//
//  Created by Manish on 24/08/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "TimeViewController.h"
#import "MSTextField.h"
#import "SQLiteManager.h"
#import "TKAlertCenter.h"
#import "NIDropDown.h"

#define kDateFormat     @"MMM dd, yyyy"
#define kDoseEmpty      @"Please select dose."

#define kErrorImage     [UIImage imageNamed:@"error"]

@interface TimeViewController ()<NIDropDownDelegate>
{
    NIDropDown *dropDown;
}

@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *lblPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnRepeat;
@property (strong, nonatomic) IBOutlet UIButton *btnRemindar;
@property (strong, nonatomic) IBOutlet UIButton *btnDose;

@property (strong, nonatomic) IBOutlet MSTextField *txtTime;
@property (strong, nonatomic) IBOutlet MSTextField *txtDose;
@property (strong, nonatomic) IBOutlet MSTextField *txtRepeat;
@property (strong, nonatomic) IBOutlet MSTextField *txtRemindar;

@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _txtTime.text = _strTime;
    if (_event) {
        _txtDose.text = _event.strEventDose;
        _txtTime.text = _event.strEventTime;
        _txtRepeat.text = _event.strEventRepeat;
        _txtRemindar.text = _event.strEventRemindar;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Click Event

-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTimePickerTapped:(id)sender{
    [self showDatePickerView];
}

- (IBAction)btnDoseTapped:(UIButton *)sender{
    _btnDose.selected = YES;
    _btnRemindar.selected = NO;
    _btnRepeat.selected = NO;
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"250", @"500", @"1000", @"2000",nil];
    if(dropDown == nil) {
        CGFloat f = 180;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnRepeatTapped:(UIButton *)sender{
    [self btnCloseTapped:nil];
    _btnRemindar.selected = NO;
    _btnRepeat.selected = YES;
    _btnDose.selected = NO;
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Never", @"Every Day", @"Every Week", @"Every Month",nil];
    if(dropDown == nil) {
        CGFloat f = 180;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnRemindTapped:(id)sender{
    [self btnCloseTapped:nil];
    _btnRemindar.selected = YES;
    _btnRepeat.selected = NO;
    _btnDose.selected = NO;
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"None", @"1 Hour Before", @"2 Hour Before", @"3 Hour Before",nil];
    if(dropDown == nil) {
        CGFloat f = 180;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnRightTapped:(id)sender{
    _pickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    _txtTime.text = [value uppercaseString];
}

- (IBAction)btnCloseTapped:(id)sender{
    _pickerView.hidden = YES;
}

- (IBAction)btnDoneTapped:(id)sender{
    [self btnCloseTapped:nil];
    if ([self isValidDetails]) {
        if (_event) {
            NSString *updateSQL = [NSString stringWithFormat: @"UPDATE tblEvent set eventDate = '%@',eventTime = '%@',eventDose = '%@',eventRepeat = '%@',eventRemindar = '%@',isReport = %d,isMedicineTaken = %d WHERE eventID = %ld",_strSelectedDate,_txtTime.text,_txtDose.text,_txtRepeat.text,_txtRemindar.text,1,0,(long)_event.intEventID];
            [[SQLiteManager singleton] executeSql:updateSQL];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Reminder Updated Successfully." image:[UIImage imageNamed:@"right"]];
            [self setLocalNotification];
            [self clearFields];
            [self btnBack:nil];
        }else{
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblEvent (eventDate,eventTime,eventDose,eventRepeat,eventRemindar,isReport,isMedicineTaken) VALUES ('%@','%@','%@','%@','%@',%d,%d)",_strSelectedDate,_txtTime.text,_txtDose.text,_txtRepeat.text,_txtRemindar.text,1,0];
            [[SQLiteManager singleton] executeSql:insertSQL];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Reminder Added Successfully." image:[UIImage imageNamed:@"right"]];
            [self setLocalNotification];
            [self clearFields];
            [self btnBack:nil];
        }
    }
}

#pragma mark - Show Picker View

- (void)showDatePickerView
{
    _pickerView.hidden = NO;
    _datePicker.hidden = NO;
    _lblPicker.text = @"SELECT TIME";
    [self.view bringSubviewToFront:_datePicker];
    _datePicker.datePickerMode = UIDatePickerModeTime;
}

#pragma mark - NIDropDown Delegate Method

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    if (_btnRepeat.selected) {
        _txtRepeat.text = sender.strTitle;
    }else if (_btnRemindar.selected){
        _txtRemindar.text = sender.strTitle;
    }else if (_btnDose.selected){
        _txtDose.text = sender.strTitle;
    }
    dropDown = nil;
    sender = nil;
}

#pragma mark - Local Notification

- (void)setLocalNotification
{
    NSInteger eventId;
    if (_event) {
        eventId = _event.intEventID;
    }else{
        NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblEvent order by eventID"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Event *event = [Event dataWithDict:obj];
            [arr addObject:event];
        }];
        eventId = [[[arr objectAtIndex:arr.count-1]valueForKey:@"intEventID"]integerValue];
    }
    
    NSString *strDateTime = [_strSelectedDate stringByAppendingFormat:@" %@", _txtTime.text];
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"dd-MM-yyyy hh:mm a"];
    [dtFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *aDate = [dtFormat dateFromString:strDateTime];
    NSDateComponents *dtComponents = [[NSDateComponents alloc]init];
    
    if([_txtRemindar.text isEqualToString:@"1 Hour Before"])
    {
        [dtComponents setHour:-1];
         NSDate *dtReminder = [[NSCalendar currentCalendar] dateByAddingComponents:dtComponents toDate:aDate options:0];
        
        UILocalNotification *notifReminder = [[UILocalNotification alloc] init];
        notifReminder.alertBody = @"Your medicine time is after 1 hour";
        notifReminder.soundName = UILocalNotificationDefaultSoundName;
        notifReminder.repeatCalendar = [NSCalendar currentCalendar];
        
        [notifReminder setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"1 Hour Before", @"HourBefore", nil]];

        if ([_txtRepeat.text isEqualToString:@"Every Day"])
            [notifReminder setRepeatInterval:NSCalendarUnitDay];
        else if ([_txtRepeat.text isEqualToString:@"Every Week"])
            [notifReminder setRepeatInterval: NSCalendarUnitWeekday];
        else if ([_txtRepeat.text isEqualToString:@"Every Month"])
            [notifReminder setRepeatInterval: NSCalendarUnitMonth];
        notifReminder.applicationIconBadgeNumber = -1;
        notifReminder.fireDate = dtReminder;
        [[UIApplication sharedApplication] scheduleLocalNotification:notifReminder];
    }
    else if([_txtRemindar.text isEqualToString:@"2 Hour Before"])
    {
        [dtComponents setHour:-2];
         NSDate *dtReminder = [[NSCalendar currentCalendar] dateByAddingComponents:dtComponents toDate:aDate options:0];
        
        UILocalNotification *notifReminder = [[UILocalNotification alloc] init];
        notifReminder.alertBody = @"Your medicine time is after 2 hour";
        notifReminder.soundName = UILocalNotificationDefaultSoundName;
        notifReminder.repeatCalendar = [NSCalendar currentCalendar];
        
        [notifReminder setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"2 Hour Before", @"HourBefore", nil]];

        if ([_txtRepeat.text isEqualToString:@"Every Day"])
            [notifReminder setRepeatInterval:NSCalendarUnitDay];
        else if ([_txtRepeat.text isEqualToString:@"Every Week"])
            [notifReminder setRepeatInterval: NSCalendarUnitWeekday];
        else if ([_txtRepeat.text isEqualToString:@"Every Month"])
            [notifReminder setRepeatInterval: NSCalendarUnitMonth];
        notifReminder.applicationIconBadgeNumber = -1;
        notifReminder.fireDate = dtReminder;
        [[UIApplication sharedApplication] scheduleLocalNotification:notifReminder];
    }
    else if([_txtRemindar.text isEqualToString:@"3 Hour Before"])
    {
        [dtComponents setHour:-3];
         NSDate *dtReminder = [[NSCalendar currentCalendar] dateByAddingComponents:dtComponents toDate:aDate options:0];
        
        UILocalNotification *notifReminder = [[UILocalNotification alloc] init];
        notifReminder.alertBody = @"Your medicine time is after 3 hour";
        notifReminder.soundName = UILocalNotificationDefaultSoundName;
        notifReminder.repeatCalendar = [NSCalendar currentCalendar];
        
        [notifReminder setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"3 Hour Before", @"HourBefore", nil]];

        if ([_txtRepeat.text isEqualToString:@"Every Day"])
            [notifReminder setRepeatInterval:NSCalendarUnitDay];
        else if ([_txtRepeat.text isEqualToString:@"Every Week"])
            [notifReminder setRepeatInterval: NSCalendarUnitWeekday];
        else if ([_txtRepeat.text isEqualToString:@"Every Month"])
            [notifReminder setRepeatInterval: NSCalendarUnitMonth];
        notifReminder.applicationIconBadgeNumber = -1;
        notifReminder.fireDate = dtReminder;
        [[UIApplication sharedApplication] scheduleLocalNotification:notifReminder];
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Have you taken your medicine?";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.repeatCalendar = [NSCalendar currentCalendar];
    
    if ([_txtRepeat.text isEqualToString:@"Every Day"])
        [localNotification setRepeatInterval:NSCalendarUnitDay];
    else if ([_txtRepeat.text isEqualToString:@"Every Week"])
        [localNotification setRepeatInterval: NSCalendarUnitWeekday];
    else if ([_txtRepeat.text isEqualToString:@"Every Month"])
        [localNotification setRepeatInterval: NSCalendarUnitMonth];
    
    [localNotification setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)eventId], @"eventID", nil]];
    localNotification.applicationIconBadgeNumber = -1;
    localNotification.fireDate = aDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    NSLog(@"%@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
    
}

/*
- (void)setLocalNotification{
    NSArray *arrDate = [_strSelectedDate componentsSeparatedByString:@"-"];
    NSArray *arrTime = [_txtTime.text componentsSeparatedByString:@":"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay: [arrDate[0]integerValue]];
    [components setMonth: [arrDate[1]integerValue]];
    [components setYear: [arrDate [2]integerValue]];
    [components setHour: [arrTime[0]integerValue]];
    [components setMinute: [arrTime[1]integerValue]];
    [components setSecond: 0];
    [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
    NSDate *dateToFire = [calendar dateFromComponents:components];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate: dateToFire];
    [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
    [localNotification setAlertBody:@"Reminder Call"];
    [localNotification setAlertAction:@"Show me"];

    if ([_txtRepeat.text isEqualToString:@"Every Day"]) {
        [localNotification setRepeatInterval:NSCalendarUnitDay];
    }else if ([_txtRepeat.text isEqualToString:@"Every Week"]){
        [localNotification setRepeatInterval: NSCalendarUnitWeekday];
    }else if ([_txtRepeat.text isEqualToString:@"Every Month"]){
        [localNotification setRepeatInterval: NSCalendarUnitMonth];
    }
    
    if ([_txtRemindar.text isEqualToString:@"1 Hour Before"]) {
        NSArray *arrDate = [_strSelectedDate componentsSeparatedByString:@"-"];
        NSArray *arrTime = [_txtTime.text componentsSeparatedByString:@":"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay: [arrDate[0]integerValue]];
        [components setMonth: [arrDate[1]integerValue]];
        [components setYear: [arrDate [2]integerValue]];
        if ([arrTime[0] integerValue] <= 1 ) {
            [components setHour: 12];
        }else{
            [components setHour: [arrTime[0]integerValue]-1];
        }
        [components setMinute: [arrTime[1]integerValue]];
        [components setSecond: 0];
        [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
        NSDate *dateToFire = [calendar dateFromComponents:components];

        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        [localNoti setFireDate: dateToFire];
        [localNoti setTimeZone: [NSTimeZone defaultTimeZone]];
        [localNoti setAlertBody:@"1 Hour Before"];
        [localNoti setAlertAction:@"Show me"];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    }else if ([_txtRemindar.text isEqualToString:@"2 Hour Before"]) {
        NSArray *arrDate = [_strSelectedDate componentsSeparatedByString:@"-"];
        NSArray *arrTime = [_txtTime.text componentsSeparatedByString:@":"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay: [arrDate[0]integerValue]];
        [components setMonth: [arrDate[1]integerValue]];
        [components setYear: [arrDate [2]integerValue]];
        if ([arrTime[0] integerValue] <= 2 ) {
            [components setHour: 12];
        }else{
            [components setHour: [arrTime[0]integerValue]-2];
        }
        [components setMinute: [arrTime[1]integerValue]];
        [components setSecond: 0];
        [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
        NSDate *dateToFire = [calendar dateFromComponents:components];
        
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        [localNoti setFireDate: dateToFire];
        [localNoti setTimeZone: [NSTimeZone defaultTimeZone]];
        [localNoti setAlertBody:@"2 Hour Before"];
        [localNoti setAlertAction:@"Show me"];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    }else if ([_txtRemindar.text isEqualToString:@"3 Hour Before"]) {
        NSArray *arrDate = [_strSelectedDate componentsSeparatedByString:@"-"];
        NSArray *arrTime = [_txtTime.text componentsSeparatedByString:@":"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay: [arrDate[0]integerValue]];
        [components setMonth: [arrDate[1]integerValue]];
        [components setYear: [arrDate [2]integerValue]];
        if ([arrTime[0] integerValue] <= 3 ) {
            [components setHour: 12];
        }else{
            [components setHour: [arrTime[0]integerValue]-3];
        }
        [components setMinute: [arrTime[1]integerValue]];
        [components setSecond: 0];
        [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
        NSDate *dateToFire = [calendar dateFromComponents:components];
        
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        [localNoti setFireDate: dateToFire];
        [localNoti setTimeZone: [NSTimeZone defaultTimeZone]];
        [localNoti setAlertBody:@"3 Hour Before"];
        [localNoti setAlertAction:@"Show me"];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSMutableArray *aMutNotifArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];

    NSLog(@"notification Array : %@",aMutNotifArray);
}
*/

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)clearFields{
    _txtTime.text = @"";
    _txtDose.text = @"";
    _txtRepeat.text = @"";
    _txtRemindar.text = @"";
}

#pragma mark - Validation

- (BOOL)isValidDetails{
    if ([_txtDose.text isEmptyString]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kDoseEmpty image:kErrorImage];
        return NO;
    }
    return YES;
}

@end
