//
//  PDFRenderer.h
//  Quartz2DTry
//
//  Created by test on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CoreText.h"

@interface PDFRenderer : NSObject

-(void)drawPDF:(NSString*)fileName;

-(void)drawLabels;

-(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;

-(void)drawLogo;

-(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

-(void)drawTableAt:(CGPoint)origin 
     withRowHeight:(int)rowHeight 
    andColumnWidth:(int)columnWidth 
       andRowCount:(int)numberOfRows 
    andColumnCount:(int)numberOfColumns;


-(void)drawTableDataAt:(CGPoint)origin 
         withRowHeight:(int)rowHeight 
        andColumnWidth:(int)columnWidth 
           andRowCount:(int)numberOfRows 
        andColumnCount:(int)numberOfColumns;

-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
@end
