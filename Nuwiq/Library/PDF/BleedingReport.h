//
//  BleedingReport.h
//  Nuwiq
//
//  Created by MAC-174 on 01/09/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "PDFGenerator.h"
#import "PDFDefaults.h"

@class BleedingsViewController;

@protocol BleedingReportDelegate <NSObject>

- (void)pdfDidCreateFinish:(NSString *)filePath;

@end

@interface BleedingReport : PDFGenerator

@property(nonatomic,retain)NSString *strFilePath;
@property(nonatomic,retain)BleedingsViewController *aBleedingVC;
@property (nonatomic,retain) id <BleedingReportDelegate> delegate;

@end