//
//  CombineReport.h
//  Nuwiq
//
//  Created by Mital Solanki on 01/09/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "PDFGenerator.h"
#import "PDFDefaults.h"

@class DoctorsViewController;

@protocol CombineReportDelegate <NSObject>

- (void)pdfDidCreateFinish:(NSString *)filePath;

@end

@interface CombineReport : PDFGenerator

@property(nonatomic,retain)NSString *strFilePath;
@property(nonatomic,retain)DoctorsViewController *aDoctorsVC;
@property (nonatomic,retain) id <CombineReportDelegate> delegate;

@end