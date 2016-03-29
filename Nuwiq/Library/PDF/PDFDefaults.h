
/********************************************************************************\
 * Project Name :    Rainbow
 *
 * File Name    :    PDFDefaults.h
 *
 * Author       :    Mital Solanki
 *
 * Created On   :    15th May, 2014.
 *
 * Copyright (c) 2014 IndiaNIC. All rights reserved.
 *
 \********************************************************************************/

#ifndef GroupBarDemo_PDFDefaults_h
#define GroupBarDemo_PDFDefaults_h

/****************************** DEFAULT MARGIN ******************************/

#define PDFDEFAULTS_XPos                    20
#define PDFDEFAULTS_TOPMARGIN              -802
#define PDFDEFAULTS_BOTTOMMARGIN           -50
#define PDFDEFAULTS_PDF_WIDTH               612
#define PDFDEFAULTS_PDF_HEIGHT              792

/****************************** HEADER/FOOTER LINE ******************************/

#define PDFDEFAULTS_LINE_WIDTH              1.0
#define PDFDEFAULTS_LINE_START_X            12
#define PDFDEFAULTS_LINE_END_X              600

/****************************** FONT ******************************/

#define PDFDEFAULTS_TEXT_HEADER_BOLD        [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:24.0f]
#define PDFDEFAULTS_TEXT_HEADER_NORMAL      [UIFont fontWithName:@"TimesNewRomanPSMT" size:24.0f]
#define PDFDEFAULTS_TEXT_TITLE_BOLD         [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:18.0f]
#define PDFDEFAULTS_TEXT_TITLE_NORMAL       [UIFont fontWithName:@"TimesNewRomanPSMT" size:18.0f]
#define PDFDEFAULTS_TEXT_BOLD               [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:12.0f]
#define PDFDEFAULTS_TEXT_NORMAL             [UIFont fontWithName:@"TimesNewRomanPSMT" size:12.0f]

//family:'Times New Roman'
//  font:'TimesNewRomanPS-BoldItalicMT'
// 	font:'TimesNewRomanPSMT'
// 	font:'TimesNewRomanPS-BoldMT'
// 	font:'TimesNewRomanPS-ItalicMT'

/****************************** FONT COLOR ******************************/

#define FONT_RED        [UIColor redColor]
#define FONT_BLACK      [UIColor blackColor]

#endif
