//
//  ReminderViewController.m
//  Nuwiq
//
//  Created by FazalYazdan on 7/16/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "ReminderViewController.h"
#import "TimeViewController.h"
#import "SQLiteManager.h"
#import "Event.h"
#import "JTCalendar.h"
#import "ReminderCell.h"
#import "NSDate+extras.h"
#import "SIAlertView.h"
#import "TKAlertCenter.h"
#import "NSObject+Extras.h"

#define kTableName      @"tblEvent"
#define IS_IPHONE                               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH                            ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                           ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH                       (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH                       (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IPHONE4                                 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IPHONE5                                 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IPHONE6                                 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IPHONE6PLUS                             (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface ReminderViewController ()<JTCalendarDataSource>
{
    NSMutableDictionary *eventsByDate;
    NSDate *_dateSelected;
}

@property (strong, nonatomic) NSMutableArray *arrEventDays;
@property (strong, nonatomic) NSMutableArray *arrTime;

@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        NSLog(@"Notification %lu: %@",(unsigned long)idx, notification);
    }];
    
    self.navigationItem.title=@"Nuwiq";
    CGRect newframe=_tblView.frame;
    newframe.origin.y = [UIScreen mainScreen].bounds.size.height;
    _tblView.frame=newframe;
    _arrTime = [NSMutableArray arrayWithObjects:@"12:00 AM",@"01:00 AM",@"02:00 AM",@"03:00 AM",@"04:00 AM",@"05:00 AM",@"06:00 AM",@"07:00 AM",@"08:00 AM",@"09:00 AM",@"10:00 AM",@"11:00 AM",@"12:00 PM",@"01:00 PM",@"02:00 PM",@"03:00 PM",@"04:00 PM",@"05:00 PM",@"06:00 PM",@"07:00 PM",@"08:00 PM",@"09:00 PM",@"10:00 PM",@"11:00 PM", nil];
    
    if (_isReminder) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Nuwiq" andMessage:@"Have you taken your medicine?"];
        alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
        [alertView addButtonWithTitle:@"YES"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                                  [self performBlock:^{
                                      NSString *updateSQL = [NSString stringWithFormat: @"UPDATE tblEvent set isMedicineTaken = %d WHERE eventID = %ld",1,(long)[_eventID integerValue]];
                                      [[SQLiteManager singleton] executeSql:updateSQL];
                                      [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Record added successfully." image:[UIImage imageNamed:@"right"]];
                                  } afterDelay:0.5];
                                  
                              }];
        [alertView addButtonWithTitle:@"NO"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  [self performBlock:^{
                                      NSString *updateSQL = [NSString stringWithFormat: @"UPDATE tblEvent set isMedicineTaken = %d WHERE eventID = %ld",0,(long)[_eventID integerValue]];
                                      [[SQLiteManager singleton] executeSql:updateSQL];
                                      [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Take your medicine as soon as possible." image:[UIImage imageNamed:@"error"]];
                                  } afterDelay:0.5];
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
   // [self initCalendar];
}

- (void)viewWillAppear:(BOOL)animated{
    [self createEvent];
    [self initCalendar];
    [self.calendar reloadData];
}

- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Init Calendar

- (void)initCalendar{
    _calendar = [JTCalendar new];
    self.calendar.calendarAppearance.calendar.firstWeekday = 2;
    self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
    self.calendar.calendarAppearance.ratioContentMenu = 1.;
    self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
    
    self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
        NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger currentMonthIndex = comps.month;
        static NSDateFormatter *dateFormatter;
        if(!dateFormatter){
            dateFormatter = [NSDateFormatter new];
            dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
        }
        while(currentMonthIndex <= 0){
            currentMonthIndex += 12;
        }
        NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
        return [NSString stringWithFormat:@"%ld\n%@", (long)comps.year, monthText];
    };
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    [self createEvent];
    
    [self.calendar reloadData];
}

