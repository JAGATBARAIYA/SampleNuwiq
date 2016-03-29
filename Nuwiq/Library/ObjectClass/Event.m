//
//  Event.m
//  Nuwiq
//
//  Created by Manish on 27/08/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "Event.h"

@implementation Event

+ (Event *)dataWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (Event *)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
        if (dict[@"eventID"]  != [NSNull null])
            self.intEventID = [dict[@"eventID"]integerValue];

        if (dict[@"isMedicineTaken"]  != [NSNull null])
            self.intIsMedicineTaken = [dict[@"isMedicineTaken"]integerValue];

        if (dict[@"eventDate"]  != [NSNull null])
            self.strEventDate = dict[@"eventDate"];
        
        if (dict[@"eventTime"]  != [NSNull null])
            self.strEventTime = dict[@"eventTime"];
        
        if (dict[@"eventDose"]  != [NSNull null])
            self.strEventDose = dict[@"eventDose"];
        
        if (dict[@"eventRepeat"]  != [NSNull null])
            self.strEventRepeat = dict[@"eventRepeat"];
        
        if (dict[@"eventRemindar"]  != [NSNull null])
            self.strEventRemindar = dict[@"eventRemindar"];
    }
    return self;
}

@end
