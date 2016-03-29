//
//  DoctorsViewController.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/15/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "DoctorsViewController.h"
#import "Helper.h"
#import "BadgeCell.h"
#import "SIAlertView.h"
#import "SQLiteManager.h"
#import "Event.h"
#import "CombineReport.h"

@interface DoctorsViewController ()<UIGestureRecognizerDelegate,BadgeCellDelegate, CombineReportDelegate>
{
    BOOL isFlag;
}

@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;
@property (strong, nonatomic) NSString *strEmailID;
@property (strong, nonatomic) NSMutableArray *arrReminder;

@end

@implementation DoctorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     edit=FALSE;
    self.navigationItem.title=@"Nuwiq";
    self.navigationItem.hidesBackButton=NO;
    _subView.layer.cornerRadius = 10.0;
    _subView.layer.borderWidth = 1.0;
    _subView.clipsToBounds = YES;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5;
    lpgr.delegate = self;
    [tblView addGestureRecognizer:lpgr];
    
    NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblEvent"];
    
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Event *event = [Event dataWithDict:obj];
        [_arrReminder addObject:event];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAllDoctors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Get All Doctor Info

-(void)getAllDoctors{
    allDoctors = [[NSMutableArray alloc]init];
    sqlite3_stmt * ReturnStatement;
    AppDelegate *obj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM DoctorsInfo order by is_my_doctor desc, doctor_id desc"];
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
        
        [allDoctors addObject:dInfo];
    }
    _lblNoRecordFound.hidden = allDoctors.count!=0;
    [tblView reloadData];
}

#pragma mark - Button Click Event

-(IBAction)btnAddNew:(id)sender{
    AddNewDoctorsViewController *vc = [[AddNewDoctorsViewController alloc]initWithNibName:@"AddNewDoctorsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnBleedTapped:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(IBAction)btnRemindarTapped:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(IBAction)btnBarcodeTapped:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(IBAction)btnDoneTapped:(id)sender
{
    _popUpView.hidden = YES;
    
    CombineReport *aCombineReport = [[CombineReport alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    aCombineReport.aDoctorsVC=self;
    aCombineReport.delegate=self;
    [self.view addSubview:aCombineReport];
}

-(IBAction)btnCancelTapped:(id)sender{
    _popUpView.hidden = YES;
}

#pragma mark - Long Press Gesture

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:p];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        DoctorsInfo *doctorInfo = nil;
        doctorInfo = allDoctors[indexPath.row];
        AddNewDoctorsViewController *vc = [[AddNewDoctorsViewController alloc]initWithNibName:@"AddNewDoctorsViewController" bundle:nil];
        vc.doctorInfo = doctorInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark-TableView Delegate Mehtod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allDoctors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"doctorsCell";
    
    NSString *nibName = @"BadgeCell";
    if(edit==TRUE && selectedIndex.row==indexPath.row){
        nibName = @"BadgeCell2";
    }
    
    BadgeCell *cell = (BadgeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        
        cell = (BadgeCell*)[[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    }
    
    DoctorsInfo *dInfo = (DoctorsInfo *)[allDoctors objectAtIndex:indexPath.row];
    cell.doctor_name.text=dInfo.doctor_name;
    cell.hospital_name.text=dInfo.hospital_name;
    [cell.btnEmail setTitle:dInfo.email_address forState:UIControlStateNormal];
    [cell.btnPhone setTitle:dInfo.contact_no forState:UIControlStateNormal];
    cell.doctorInfo = dInfo;
    cell.btnAdd.tag=indexPath.row;
    cell.btnEmail.tag=indexPath.row;
    cell.btnPhone.tag=indexPath.row;
    cell.btnCheck.selected = dInfo.is_my_doctor;
    cell.btnReport.hidden = !dInfo.is_my_doctor;
    if (cell.btnCheck.selected) {
        _strEmailID = dInfo.email_address;
    }
    
    cell.delegate = self;
    
    [cell.btnAdd addTarget:self action:@selector(doctorDetails:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEmail addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPhone addTarget:self action:@selector(dialPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnReport addTarget:self action:@selector(btnReportTapped:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(edit==TRUE && selectedIndex.row==indexPath.row)
        return 180.0;
    else
        return 60.0;
}

-(void)doctorDetails:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    selectedIndex=indexPath;

    if(edit==FALSE){
        edit=TRUE;
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else{
        edit=FALSE;
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)sendEmail:(id)sender{
    UIButton *button = (UIButton *)sender;
    DoctorsInfo *dInfo = (DoctorsInfo *)[allDoctors objectAtIndex:button.tag];
    NSLog(@"email address is =%@",dInfo.email_address);
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    NSArray *toRecipients = [NSArray arrayWithObjects:dInfo.email_address, nil];
    [picker setToRecipients:toRecipients];
    [picker setSubject:@"Email From Nuwiq."];
    [picker setMessageBody:@"Testing" isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark mail method
- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {

    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            NSLog(@"Sent mail Cancel...");
            break;
        case MFMailComposeResultSaved:
            
            NSLog(@"Saving Draft...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Sending mail Successfully...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Sending mail filed...");
            
            break;
        default:
            NSLog(@"Not Send mail..");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dialPhoneNumber:(id)sender{
    UIButton *button = (UIButton *)sender;
    DoctorsInfo *dInfo = (DoctorsInfo *)[allDoctors objectAtIndex:button.tag];
    NSLog(@"contact no is =%@",dInfo.contact_no);

    NSString*numToDial = [dInfo.contact_no stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numToDial]]];
}

-(IBAction)btnReportTapped:(id)sender{
    UIButton *button = (UIButton *)sender;
    DoctorsInfo *dInfo = (DoctorsInfo *)[allDoctors objectAtIndex:button.tag];
    NSLog(@"contact no is =%@",dInfo.contact_no);
    _popUpView.hidden = NO;
}

#pragma mark - Delegate Method

- (void)reloadTableView{
    [self getAllDoctors];
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
        [mailCompose addAttachmentData:[NSData dataWithContentsOfFile:filePath] mimeType:@"application/pdf" fileName:@"Report"];
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


@end
