//
//  DrawCircle.m
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawCircle.h"

@implementation DrawCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
   
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextDrawPath(context, kCGPathFillStroke);    
}

@end
