//
//  CustomCell.m
//  Task1
//
//  Created by Salman Khalid on 23/02/10.
//  Copyright 2010 Rolustech. All rights reserved.
//

#import "BadgeCell.h"
#import "SQLiteManager.h"
#import "Helper.h"

@implementation BadgeCell

@synthesize btnAdd,doctor_name,hospital_name,contact_no,email_address,btnPhone,btnEmail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	}
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btnCheckTapped:(id)sender{
    if ([Helper getIntFromNSUserDefaults:@"DoctorID"] == _doctorInfo.doctor_id) {
        _btnCheck.selected = !_btnCheck.selected;
        _btnReport.hidden = !_btnCheck.selected;

        NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from DoctorsInfo where is_my_doctor = 1"];
        
        if (data.count == 0) {
            _isReload = YES;
            isSelectable = YES;
        }else{
            NSString *update = [NSString stringWithFormat: @"UPDATE DoctorsInfo set doctor_name = '%@',hospital_name = '%@',contact_no = '%@',email_address = '%@', is_my_doctor = 0 WHERE doctor_id = %d",_doctorInfo.doctor_name,_doctorInfo.hospital_name,_doctorInfo.contact_no,_doctorInfo.email_address,[[[data objectAtIndex:0] valueForKey:@"doctor_id"] integerValue]];
            [[SQLiteManager singleton] executeSql:update];
            _isReload = NO;
            isSelectable = NO;
        }
        
        NSString *updateSQL = [NSString stringWithFormat: @"UPDATE DoctorsInfo set doctor_name = '%@',hospital_name = '%@',contact_no = '%@',email_address = '%@', is_my_doctor = %d WHERE doctor_id = %d",_doctorInfo.doctor_name,_doctorInfo.hospital_name,_doctorInfo.contact_no,_doctorInfo.email_address,_btnCheck.selected,_doctorInfo.doctor_id];
        [[SQLiteManager singleton] executeSql:updateSQL];
        [Helper addBoolToUserDefaults:NO forKey:@"FirstTime"];
    }else{
        if ([Helper getBoolFromUserDefaults:@"FirstTime"]) {
            NSLog(@"FirstTime is Over");
            isSelectable = NO;
            _isReload = NO;
        }else{
            _btnCheck.selected = !_btnCheck.selected;
            _btnReport.hidden = !_btnCheck.selected;
            
            NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from DoctorsInfo where is_my_doctor = 1"];
            if (data.count == 0) {
                _isReload = YES;
                isSelectable = YES;
            }else{
                NSString *update = [NSString stringWithFormat: @"UPDATE DoctorsInfo set doctor_name = '%@',hospital_name = '%@',contact_no = '%@',email_address = '%@', is_my_doctor = 0 WHERE doctor_id = %d",_doctorInfo.doctor_name,_doctorInfo.hospital_name,_doctorInfo.contact_no,_doctorInfo.email_address,[[[data objectAtIndex:0] valueForKey:@"doctor_id"] integerValue]];
                [[SQLiteManager singleton] executeSql:update];
                _isReload = NO;
                isSelectable = NO;
            }
            
            NSString *updateSQL = [NSString stringWithFormat: @"UPDATE DoctorsInfo set doctor_name = '%@',hospital_name = '%@',contact_no = '%@',email_address = '%@', is_my_doctor = %d WHERE doctor_id = %d",_doctorInfo.doctor_name,_doctorInfo.hospital_name,_doctorInfo.contact_no,_doctorInfo.email_address,_btnCheck.selected,_doctorInfo.doctor_id];
            [[SQLiteManager singleton] executeSql:updateSQL];
            [Helper addIntToUserDefaults:_doctorInfo.doctor_id forKey:@"DoctorID"];
            [Helper addBoolToUserDefaults:YES forKey:@"FirstTime"];
        }
    }
    if ([_delegate respondsToSelector:@selector(reloadTableView)]) {
        [_delegate reloadTableView];
    }
}

@end
