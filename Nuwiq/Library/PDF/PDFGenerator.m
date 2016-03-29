
/********************************************************************************\
 * Project Name :    Rainbow
 *
 * File Name    :    PDFGenerator.h
 *
 * Author       :    Mital Solanki
 *
 * Created On   :    15th May, 2014.
 * 
 * Note         :    This Class only use for iOS7+.
 *
 * Copyright (c) 2014 IndiaNIC. All rights reserved.
 *
 \********************************************************************************/

#import "PDFGenerator.h"
#import "PDFDefaults.h"

@implementation PDFGenerator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// For New Page

- (void) writeHeader:(CGRect) aRect;
{
    @try
    {
        CGContextBeginPage(pdfContext, &aRect);
        UIGraphicsPushContext(pdfContext);
        CGContextTranslateCTM(pdfContext, 0, 20);
        CGContextScaleCTM(pdfContext, 1, -1);
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
            
    }
}

// For End Page

- (void) writeFooter:(CGRect) aRect;
{
    @try
    {
        CGContextEndPage (pdfContext);
        CGContextRelease (pdfContext);
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
        
    }
}

// Draw Horizontal Line

- (void) drawLineWithStartPoint:(CGPoint )startPoint EndPoint:(CGPoint )endPoint
{
    @try
    {
        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(currentContext, PDFDEFAULTS_LINE_WIDTH);
        CGContextSetStrokeColorWithColor(currentContext, [UIColor blackColor].CGColor);
        CGPoint sPoint =  CGPointMake(startPoint.x, startPoint.y);
        CGPoint ePoint =  CGPointMake(endPoint.x, endPoint.y);
        CGContextBeginPath(currentContext);
        CGContextMoveToPoint(currentContext, sPoint.x, sPoint.y);
        CGContextAddLineToPoint(currentContext, ePoint.x, ePoint.y);
        CGContextClosePath(currentContext);
        CGContextDrawPath(currentContext, kCGPathFillStroke);
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
        
    }
}

// Draw Text

- (void) writeText:(NSString *)aText ForXpos:(CGFloat)aFloatX ForYPos:(CGFloat)aFloatY ForFont:(UIFont *)aFont ForAlignment:(NSTextAlignment)aAlignment ForSize:(CGSize)aSize ForColor:(UIColor *)aColor
{
    @try
    {
        // Calculate ExpectedSize of Label
        NSMutableParagraphStyle *aParaStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        aParaStyle.lineBreakMode = NSLineBreakByWordWrapping ;
        aParaStyle.alignment = aAlignment;
        
        NSDictionary *dictAttributes = [NSDictionary dictionaryWithObjectsAndKeys:aFont, NSFontAttributeName, aColor, NSForegroundColorAttributeName, aParaStyle, NSParagraphStyleAttributeName, nil];
        CGSize expectedSize = [aText boundingRectWithSize:(CGSize){aSize.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:dictAttributes context: nil].size;
        
        // Draw Text
        [aText drawInRect:(CGRect){aFloatX, aFloatY, aSize.width, expectedSize.height} withAttributes:dictAttributes];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
        
    }
}

// Draw Image

- (void) writeImage:(UIImage *)aImage ForXpos:(CGFloat)aFloatX ForYPos:(CGFloat)aFloatY ForSize:(CGSize)aSize
{
    @try
    {
        // Draw Image
        [aImage drawInRect:(CGRect){aFloatX, aFloatY, aSize.width, aSize.height}];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
    }
    @finally
    {
        
    }
}

- (int)NoRecordFoundWithMessage:(NSString *)strMessage YPosition:(int)YPosition RowHeight:(int)rowHeight
{
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_XPos,YPosition+rowHeight}];
    [self writeText:strMessage ForXpos:PDFDEFAULTS_XPos ForYPos:YPosition ForFont:PDFDEFAULTS_TEXT_TITLE_NORMAL ForAlignment:NSTextAlignmentCenter ForSize:(CGSize){572,rowHeight} ForColor:FONT_BLACK];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos, YPosition} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition+rowHeight}];
    [self drawLineWithStartPoint:(CGPoint){PDFDEFAULTS_XPos, YPosition+rowHeight} EndPoint:(CGPoint){PDFDEFAULTS_PDF_WIDTH-PDFDEFAULTS_XPos,YPosition+rowHeight}];
    return YPosition+rowHeight;
}


@end
