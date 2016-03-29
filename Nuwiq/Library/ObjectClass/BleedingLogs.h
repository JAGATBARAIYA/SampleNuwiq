//
//  BleedingLogs.h
//  Nuwiq
//
//  Created by Manish on 27/08/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleedingLogs : NSObject

@property (assign, nonatomic) NSInteger intBleedingID;

@property (strong, nonatomic) NSString *strBleedingDate;
@property (strong, nonatomic) NSString *strBleedingTime;
@property (strong, nonatomic) NSString *strBleedingNote;
@property (assign, nonatomic) BOOL isReport;

+ (BleedingLogs *)dataWithDict:(NSDictionary*)dict;
- (BleedingLogs *)initWithDictionary:(NSDictionary*)dict;

@end
