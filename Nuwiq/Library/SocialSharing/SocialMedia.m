//
//  SocialMedia.m
//  iPhoneStructure
//
//  Created by Marvin on 01/08/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import "SocialMedia.h"
#import "Helper.h"
#import "NSString+extras.h"

@implementation SocialMedia

+ (instancetype)sharedInstance{
    static SocialMedia *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

#pragma mark - Share Via Facebook

-(void)shareViaFacebook:(UIViewController *)controller params:(NSDictionary *)params callback:(SocialMediaCallback)callback{
    NSError *error;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];

    NSString *message = [params objectForKey:@"Message"];
    UIImage *image = [params objectForKey:@"Image"];

    SLComposeViewControllerCompletionHandler __block completionHandler = ^(SLComposeViewControllerResult result) {
        [controller dismissViewControllerAnimated:YES completion:^{
            switch(result){
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                    callback(YES,nil);
                    break;
            }
        }];
    };
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *composeViewController  = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeViewController setInitialText:(message)?message:@""];
        [composeViewController addImage:(image)?image:nil];
        [controller presentViewController:composeViewController animated:YES completion:nil];
        composeViewController.completionHandler = completionHandler;
    }
    else{
        [details setValue:kFacebookErrorMsg forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"Domain" code:error.code userInfo:details];
        callback(NO,error);
    }
}

#pragma mark - Share Via Twitter

-(void)shareViaTwitter:(UIViewController *)controller params:(NSDictionary *)params callback:(SocialMediaCallback)callback{
    NSError *error;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];

    NSString *message = [params objectForKey:@"Message"];
    UIImage *image = [params objectForKey:@"Image"];

    SLComposeViewControllerCompletionHandler __block completionHandler = ^(SLComposeViewControllerResult result) {
        [controller dismissViewControllerAnimated:YES completion:^{
            switch(result){
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                    callback(YES,nil);
                    break;
            }
        }];
    };

    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *composeViewController  = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [composeViewController setInitialText:(message)?message:@""];
        [composeViewController addImage:(image)?image:nil];
        [controller presentViewController:composeViewController animated:YES completion:nil];
        composeViewController.completionHandler = completionHandler;
    }
    else{
        [details setValue:kTwitterErrorMsg forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"Domain" code:error.code userInfo:details];
        callback(NO,error);
    }
}

#pragma mark - Share via Email

- (void)shareViaEmail:(UIViewController *)controller params:(NSDictionary *)params callback:(SocialMediaCallback)callback{
    self.callback = callback;
    NSError *error;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *msgcontroller = [[MFMailComposeViewController alloc] init];
        msgcontroller.mailComposeDelegate = self;
        [msgcontroller setSubject:params[@"subject"]];
        [msgcontroller setMessageBody:params[@"message"] isHTML:NO];
        NSData *data = params[@"data"];
        if(data)
            [msgcontroller addAttachmentData:data mimeType:@"image/jpeg" fileName:@"Nuwiq"];
        [controller presentViewController:msgcontroller animated:YES completion:nil];
    }else{
        [details setValue:kEmailNotConfigured forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"Domain" code:error.code userInfo:details];
        callback(NO,error);
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    NSError *mailError;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
	switch (result){
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
		    break;
		case MFMailComposeResultSent:
            self.callback(YES,nil);
            break;
		case MFMailComposeResultFailed:
            [details setValue:kUnableToSendEmail forKey:NSLocalizedDescriptionKey];
            mailError = [NSError errorWithDomain:@"Domain" code:error.code userInfo:details];
            self.callback(NO,mailError);
		    break;
		default:
		    break;
	}
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Share via Message

- (void)shareViaMessage:(UIViewController *)controller params:(NSDictionary *)params callback:(SocialMediaCallback)callback{
    if ([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setBody:params[@"message"]];
        NSData *data = params[@"data"];
        if(data)
            [messageController addAttachmentData:data typeIdentifier:@"image/jpeg" filename:@"MerryChrismas2014"];
        [controller presentViewController:messageController animated:YES completion:nil];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSError *mailError;
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    switch (result){
        case MessageComposeResultCancelled:
            break;
		case MessageComposeResultSent:
            self.callback(YES,nil);
		    break;
		case MessageComposeResultFailed:
            [details setValue:kSMSNotSentAlert forKey:NSLocalizedDescriptionKey];
            mailError = [NSError errorWithDomain:@"Domain" code:mailError.code userInfo:details];
            self.callback(NO,mailError);
		    break;
		default:
		    break;
	}
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Instagram Image sharing

//- (void) postInstagramImage:(UIImage*)image view:(UIView*)view{
//    if ([MGInstagram isAppInstalled])
//        [MGInstagram postImage:image withCaption:@"Merry Christmas 14" inView:view];
//    else{
//        [Helper siAlertView:@"Instagram Not Installed!" msg:@"Instagram must be installed on the device in order to post images."];
//    }
//}
//
//- (UIAlertView*)notInstalledAlert{
//    return [[UIAlertView alloc] initWithTitle:@"Instagram Not Installed!" message:@"Instagram must be installed on the device in order to post images." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//}
//
//- (void)shareViaInstagram:(UIImage *)image view:(UIViewController*)controller {
//    [self postInstagramImage:image view:controller.view];
//}

#pragma mark - Save to Photo Library

//- (void)saveImageToPhotoLibrary:(UIImage *)image callback:(SocialMediaCallback)callback{
//    [[Loader defaultLoader] displayLoadingView:@"Saving..."];
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
//    [library saveImage:image toAlbum:appName withCompletionBlock:^(NSError *error) {
//        [[Loader defaultLoader] hideLoadingView];
//        if (error) {
//            NSLog(@"%ld",(long)error.code);
//            NSError *photoError;
//            NSMutableDictionary* details = [NSMutableDictionary dictionary];
//            if(error.code==-3311){
//                [details setValue:@"This app does not have access to your photos or videos. You can enable access in Privacy Settings." forKey:NSLocalizedDescriptionKey];
//            }else {
//                [details setValue:error.localizedFailureReason forKey:NSLocalizedDescriptionKey];
//            }
//            photoError = [NSError errorWithDomain:@"Domain" code:error.code userInfo:details];
//            callback(NO,photoError);
//        }else{
//            callback(YES,nil);
//        }
//    }];
//}

#pragma mark - Whatsapp Image Sharing

#define kFileName @"MerriChristmas14.png"
NSString* const kWhatsAppURLString = @"whatsapp://app";

- (void)shareImageViaWhatsapp:(UIImage *)image controller:(UIViewController*)controller{
    if([self isAppInstalled]){
        NSString *filePath = [@"MerriChristmas14.png" documentDirectory];
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        
        _documentationInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        _documentationInteractionController.delegate = self;
        _documentationInteractionController.UTI = @"net.whatsapp.image";

        [_documentationInteractionController presentOpenInMenuFromRect:CGRectZero inView:controller.view animated:YES];
    }else{
        [Helper siAlertView:@"Whatsapp Not Installed!" msg:@"Whatsapp must be installed on the device in order to post images."];
    }
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    [[NSFileManager defaultManager] removeItemAtPath:[Helper getDocumentDirectoryPath:@""] error:nil];
}

- (BOOL) isAppInstalled {
    NSURL *appURL = [NSURL URLWithString:kWhatsAppURLString];
    return [[UIApplication sharedApplication] canOpenURL:appURL];
}

@end
