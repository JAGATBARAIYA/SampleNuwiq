//
//  CombineReport.m
//  Nuwiq
//
//  Created by Mital Solanki on 01/09/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "CombineReport.h"
#import "DoctorsViewController.h"
#import "SQLiteManager.h"

@implementation CombineReport

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect
{
    @try
    {
        [self createPDFFile:@"CombineReport.pdf"];
        [self removeFromSuperview];
        
        if ([_delegate respondsToSelector:@selector(pdfDidCreateFinish:)])
        {
            [self performSelector:@selector(invokePDF) withObject:nil afterDelay:2];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
        
    }
}

-(void)invokePDF
{
    @try
    {
        [_delegate pdfDidCreateFinish:_strFilePath];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
        
    }
}

-(void) createPDFFile:(NSString *)fileName
{
    @try
    {
        NSString *pdfFilePath = [DocumentsDirectory stringByAppendingPathComponent:fileName];
        _strFilePath = pdfFilePath;
        const char *filename = [pdfFilePath UTF8String];
        
        CFStringRef path;
        CFURLRef url;
        CFMutableDictionaryRef myDictionary = NULL;
        // Create a CFString from the filename we provide to this method when we call it
        path = CFStringCreateWithCString (NULL, filename,kCFStringEncodingUTF8);
        // Create a CFURL using the CFString we just defined
        url = CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle, 0);
        CFRelease (path);
        CGRect pageRect;
        
        pageRect=CGRectMake(0,0,PDFDEFAULTS_PDF_WIDTH,PDFDEFAULTS_PDF_HEIGHT);
        pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary);
        
        CFRelease(url);
        
        [self writeInPDF:pageRect];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
        
    }
}

