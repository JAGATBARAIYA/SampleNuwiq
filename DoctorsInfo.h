//
//  DoctorsInfo.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/15/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorsInfo : NSObject{
    NSInteger doctor_id;
    NSString *doctor_name;
    NSString *hospital_name;
    NSString *contact_no;
    NSString *email_address;
    BOOL is_my_doctor;
}
@property (nonatomic,assign)NSInteger doctor_id;
@property (nonatomic,retain)NSString *doctor_name;
@property (nonatomic,retain)NSString *hospital_name;
@property (nonatomic,retain)NSString *contact_no;
@property (nonatomic,retain)NSString *email_address;
@property (nonatomic,assign)BOOL is_my_doctor;

@end
