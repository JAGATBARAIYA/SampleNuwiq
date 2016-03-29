//
//  Event.h
//  Nuwiq
//
//  Created by Manish on 27/08/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (assign, nonatomic) NSInteger intEventID;
@property (assign, nonatomic) NSInteger intIsMedicineTaken;

@property (strong, nonatomic) NSString *strEventDate;
@property (strong, nonatomic) NSString *strEventTime;
@property (strong, nonatomic) NSString *strEventDose;
@property (strong, nonatomic) NSString *strEventRepeat;
@property (strong, nonatomic) NSString *strEventRemindar;

+ (Event *)dataWithDict:(NSDictionary*)dict;
- (Event *)initWithDictionary:(NSDictionary*)dict;

@end
