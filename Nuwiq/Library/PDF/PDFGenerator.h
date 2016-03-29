
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
 \********************************************************************************/

#import <UIKit/UIKit.h>

#define DocumentsDirectory          [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) objectAtIndex:0]

@interface PDFGenerator : UIView
{
    CGContextRef pdfContext;
}

@property(nonatomic,retain)NSString *strHeader;

- (void) writeHeader:(CGRect) aRect;
- (void) writeFooter:(CGRect) aRect;
- (void) drawLineWithStartPoint:(CGPoint )startPoint EndPoint:(CGPoint )endPoint;
- (void) writeText:(NSString *)aText ForXpos:(CGFloat)aFloatX ForYPos:(CGFloat)aFloatY ForFont:(UIFont *)aFont ForAlignment:(NSTextAlignment)aAlignment ForSize:(CGSize)aSize ForColor:(UIColor *)aColor;
- (void) writeImage:(UIImage *)aImage ForXpos:(CGFloat)aFloatX ForYPos:(CGFloat)aFloatY ForSize:(CGSize)aSize;
- (int)NoRecordFoundWithMessage:(NSString *)strMessage YPosition:(int)YPosition RowHeight:(int)rowHeight;

@end
