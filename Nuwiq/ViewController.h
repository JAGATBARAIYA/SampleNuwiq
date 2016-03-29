//
//  ViewController.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/14/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "Utility.h"

@interface ViewController : UIViewController{
    
    BOOL termsAndCondition;
    
}

-(IBAction)btnAgree:(id)sender;
-(IBAction)acceptTermCondition:(id)sender;



@end

