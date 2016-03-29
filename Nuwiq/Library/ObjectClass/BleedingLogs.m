//
//  BleedingLogs.m
//  Nuwiq
//
//  Created by Manish on 27/08/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "BleedingLogs.h"

@implementation BleedingLogs

+ (BleedingLogs *)dataWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (BleedingLogs *)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
        if (dict[@"bleedID"]  != [NSNull null])
            self.intBleedingID = [dict[@"bleedID"]integerValue];
        
        if (dict[@"bleedDate"]  != [NSNull null])
            self.strBleedingDate = dict[@"bleedDate"];
        
        if (dict[@"bleedTime"]  != [NSNull null])
            self.strBleedingTime = dict[@"bleedTime"];
        
        if (dict[@"bleedNote"]  != [NSNull null])
            self.strBleedingNote = dict[@"bleedNote"];
        
        if (dict[@"isReport"]  != [NSNull null])
            self.isReport = [dict[@"isReport"]boolValue];
    }
    return self;
}

@end