#pragma mark - Calendar Delegate methods

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date{
    _dateSelected = date;
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSArray *events = eventsByDate[key];
    if (events) {
        NSArray *data  = [[SQLiteManager singleton]findAllFrom:kTableName];
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Event *event = [Event dataWithDict:obj];
            [_arrEventDays addObject:event];
        }];
        
        for (int i = 0; i< _arrEventDays.count; i++) {
            if ([[[_arrEventDays valueForKey:@"strEventDate"]objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@",[[self dateFormatter]stringFromDate:date]]]){
                TimeViewController *timeViewController = [[TimeViewController alloc]initWithNibName:@"TimeViewController" bundle:nil];
                self.calendar.calendarAppearance.isWeekMode = NO;
                [self removeTableView];
                [self transitionExample];
                timeViewController.strSelectedDate = [[self dateFormatter]stringFromDate:_dateSelected];
                timeViewController.event = _arrEventDays[i];
                [self.navigationController pushViewController:timeViewController animated:YES];
                
                break;
            }else{
                self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
                if (self.calendar.calendarAppearance.isWeekMode == YES) {
                    [self addTableView];
                }else{
                    [self removeTableView];
                }
                [self transitionExample];
            }
        }
    }else{
        self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
        if (self.calendar.calendarAppearance.isWeekMode == YES) {
            [self addTableView];
        }else{
            [self removeTableView];
        }
        [self transitionExample];
    }
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample{
    CGFloat newHeight = 0.0;
    if (IPHONE4 || IPHONE5) {
        newHeight = 400;
    }else if (IPHONE6){
        newHeight = 400;
    }else if (IPHONE6PLUS){
        newHeight = 570;
    }
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    [UIView animateWithDuration:.5
                     animations:^{
                         if (IPHONE4 || IPHONE5) {
                             self.calendarContentView.frame = CGRectMake(0, 168, 320, newHeight);
                         }else if (IPHONE6){
                             self.calendarContentView.frame = CGRectMake(0, 168, 375, newHeight);
                         }else if (IPHONE6PLUS){
                             self.calendarContentView.frame = CGRectMake(0, 168, 414, newHeight);
                         }
                         [self.view layoutIfNeeded];
                     }];
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

- (void)createEvent{
    eventsByDate = [NSMutableDictionary new];
    _arrEventDays = [[NSMutableArray alloc]init];
    
    NSArray *data  = [[SQLiteManager singleton]findAllFrom:kTableName];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Event *event = [Event dataWithDict:obj];
        [_arrEventDays addObject:event];
    }];
    
    for(int i = 0; i < _arrEventDays.count; i++){
        NSDate *randomDate = [[_arrEventDays objectAtIndex:i]valueForKey:@"strEventDate"];
        NSString *key = [NSString stringWithFormat:@"%@",randomDate];
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        [eventsByDate[key] addObject:randomDate];
    }
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    return dateFormatter;
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrTime.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ReminderCell";
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReminderCell" owner:self options:nil] objectAtIndex:0];
    
    cell.lblReminder.text = _arrTime[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    if (self.calendar.calendarAppearance.isWeekMode == YES) {
        [self addTableView];
    }else{
        [self removeTableView];
    }
    [self transitionExample];

    TimeViewController *timeViewController = [[TimeViewController alloc]initWithNibName:@"TimeViewController" bundle:nil];
    timeViewController.strSelectedDate = [[self dateFormatter]stringFromDate:_dateSelected];
    timeViewController.strTime = _arrTime[indexPath.row];
    [self.navigationController pushViewController:timeViewController animated:YES];
}

- (void)addTableView{
    [UIView animateWithDuration:0.7 animations:^{
        CGRect newframe=_tblView.frame;
        newframe.origin.y = 230;
        _tblView.frame=newframe;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeTableView{
    [UIView animateWithDuration:0.7 animations:^{
        CGRect newframe=_tblView.frame;
        newframe.origin.y = [UIScreen mainScreen].bounds.size.height;
        _tblView.frame=newframe;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)btnNextTapped:(id)sender{
    [_calendar loadNextPage];
}

- (IBAction)btnPreviousTapped:(id)sender{
    [_calendar loadPreviousPage];
}

@end
