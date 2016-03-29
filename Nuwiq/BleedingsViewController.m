//
//  BleedingsViewController.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/16/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "BleedingsViewController.h"
#import "SQLiteManager.h"
#import "BleedingLogs.h"
#import "TKAlertCenter.h"
#import "SIAlertView.h"
#import "BleedingLogsFormViewController.h"
#import "DoctorsInfo.h"
#import "AppDelegate.h"

#define kTableName      @"tblBleedingLogs"

@interface BleedingsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;
@property (strong, nonatomic) NSString *strEmailID;

@end

@implementation BleedingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Nuwiq";

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton=NO;
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _arrBleedingLogs = [[NSMutableArray alloc]init];
    NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblBleedingLogs order by bleedID desc"];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BleedingLogs *bleedingLogs = [BleedingLogs dataWithDict:obj];
        [_arrBleedingLogs addObject:bleedingLogs];
    }];
    _lblNoRecordFound.hidden = _arrBleedingLogs.count!=0;
    [tblView reloadData];
}

#pragma mark - Button Click Event

-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SendReportBtnClick:(UIButton *)sender
{
    BleedingReport *aBleedingReport = [[BleedingReport alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    aBleedingReport.aBleedingVC=self;
    aBleedingReport.delegate=self;
    [self.view addSubview:aBleedingReport];
}

-(IBAction)batnAddNew:(id)sender{
    BleedingLogsFormViewController *vc = [[BleedingLogsFormViewController alloc]initWithNibName:@"BleedingLogsFormViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnDeleteTapped:(UIButton*)sender{
    BleedingLogs *bleedLog = _arrBleedingLogs[sender.tag];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"DELETE" andMessage:@"Are you sure you want to Delete this log?"];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [_arrBleedingLogs removeObjectAtIndex:sender.tag];
                              [tblView beginUpdates];
                              [tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                              [tblView endUpdates];
                              NSString *deleteSQL = [NSString stringWithFormat: @"delete from tblBleedingLogs where bleedID = %d",bleedLog.intBleedingID];
                              [[SQLiteManager singleton] executeSql:deleteSQL];
                              [self commonInit];
                          }];
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
     
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

#pragma mark-TableView Delegate Mehtod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrBleedingLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"bleedingCell";
    
    BleedingCell *cell = (BleedingCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil){
        
        cell = (BleedingCell*)[[[NSBundle mainBundle] loadNibNamed:@"BleedingCell" owner:nil options:nil] objectAtIndex:0];
    }
    BleedingLogs *bleedLog = _arrBleedingLogs[indexPath.row];
    cell.bleeding_date.text = [NSString stringWithFormat:@"Date   %@",bleedLog.strBleedingDate];
    cell.bleeding_time.text = [NSString stringWithFormat:@"Time   %@",bleedLog.strBleedingTime];
    cell.lblNote.text = [NSString stringWithFormat:@"Note   %@",bleedLog.strBleedingNote];
    cell.bleeding_image.layer.cornerRadius=10;
    cell.bleeding_image.layer.borderWidth=1.0;
    cell.bleeding_image.layer.masksToBounds = YES;
    [cell.btnDelete addTarget:self action:@selector(btnDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BleedingLogs *bleedLog = _arrBleedingLogs[indexPath.row];
    BleedingLogsFormViewController *vc = [[BleedingLogsFormViewController alloc]initWithNibName:@"BleedingLogsFormViewController" bundle:nil];
    vc.bleedlogs = bleedLog;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103.0;
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
        [mailCompose addAttachmentData:[NSData dataWithContentsOfFile:filePath] mimeType:@"application/pdf" fileName:@"BleedingReport"];
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
