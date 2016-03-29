//
//  CustomCell.m
//  Task1
//
//  Created by Salman Khalid on 23/02/10.
//  Copyright 2010 Rolustech. All rights reserved.
//

#import "BleedingCell.h"


@implementation BleedingCell

@synthesize bleeding_date,bleeding_image,bleeding_time;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	}
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