- (void)writeInPDF:(CGRect)aRect
{
    @try
    {
        [self writeHeader:aRect];
        
        int aIndex = 1;
        int intXPos = 20;
        int intYPos = PDFDEFAULTS_TOPMARGIN + 50;
        int intRowHeight = 20;
        int rowCounter = 0;
        
        [self writeText:@"Report" ForXpos:intXPos ForYPos:PDFDEFAULTS_TOPMARGIN+50 ForFont:PDFDEFAULTS_TEXT_HEADER_BOLD ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){572,30} ForColor:FONT_BLACK];
        intYPos += 40;
        
        [self drawLineWithStartPoint:(CGPoint){intXPos, intYPos} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-intXPos,intYPos}];
        intYPos += 20;
        
        if (self.aDoctorsVC.btnBleeding.isSelected)
        {
            [self writeText:[NSString stringWithFormat:@"%d.) Bleeding Log", aIndex] ForXpos:intXPos ForYPos:intYPos ForFont:PDFDEFAULTS_TEXT_TITLE_BOLD ForAlignment:NSTextAlignmentLeft ForSize:(CGSize){572,20} ForColor:FONT_RED];
            intYPos += 40;
            aIndex += 1;
            
            intYPos = [self CreateTableHeaderForBleedingWithYPosition:intYPos RowHeight:intRowHeight];
            
            NSArray *aMutArray = [[SQLiteManager singleton] find:@"*" from:@"tblBleedingLogs" where:@"isReport = '1'"];
            
            if (aMutArray.count > 0)
            {
                for (NSDictionary *aDict in aMutArray)
                {
                    if (intYPos + intRowHeight  >= PDFDEFAULTS_BOTTOMMARGIN)
                    {
                        [self writeFooter:aRect];
                        [self writeHeader:aRect];
                        intYPos = PDFDEFAULTS_TOPMARGIN + 50;
                        intYPos = [self CreateTableHeaderForBleedingWithYPosition:intYPos RowHeight:intRowHeight];
                        rowCounter = 0;
                    }
                    
                    if ([aDict[@"isReport"] intValue] == 1)
                        intYPos = [self CreateRowForBleedingWithDate:aDict[@"bleedDate"] Time:aDict[@"bleedTime"] Notes:aDict[@"bleedNote"] YPosition:intYPos RowHeight:intRowHeight];
                }
            }
            else
            {
                intYPos = [self NoRecordFoundWithMessage:@"Bleeding Log Not available!" YPosition:intYPos RowHeight:intRowHeight];
            }
        }
        intYPos += 20;
        
        if (self.aDoctorsVC.btnBarcode.isSelected)
        {
            [self writeText:[NSString stringWithFormat:@"%d.) Barcode Log", aIndex] ForXpos:intXPos ForYPos:intYPos ForFont:PDFDEFAULTS_TEXT_TITLE_BOLD ForAlignment:NSTextAlignmentLeft ForSize:(CGSize){572,20} ForColor:FONT_RED];
            intYPos += 40;
            aIndex += 1;
            
            intYPos = [self CreateTableHeaderForBarcodeWithYPosition:intYPos RowHeight:intRowHeight];
            
            NSArray *aMutArray = [[SQLiteManager singleton] find:@"*" from:@"tblBarCode" where:@"isReport = '1'"];
            
            if (aMutArray.count > 0)
            {
                for (NSDictionary *aDict in aMutArray)
                {
                    if (intYPos + intRowHeight  >= PDFDEFAULTS_BOTTOMMARGIN)
                    {
                        [self writeFooter:aRect];
                        [self writeHeader:aRect];
                        intYPos = PDFDEFAULTS_TOPMARGIN + 50;
                        intYPos = [self CreateTableHeaderForBarcodeWithYPosition:intYPos RowHeight:intRowHeight];
                        rowCounter = 0;
                    }
                    
                    if ([aDict[@"isReport"] intValue] == 1)
                        intYPos = [self CreateRowForBarcodeWithDate:aDict[@"date"] Time:aDict[@"time"] Data:aDict[@"data"] YPosition:intYPos RowHeight:intRowHeight];
                }
            }
            else
            {
               intYPos = [self NoRecordFoundWithMessage:@"Barcode Data Not available!" YPosition:intYPos RowHeight:intRowHeight];
            }
        }
        intYPos += 20;
        
        if (self.aDoctorsVC.btnReminder.isSelected)
        {            
            [self writeText:[NSString stringWithFormat:@"%d.) Reminder Log", aIndex] ForXpos:intXPos ForYPos:intYPos ForFont:PDFDEFAULTS_TEXT_TITLE_BOLD ForAlignment:NSTextAlignmentLeft ForSize:(CGSize){572,20} ForColor:FONT_RED];
            intYPos += 40;
            aIndex += 1;
            
            intYPos = [self CreateTableHeaderForReminderWithYPosition:intYPos RowHeight:intRowHeight];
            
            NSArray *aMutArray = [[SQLiteManager singleton] find:@"*" from:@"tblEvent" where:@"isReport = '1'"];
            
            if (aMutArray.count > 0)
            {
                for (NSDictionary *aDict in aMutArray)
                {
                    if (intYPos + intRowHeight  >= PDFDEFAULTS_BOTTOMMARGIN)
                    {
                        [self writeFooter:aRect];
                        [self writeHeader:aRect];
                        intYPos = PDFDEFAULTS_TOPMARGIN + 50;
                        intYPos = [self CreateTableHeaderForReminderWithYPosition:intYPos RowHeight:intRowHeight];
                        rowCounter = 0;
                    }
                    
                    if ([aDict[@"isReport"] intValue] == 1)
                        intYPos = [self CreateRowForReminderWithDate:aDict[@"eventDate"] Time:aDict[@"eventTime"] Dose:aDict[@"eventDose"] Repeat:aDict[@"eventRepeat"] MedicineTaken:aDict[@"isMedicineTaken"] YPosition:intYPos RowHeight:intRowHeight];
                }
            }
            else
            {
                intYPos = [self NoRecordFoundWithMessage:@"Reminder Log Not available!" YPosition:intYPos RowHeight:intRowHeight];
            }
        }
        
        [self writeFooter:aRect];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
        
    }
}

#pragma mark - User Define Methods

- (int)CreateTableHeaderForBleedingWithYPosition:(int)YPosition RowHeight:(int)rowHeight
{
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos,YPosition+rowHeight}];
    [self writeText:@"Date" ForXpos:PDFDEFAULTS_XPos ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+190, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+190,YPosition+rowHeight}];
    [self writeText:@"Time" ForXpos:PDFDEFAULTS_XPos+190 ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+380, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+380,YPosition+rowHeight}];
    [self writeText:@"Notes" ForXpos:PDFDEFAULTS_XPos+380 ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition+rowHeight}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition+rowHeight} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition+rowHeight}];
    return YPosition+rowHeight;
}

- (int)CreateRowForBleedingWithDate:(NSString *)strDate Time:(NSString *)strTime Notes:(NSString *)strData YPosition:(int)intYPosition RowHeight:(int)rowHeight
{
    [self writeText:strDate ForXpos:PDFDEFAULTS_XPos ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self writeText:strTime ForXpos:PDFDEFAULTS_XPos+190 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    
    NSMutableParagraphStyle *aParaStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    aParaStyle.lineBreakMode = NSLineBreakByWordWrapping ;
    aParaStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dictFieldValueAttributes = [NSDictionary dictionaryWithObjectsAndKeys:PDFDEFAULTS_TEXT_TITLE_NORMAL, NSFontAttributeName, aParaStyle, NSParagraphStyleAttributeName, nil];
    CGSize expectedSize = [strData boundingRectWithSize:(CGSize){192, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:dictFieldValueAttributes context: nil].size;
    [self writeText:strData ForXpos:PDFDEFAULTS_XPos+380 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){192,expectedSize.height} ForColor:FONT_BLACK];
    
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+190, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+190,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+380, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+380,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, intYPosition+expectedSize.height} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    return intYPosition+expectedSize.height;
}

