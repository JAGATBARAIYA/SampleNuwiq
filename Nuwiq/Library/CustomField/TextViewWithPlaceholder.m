//
//  UIPlaceHolderTextView.m
//  Unknown
//
//  Created by Unknown on 5/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "TextViewWithPlaceholder.h"


@implementation TextViewWithPlaceholder

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:@"Note"];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];

    NSString *fontName = self.font.fontName;
    if([fontName containsString:@"Regular"])
        self.font = [UIFont fontWithName:@"Roboto-Regular" size:self.font.pointSize];
    else if([fontName containsString:@"Bold"])
        self.font = [UIFont fontWithName:@"Roboto-Bold" size:self.font.pointSize];
    else if([fontName containsString:@"Medium"])
        self.font = [UIFont fontWithName:@"Roboto-Medium" size:self.font.pointSize];
    else if([fontName containsString:@"Light"])
        self.font = [UIFont fontWithName:@"Roboto-Light" size:self.font.pointSize];
    else if([fontName containsString:@"Condensed Bold"])
        self.font = [UIFont fontWithName:@"Roboto-Bold" size:self.font.pointSize];
    else if([fontName containsString:@"Thin"])
        self.font = [UIFont fontWithName:@"Roboto-Thin" size:self.font.pointSize];
}

- (id)initWithFrame:(CGRect)frame{
    if( (self = [super initWithFrame:frame]) ){
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)setPlaceHolder{
	[self setPlaceholder:@""];
	[self setPlaceholderColor:[UIColor lightGrayColor]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];	
}

- (void)textChanged:(NSNotification *)notification{
    if([[self placeholder] length] == 0){
        return;
    }
	
    if([[self text] length] == 0){
        [[self viewWithTag:999] setAlpha:1];
    }else{
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect{
    if( [[self placeholder] length] > 0 ){
        if ( placeHolderLabel == nil ){
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
		
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 ) {
        [[self viewWithTag:999] setAlpha:1];
    }
	
    [super drawRect:rect];
}

@end