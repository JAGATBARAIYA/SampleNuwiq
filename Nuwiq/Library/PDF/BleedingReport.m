//
//  BleedingReport.m
//  Nuwiq
//
//  Created by MAC-174 on 01/09/15.
//  Copyright (c) 2015 softcrust solutions. All rights reserved.
//

#import "BleedingReport.h"
#import "BleedingsViewController.h"
#import "BleedingLogs.h"
#import "SQLiteManager.h"

@implementation BleedingReport

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
        [self createPDFFile:@"BleedingReport.pdf"];
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
    
        int intXPos = 20;
        int intYPos = PDFDEFAULTS_TOPMARGIN + 50;
        int intRowHeight = 20;
        int rowCounter = 0;
        
        [self writeText:@"Report" ForXpos:intXPos ForYPos:PDFDEFAULTS_TOPMARGIN+50 ForFont:PDFDEFAULTS_TEXT_HEADER_BOLD ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){572,30} ForColor:FONT_BLACK];
        intYPos += 40;
        
        [self drawLineWithStartPoint:(CGPoint){intXPos, intYPos} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-intXPos,intYPos}];
        intYPos += 20;
        
        [self writeText:@"1.) Bleeding Log" ForXpos:intXPos ForYPos:intYPos ForFont:PDFDEFAULTS_TEXT_TITLE_BOLD ForAlignment:NSTextAlignmentLeft ForSize:(CGSize){572,20} ForColor:FONT_RED];
        intYPos += 40;
        
        intYPos = [self CreateTableHeaderWithYPosition:intYPos RowHeight:intRowHeight];
        
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
                    intYPos = [self CreateTableHeaderWithYPosition:intYPos RowHeight:intRowHeight];
                    rowCounter = 0;
                }
                
                if ([aDict[@"isReport"] intValue] == 1)
                    intYPos = [self CreateRowWithDate:aDict[@"bleedDate"] Time:aDict[@"bleedTime"] Notes:aDict[@"bleedNote"] YPosition:intYPos RowHeight:intRowHeight];
            }
        }
        else
        {
            [self NoRecordFoundWithMessage:@"Bleeding Log Not available!" YPosition:intYPos RowHeight:intRowHeight];
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

- (int)CreateTableHeaderWithYPosition:(int)YPosition RowHeight:(int)rowHeight
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

- (int)CreateRowWithDate:(NSString *)strDate Time:(NSString *)strTime Notes:(NSString *)strNotes YPosition:(int)intYPosition RowHeight:(int)rowHeight
{
    [self writeText:strDate ForXpos:PDFDEFAULTS_XPos ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    [self writeText:strTime ForXpos:PDFDEFAULTS_XPos+190 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){190,rowHeight} ForColor:FONT_BLACK];
    
    NSMutableParagraphStyle *aParaStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    aParaStyle.lineBreakMode = NSLineBreakByWordWrapping ;
    aParaStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dictFieldValueAttributes = [NSDictionary dictionaryWithObjectsAndKeys:PDFDEFAULTS_TEXT_TITLE_NORMAL, NSFontAttributeName, aParaStyle, NSParagraphStyleAttributeName, nil];
    CGSize expectedSize = [strNotes boundingRectWithSize:(CGSize){192, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:dictFieldValueAttributes context: nil].size;
    [self writeText:strNotes ForXpos:PDFDEFAULTS_XPos+380 ForYPos:intYPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){192,expectedSize.height} ForColor:FONT_BLACK];
    
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+190, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+190,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos+380, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos+380,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos, intYPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, intYPosition+expectedSize.height} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,intYPosition+expectedSize.height}];
    return intYPosition+expectedSize.height;
}

@end