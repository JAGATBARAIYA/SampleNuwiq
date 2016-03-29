//
//  CustomCell.h
//  Task1
//
//  Created by Salman Khalid on 23/02/10.
//  Copyright 2010 Rolustech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BleedingCell : UITableViewCell {

    IBOutlet UIImageView      *bleeding_image;
    
    IBOutlet UILabel          *bleeding_time;
    IBOutlet UILabel          *bleeding_date;
    
}

@property (nonatomic,retain)IBOutlet UIImageView  *bleeding_image;
@property (nonatomic,retain)IBOutlet UILabel      *bleeding_time;
@property (nonatomic,retain)IBOutlet UILabel      *bleeding_date;
@property (nonatomic,retain)IBOutlet UILabel      *lblNote;
@property (strong, nonatomic) IBOutlet UIButton   *btnDelete;

@end
