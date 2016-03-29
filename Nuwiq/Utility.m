//
//  Utility.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/14/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+(void)setTermsAndConditionStatus:(BOOL)currentStatus{
    
    NSUserDefaults *appdefault = [NSUserDefaults standardUserDefaults];
    [appdefault setBool:currentStatus forKey:@"Terms"];
    [appdefault synchronize];
}

+(BOOL)getTermsAndConditionStatus{
    
    NSUserDefaults *appdefault = [NSUserDefaults standardUserDefaults];
    return [appdefault boolForKey:@"Terms"];
    
}


@end
