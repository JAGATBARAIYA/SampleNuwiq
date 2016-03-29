//
//  UIPlaceHolderTextView.h
//  Unknown
//
//  Created by Unknown on 5/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+extras.h"

@interface TextViewWithPlaceholder : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
	
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
-(void)setPlaceHolder;

@end