- (int)CreateTableHeaderForBarcodeWithYPosition:(int)YPosition RowHeight:(int)rowHeight
{
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos,YPosition+rowHeight}];
    [self writeText:@"Date" ForXpos:PDFDEFAULTS_XPos ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+190, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+190,YPosition+rowHeight}];
    [self writeText:@"Time" ForXpos:PDFDEFAULTS_XPos+190 ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+380, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+380,YPosition+rowHeight}];
    [self writeText:@"Data" ForXpos:PDFDEFAULTS_XPos+380 ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition+rowHeight}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition+rowHeight} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition+rowHeight}];
    return YPosition+rowHeight;
}

- (int)CreateRowForBarcodeWithDate:(NSString *)strDate Time:(NSString *)strTime Data:(NSString *)strData YPosition:(int)intYPosition RowHeight:(int)rowHeight
{
    [self writeText:strDate ForXpos:PDFDEFAULTS_XPos ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self writeText:strTime ForXpos:PDFDEFAULTS_XPos+190 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    
    NSMutableParagraphStyle *aParaStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    aParaStyle.lineBreakMode = NSLineBreakByWordWrapping ;
    aParaStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dictFieldValueAttributes = [NSDictionary dictionaryWithObjectsAndKeys:PDFDEFAULTS_TEXT_TITLE_NORMAL, NSFontAttributeName, aParaStyle, NSParagraphStyleAttributeName, nil];
    CGSize expectedSize = [strData boundingRectWithSize:(CGSize){192, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:dictFieldValueAttributes context: nil].size;
    [self writeText:strData ForXpos:PDFDEFAULTS_XPos+380 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){192,expectedSize.height} ForColor:FONT_BLACK];
    
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+190, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+190,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+380, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+380,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, intYPosition+expectedSize.height} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    return intYPosition+expectedSize.height;
}
                                                                          
- (int)CreateTableHeaderForReminderWithYPosition:(int)YPosition RowHeight:(int)rowHeight
{
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos,YPosition+rowHeight}];
    [self writeText:@"Date" ForXpos:PDFDEFAULTS_XPos ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+114, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+114,YPosition+rowHeight}];
    [self writeText:@"Time" ForXpos:PDFDEFAULTS_XPos+114 ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+228, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+228,YPosition+rowHeight}];
    [self writeText:@"Dose" ForXpos:PDFDEFAULTS_XPos+228 ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+342, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+342,YPosition+rowHeight}];
    [self writeText:@"Repeat" ForXpos:PDFDEFAULTS_XPos+342 ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+456, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+456,YPosition+rowHeight}];
    [self writeText:@"Medicine taken" ForXpos:PDFDEFAULTS_XPos+456 ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition+rowHeight}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition+rowHeight} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition+rowHeight}];
    return YPosition+rowHeight;
}
                                                                          
- (int)CreateRowForReminderWithDate:(NSString *)strDate Time:(NSString *)strTime Dose:(NSString *)strDose Repeat:(NSString *)strRepeat MedicineTaken:(NSString *)strMedicineTaken YPosition:(int)intYPosition RowHeight:(int)rowHeight
{
    [self writeText:strDate ForXpos:PDFDEFAULTS_XPos ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,rowHeight} ForColor:FONT_BLACK];
    [self writeText:strTime ForXpos:PDFDEFAULTS_XPos+114 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,rowHeight} ForColor:FONT_BLACK];
    [self writeText:strDose ForXpos:PDFDEFAULTS_XPos+228 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,rowHeight} ForColor:FONT_BLACK];
    
    NSMutableParagraphStyle *aParaStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    aParaStyle.lineBreakMode = NSLineBreakByWordWrapping ;
    aParaStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dictFieldValueAttributes = [NSDictionary dictionaryWithObjectsAndKeys:PDFDEFAULTS_TEXT_TITLE_NORMAL, NSFontAttributeName, aParaStyle, NSParagraphStyleAttributeName, nil];
    CGSize expectedSize = [strRepeat boundingRectWithSize:(CGSize){114, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:dictFieldValueAttributes context: nil].size;
    [self writeText:strRepeat ForXpos:PDFDEFAULTS_XPos+342 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){114,expectedSize.height} ForColor:FONT_BLACK];
    [self writeText:strMedicineTaken ForXpos:PDFDEFAULTS_XPos+456 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){116,rowHeight} ForColor:FONT_BLACK];
    
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+114, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+114,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+228, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+228,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+342, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+342,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+456, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+456,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, intYPosition+expectedSize.height} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    return intYPosition+expectedSize.height;
}
                                                                          
@end