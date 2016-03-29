//
//  JTCalendarMonthView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMonthView.h"

#import "JTCalendarMonthWeekDaysView.h"
#import "JTCalendarWeekView.h"

#define WEEKS_TO_DISPLAY 6

@interface JTCalendarMonthView (){
    JTCalendarMonthWeekDaysView *weekdaysView;
    NSArray *weeksViews;
    
    NSUInteger currentMonthIndex;
    BOOL cacheLastWeekMode; // Avoid some operations
};

@end

@implementation JTCalendarMonthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{    
    NSMutableArray *views = [NSMutableArray new];
    
    {
        weekdaysView = [JTCalendarMonthWeekDaysView new];
        [self addSubview:weekdaysView];
    }
    
    for(int i = 0; i < WEEKS_TO_DISPLAY; ++i){
        UIView *view = [JTCalendarWeekView new];
        
        [views addObject:view];
        [self addSubview:view];
    }
    
    weeksViews = views;
    
    cacheLastWeekMode = self.calendarManager.calendarAppearance.isWeekMode;
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    [super layoutSubviews];
}

- (void)configureConstraintsForSubviews
{
    CGFloat weeksToDisplay;
    
    if(cacheLastWeekMode){
        weeksToDisplay = 2.;
    }
    else{
        weeksToDisplay = (CGFloat)(WEEKS_TO_DISPLAY + 1); // + 1 for weekDays
    }
    
    CGFloat y = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height / weeksToDisplay;

    for(int i = 0; i < self.subviews.count; i++){
        UIView *view = self.subviews[i];
        view.frame = CGRectMake(0, y, width, height);
        y = CGRectGetMaxY(view.frame);
        //NSLog(@"y = %f",y);
        if(!cacheLastWeekMode){
            if (y == 300 || y == 150) {

            }else if ((y > 87 && y <131)){
                view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_age"]];//[UIColor colorWithRed:120.0/255.0 green:19.0/255.0 blue:0.0/2550.0 alpha:1.0];
            }else if (y > 174 && y <218){
                view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_age"]];//[UIColor colorWithRed:120.0/255.0 green:19.0/255.0 blue:0.0/2550.0 alpha:1.0];
            }else if (y > 257 && y <300){
                view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_age"]];//[UIColor colorWithRed:120.0/255.0 green:19.0/255.0 blue:0.0/2550.0 alpha:1.0];
            }
        }else{

        }
        
        if(cacheLastWeekMode && i == weeksToDisplay - 1){
            height = 0.;
        }
    }
}

- (void)setBeginningOfMonth:(NSDate *)date
{
    NSDate *currentDate = date;
    
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
                
        currentMonthIndex = comps.month;
        
        // Hack
        if(comps.day > 7){
            currentMonthIndex = (currentMonthIndex % 12) + 1;
        }
    }
        
    for(JTCalendarWeekView *view in weeksViews){
        view.currentMonthIndex = currentMonthIndex;
        [view setBeginningOfWeek:currentDate];
                
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 7;
        
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
        
        // Doesn't need to do other weeks
        if(self.calendarManager.calendarAppearance.isWeekMode){
            break;
        }
    }
}

#pragma mark - JTCalendarManager

- (void)setCalendarManager:(JTCalendar *)calendarManager
{
    self->_calendarManager = calendarManager;
    
    [weekdaysView setCalendarManager:calendarManager];
    for(JTCalendarWeekView *view in weeksViews){
        [view setCalendarManager:calendarManager];
    }
}

- (void)reloadData
{
    for(JTCalendarWeekView *view in weeksViews){
        [view reloadData];
        
        // Doesn't need to do other weeks
        if(self.calendarManager.calendarAppearance.isWeekMode){
            break;
        }
    }
}

- (void)reloadAppearance
{
    if(cacheLastWeekMode != self.calendarManager.calendarAppearance.isWeekMode){
        cacheLastWeekMode = self.calendarManager.calendarAppearance.isWeekMode;
        [self configureConstraintsForSubviews];
    }
    
    [JTCalendarMonthWeekDaysView beforeReloadAppearance];
    [weekdaysView reloadAppearance];
    
    for(JTCalendarWeekView *view in weeksViews){
        [view reloadAppearance];
    }
}

@end
