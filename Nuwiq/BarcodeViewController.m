//
//  BarcodeViewController.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/16/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "BarcodeViewController.h"
#import "SQLiteManager.h"
#import "TKAlertCenter.h"
#import "SIAlertView.h"
#import "SocialMedia.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "DoctorsInfo.h"

@interface BarcodeViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnScan;
@property (strong, nonatomic) IBOutlet UIButton *btnDiscard;
@property (strong, nonatomic) NSString *strEmailID;

@end

@implementation BarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    barcodeString.hidden=YES;
    self.navigationItem.title=@"Nuwiq";
    
    _btnScan.layer.cornerRadius = _btnScan.frame.size.height / 2;
    _btnDiscard.layer.cornerRadius = _btnScan.frame.size.height / 2;

    sqlite3_stmt * ReturnStatement;
    AppDelegate *obj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM DoctorsInfo"];
    ReturnStatement = [obj getStatement:strQuery];
    while(sqlite3_step(ReturnStatement) == SQLITE_ROW)
    {
        DoctorsInfo *dInfo = [[DoctorsInfo alloc]init];
        dInfo.doctor_id = sqlite3_column_int(ReturnStatement, 0);
        dInfo.doctor_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 1)];
        dInfo.hospital_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 2)];
        dInfo.contact_no = [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 3)];
        dInfo.email_address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 4)];
        dInfo.is_my_doctor = sqlite3_column_int(ReturnStatement, 5);
        if (dInfo.is_my_doctor) {
            _strEmailID = dInfo.email_address;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnScanBarcode:(id)sender{
    if ([_btnScan.titleLabel.text isEqualToString:@"Save"]) {
        [self saveData:barcodeString.text];
    }else{
        [self startScaning];
    }
}

-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SendReportBtnClick:(UIButton *)sender
{
    BarcodeReport *aBarcodeReport = [[BarcodeReport alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    aBarcodeReport.aBarcodeVC=self;
    aBarcodeReport.delegate=self;
    [self.view addSubview:aBarcodeReport];
}

-(void)startScaning{
    
    ZBarReaderViewController *codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=(id)self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    codeReader.cameraFlashMode=UIImagePickerControllerCameraFlashModeOff;
    
    ZBarImageScanner *scanner = codeReader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 1];
    [scanner setSymbology: ZBAR_CODE39 config: ZBAR_CFG_ADD_CHECK to: 0];
    [scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ADD_CHECK to:1];
    [scanner setSymbology:ZBAR_EAN13 config:ZBAR_CFG_ADD_CHECK to:1];
    [scanner setSymbology: ZBAR_PDF417 config: ZBAR_CFG_ENABLE to: 1];
    
    [self presentViewController:codeReader animated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picke{
    [picke dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Get Resutl

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //  get the decode results
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    barcodeString.hidden=NO;
    // showing the result on textview
    barcodeString.text=symbol.data;
    barcodeImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissViewControllerAnimated:YES completion:nil];
//    [_btnScan setTitle:@"Save" forState:UIControlStateNormal];
    [_btnScan setTitle:@"Save" forState:UIControlStateNormal];
    _btnDiscard.hidden = NO;
//    [self saveData:symbol.data];
}

-(void)saveData:(NSString *)strData{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);

    NSArray *arrDateTime = [[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "];
    
    NSString *strTime = [[NSString stringWithFormat:@"%@ ",arrDateTime[1]] stringByAppendingString:arrDateTime[2]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Barcode Saved." andMessage:@"Do you want to add this to your Report?"];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [_btnScan setTitle:@"Scan" forState:UIControlStateNormal];
                              NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblBarCode (data,isReport,date,time) VALUES ('%@',%d,'%@','%@')",strData,1,arrDateTime[0],strTime];
                              [[SQLiteManager singleton] executeSql:insertSQL];
                              [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Scanned Data Added Successfully." image:[UIImage imageNamed:@"right"]];
                              _btnDiscard.hidden = YES;
                          }];
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
                            handler:^(SIAlertView *alert) {
                                [_btnScan setTitle:@"Scan" forState:UIControlStateNormal];
                                NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblBarCode (data,isReport,date,time) VALUES ('%@',%d,'%@','%@')",strData,0,arrDateTime[0],strTime];
                                [[SQLiteManager singleton] executeSql:insertSQL];
                                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Scanned Data Added Successfully." image:[UIImage imageNamed:@"right"]];
                                _btnDiscard.hidden = YES;
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (IBAction)btnDiscardTapped:(id)sender{
    [self startScaning];
    _btnDiscard.hidden = YES;
}

- (IBAction)btnSendReportTapped:(id)sender{
    NSData *data = nil;
    NSDictionary *dict = @{@"subject":@"Nuwiq",@"message":@"",@"data":data};
    [[SocialMedia sharedInstance] shareViaEmail:self params:dict callback:^(BOOL success, NSError *error) {
        if(error){
            [Helper siAlertView:titleFail msg:error.localizedDescription];
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Send successfully." image:[UIImage imageNamed:@"right"]];
        }
    }];
}

#pragma mark - PDF Delegate Methods

-(void) pdfDidCreateFinish:(NSString *)filePath
{
    NSLog(@"FilePath : %@", filePath);
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setMailComposeDelegate:self];
        [mailCompose setSubject:@"Report"];
        if ([_strEmailID isEqualToString:@""] || _strEmailID == nil) {
       
        }else{
            [mailCompose setToRecipients:@[_strEmailID]];
        }
        [mailCompose addAttachmentData:[NSData dataWithContentsOfFile:filePath] mimeType:@"application/pdf" fileName:@"BarcodeReport"];
        [self presentViewController:mailCompose animated:YES completion:NULL];
    }
    else
    {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"Mail account is not configure."];
        alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
        [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alert)
        {
                                  
        }];
        
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
}

#pragma mark - MFMailComposeViewController Delegate Methods

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
