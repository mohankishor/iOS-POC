//
//  DrawRectangle.m
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawRectangle.h"

@implementation DrawRectangle
@synthesize length = _length,width = _width;
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
    
    CGContextMoveToPoint(context,0.0, 0.0);
    
    CGContextAddLineToPoint(context, _length, 0.0);
    
    CGContextAddLineToPoint(context, _length, _width);
    
    CGContextAddLineToPoint(context, 0.0, _width);
    
    CGContextAddLineToPoint(context, 0.0, 0.0);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
}

@end
