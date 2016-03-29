//
//  SocialMedia.h
//  iPhoneStructure
//
//  Created by Marvin on 01/08/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#define kFacebookErrorMsg               @"Please set your Facebook account in Settings."
#define kFacebookAccessDeniedMsg        @"Facebook Access denied."

#define kTwitterErrorMsg                @"Please set your Twitter account in Settings."
#define kTwitterAccessDeniedMsg         @"Twitter Access denied."

#define kFacebookPostSuccessMsg         @"Message successfully posted on Facebook."
#define kFacebookPostFailureMsg         @"Unable to post message on Facebook."

#define kTwitterPostSuccessMsg          @"Message successfully posted on Twitter."
#define kTwitterPostFailureMsg          @"Unalble to post message on Twitter."

#define kEmailNotConfigured             @"Please configure email accouns from Settings."
#define kUnableToSendEmail              @"Unable to send email. Please try again later."
#define kEmailSentSuccess               @"Email sent successfully."

#define kSMSNotSentAlert                @"Unable to send message. Please try again later."
#define kSMSSentSuccess                 @"Message sent successfully."

#define kMsgUnableToSavePhoto           @"Unable to save photo, please try again later."
#define kMsgPhotoSaveSuccess            @"Your ChristmasCard saved successfully."

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
//#import "MGInstagram.h"
//#import "ALAssetsLibrary+CustomPhotoAlbum.h"
//#import "Loader.h"

typedef void(^SocialMediaCallback)(BOOL success,NSError *error);

@interface SocialMedia : NSObject <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate>

+ (instancetype)sharedInstance;

@property (strong, nonatomic) SocialMediaCallback callback;
@property (strong, nonatomic) UIDocumentInteractionController * documentationInteractionController;

//Facebook Twitter Sharing
-(void)shareViaFacebook:(UIViewController *)controller params:(NSDictionary *)params callback:(SocialMediaCallback)callback;
-(void)shareViaTwitter:(UIViewController *)controller params:(NSDictionary *)params callback:(SocialMediaCallback)callback;

//Email/Message Sharing
- (void)shareViaEmail:(UIViewController *)controller params:(NSDictionary *)params callback:(SocialMediaCallback)callback;
- (void)shareViaMessage:(UIViewController *)controller params:(NSDictionary *)params callback:(SocialMediaCallback)callback;

//Instagram
- (void)shareViaInstagram:(UIImage *)image view:(UIViewController*)controller;

//Save to Photo library
- (void)saveImageToPhotoLibrary:(UIImage *)image callback:(SocialMediaCallback)callback;

//ShareImage via Whatsapp
- (void)shareImageViaWhatsapp:(UIImage *)image controller:(UIViewController*)controller;
@end
