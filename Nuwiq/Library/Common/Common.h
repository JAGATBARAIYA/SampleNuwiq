//
//  Common.h
//  FlipIn
//
//  Created by Marvin on 20/11/13.
//  Copyright (c) 2013 Marvin. All rights reserved.
//

#ifndef iPhoneStructure_Common_h
#define iPhoneStructure_Common_h

#pragma mark - All Common Macros

#define isIOS8 (([[[UIDevice currentDevice] systemVersion]doubleValue] >= 8.0) ? 1 : 0)
#define isiPhone5                               (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define kUserDirectoryPath                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
#define IS_IOS7_OR_GREATER                      [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ? YES : NO
#define PLAYER                                  [MPMusicPlayerController iPodMusicPlayer]

#define IS_IPHONE                               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH                            ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                           ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH                       (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH                       (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IPHONE4                                 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IPHONE5                                 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IPHONE6                                 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IPHONE6PLUS                             (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define DegreesToRadians(degrees)               (degrees * M_PI / 180)
#define RadiansToDegrees(radians)               (radians * 180/M_PI)

#define SEGMENT_SELECTED_TEXT_COLOR             [UIColor blackColor]
#define SEGMENT_DESELECTED_TEXT_COLOR           [UIColor whiteColor]
#define SEGMENT_BACK_COLOR                      [UIColor colorWithRed:131.0/255.0 green:25.0/255.0 blue:12.0/255.0 alpha:1.0]

#define kDateFormat                             @"MMM dd, yyyy"
#define kTimeFormat                             @"hh:mm:ss"

#define kErrorImage                             [UIImage imageNamed:@"error"]
#define kRightImage                             [UIImage imageNamed:@"right"]

#define kUserInformation                        @"UserInformation"
#define kVisited                                @"isVisited"
#define kRemiderVisited                         @"isReminderVisited"

#define titleFail                               @"Fail"
#define titleSuccess                            @"Success"
#define titleAlert                              @"Alert"

#define msgLoading                              @"Loading"
#define msgPleaseWait                           @"Please wait..."

#define msgCameraNotAvailable                   @"Camera not available"           
#define msgNoDataFound                          @"No Record Found"           

#define titleFail                               @"Fail"           
#define titleSuccess                            @"Success"           

#define kDeviceTokenKey                         @"DeviceToken"
#define kdeviceToken                            [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey]

#define kGuideViewDisplay                       @"GuideViewDisplay"
#define kTrackedDate                            @"TrackedDate"
#define kHistoryGuide                           @"HistoryGuide"
#define kScrollIndex                            @"ScrollIndex"
#define kRemiderGuide                           @"ReminderGuide"
#define kReminderHand                           @"ReminderHand"
#define kProgressHand                           @"ProgressHand"
#define kShareViewShow                          @"ShareViewShow"
#define kIsFirstTime                            @"IsFirstTime"
#define kPushNotification                       @"PushNotification"
#define kLocalNotification                      @"LocalNotification"

//Login
#define msgEnterFullName                        @"Please enter full name."
#define msgEnterName                            @"Please enter name."
#define msgEnterFirstname                       @"Please enter first name."
#define msgEnterLastname                        @"Please enter last name."
#define msgEnterZipcode                         @"Please enter zip code."
#define msgEnterPhoneNo                         @"Please enter phone number."
#define msgEnterRemark                          @"Please enter remark."
#define msgEnterEmail                           @"Please enter email address."
#define msgEnterValidEmail                      @"Please enter a valid email address."
#define msgEnterValidPassword                   @"Please enter password."
#define msgPasswordNotMatch                     @"Password and confirm password must be same."

//Product
#define msgEnterProductName                     @"Please enter product name."
#define msgSelectCategory                       @"Please select category."
#define msgEnterPrice                           @"Please enter price of product."
#define msgEnterDesc                            @"Please enter description."
#define msgSelectImages                         @"Please upload atleast one image."

//Reset
#define msgResetTitle                           @"RESET"
#define msgResetDetail                          @"Are you sure you want to reset the data?"

//Date
#define msgDateGreater                          @"You can not select future date."
#define msgDelete                               @"Delete?"
#define msgDeleteImage                          @"Are you sure you want to delete?"

//Location
#define msgTimeOut                              @"Location request timed out. Current Location:\n%@"
#define msgLocationNotDetermine                 @"Location can not be determined. Please try again later."
#define msgUserDeniedPermission                 @"You have denied to access your device location."
#define msgUserRestrictedLocation               @"User is restricted using location services as per usage policy."
#define msgLocationTurnOff                      @"Location services are turned off for all apps on this device."
#define msgLocationError                        @"An unknown error occurred while retrieving current location. Please try again later."

#define REMOVE_ADS                              @"com.bcd.weather.removeadsaddmorecity"
#define UNLOCK_ALL_FEATURES                     @"com.bcd.weather.removeadsaddmorecity"



#endif
