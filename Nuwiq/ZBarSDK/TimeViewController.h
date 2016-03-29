//
//  TimeViewController.h
//  Nuwiq
//
//  Created by Manish on 24/08/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface TimeViewController : UIViewController

@property (strong, nonatomic) NSString *strSelectedDate;
@property (strong, nonatomic) NSString *strTime;
@property (strong, nonatomic) Event *event;

@end
