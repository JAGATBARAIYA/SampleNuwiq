//
//  ViewController.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/14/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "ViewController.h"
#import "SIAlertView.h"
#import "NSObject+Extras.h"
#import "TKAlertCenter.h"
#import "Helper.h"

#define kAcceptTerms        @"Terms and condition accepted."

#define kErrorImage         [UIImage imageNamed:@"right"]

#define IS_IPHONE                               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH                            ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                           ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH                       (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH                       (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IPHONE4                                 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnAgree;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITextView *txtView1;
@property (strong, nonatomic) IBOutlet UITextView *txtView2;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewLogo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Nuwiq";
    self.navigationController.navigationBarHidden=YES;
    

    if (IPHONE4) {
        _imgViewLogo.frame = CGRectMake(109, 15, 103, 30);
        _txtView1.frame = CGRectMake(8, 45, 304, 227);
        _txtView2.frame = CGRectMake(8, 265, 304, 162);
    }

    [self allImagesOutAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)allImagesOutAnimations{
    _imgLogo.hidden = NO;
    _mainView.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        _imgLogo.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _imgLogo.transform = CGAffineTransformMakeScale(10.0, 10.0);
                _imgLogo.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (finished) {
                    _imgLogo.hidden = YES;
                    
                    if (![Helper getBoolFromUserDefaults:@"FirstTime"]) {
                        _mainView.hidden = NO;
                    }else{
                        [self performBlock:^{
                            HomeViewController *vc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                            _mainView.hidden = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        } afterDelay:0.2];
                    }
                }
            }];
        }
    }];
}

-(IBAction)btnAgree:(id)sender{
    
    if(termsAndCondition==TRUE){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:kAcceptTerms image:kErrorImage];
        [Utility setTermsAndConditionStatus:TRUE];
        HomeViewController *vc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        vc.navigationItem.hidesBackButton=YES;
        [self.navigationController pushViewController:vc animated:YES];
        [Helper addBoolToUserDefaults:YES forKey:@"FirstTime"];
    }
    else{
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Nuwiq" andMessage:NSLocalizedString(@"Agree", @"Message")];
        alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
}
-(IBAction)acceptTermCondition:(id)sender{
    _btnAgree.selected = !_btnAgree.selected;
    termsAndCondition = _btnAgree.selected;
}

@end
