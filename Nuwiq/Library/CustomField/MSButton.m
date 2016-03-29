//
//  MSButton.m
//  iPhoneStructure
//
//  Created by Marvin on 21/11/13.
//  Copyright (c) 2013 Marvin. All rights reserved.
//

#import "MSButton.h"

@implementation MSButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib{
    NSString *fontName = self.titleLabel.font.fontName;
    if([fontName containsString:@"Regular"])
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:self.titleLabel.font.pointSize];
    else if([fontName containsString:@"Bold"])
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:self.titleLabel.font.pointSize];
    else if([fontName containsString:@"Medium"])
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:self.titleLabel.font.pointSize];
    else if([fontName containsString:@"Light"])
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:self.titleLabel.font.pointSize];
    else if([fontName containsString:@"Condensed Bold"])
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:self.titleLabel.font.pointSize];
    else if([fontName containsString:@"Thin"])
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:self.titleLabel.font.pointSize];
}


@end
