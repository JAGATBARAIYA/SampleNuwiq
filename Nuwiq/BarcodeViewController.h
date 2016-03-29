//
//  BarcodeViewController.h
//  Nuwiq
//
//  Created by FazalYazdan on 7/16/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import "ZBarSDK.h"
#import "BarcodeReport.h"

@interface BarcodeViewController : UIViewController <UIImagePickerControllerDelegate,ZBarReaderDelegate, BarcodeReportDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UIImageView *barcodeImage;
    IBOutlet UILabel     *barcodeString;
}

-(IBAction)btnScanBarcode:(id)sender;
-(IBAction)btnBack:(id)sender;
- (IBAction)SendReportBtnClick:(UIButton *)sender;




@end
