//
//  BarcodeReport.h
//  Nuwiq
//
//  Created by Mital Solanki on 01/09/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "PDFGenerator.h"
#import "PDFDefaults.h"

@class BarcodeViewController;

@protocol BarcodeReportDelegate <NSObject>

- (void)pdfDidCreateFinish:(NSString *)filePath;

@end

@interface BarcodeReport : PDFGenerator

@property(nonatomic,retain)NSString *strFilePath;
@property(nonatomic,retain)BarcodeViewController *aBarcodeVC;
@property (nonatomic,retain) id <BarcodeReportDelegate> delegate;

@end