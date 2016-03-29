//
//  CustomCell.h
//  Task1
//
//  Created by Salman Khalid on 23/02/10.
//  Copyright 2010 Rolustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorsInfo.h"

@class BadgeCell;

@protocol BadgeCellDelegate<NSObject>

- (void)reloadTableView;

@end

@interface BadgeCell : UITableViewCell {

    IBOutlet UILabel      *doctor_name;
    IBOutlet UILabel      *hospital_name;
    IBOutlet UILabel      *contact_no;
    IBOutlet UILabel      *email_address;
    IBOutlet UIButton     *btnAdd;
    IBOutlet UIButton   *btnEmail;
    IBOutlet UIButton  *btnPhone;
    BOOL isSelectable;
}

@property (nonatomic,retain)IBOutlet UILabel     *doctor_name;
@property (nonatomic,retain)IBOutlet UILabel     *hospital_name;
@property (nonatomic,retain)IBOutlet UILabel     *contact_no;
@property (nonatomic,retain)IBOutlet UILabel     *email_address;
@property (nonatomic,retain)IBOutlet UIButton    *btnAdd;
@property (nonatomic,retain)IBOutlet UIButton    *btnEmail;
@property (nonatomic,retain)IBOutlet UIButton    *btnPhone;
@property (strong, nonatomic) IBOutlet UIButton  *btnReport;
@property (strong, nonatomic) IBOutlet UIButton  *btnCheck;
@property (assign, nonatomic) BOOL isReload;

@property (strong, nonatomic) DoctorsInfo *doctorInfo;
@property (assign, nonatomic) id<BadgeCellDelegate> delegate;

@end
