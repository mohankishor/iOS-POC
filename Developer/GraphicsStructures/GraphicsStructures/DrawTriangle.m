//
//  DrawTriangle.m
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawTriangle.h"

@implementation DrawTriangle

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
    CGContextRef ctx = UIGraphicsGetCurrentContext();
   
    CGContextSetFillColorWithColor(ctx,[UIColor whiteColor].CGColor);
    
    CGContextSetLineWidth(ctx, 2.0);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    
    CGContextSetRGBStrokeColor(ctx, 255, 0, 255, 1);
    
    CGPoint points[6] = { CGPointMake(150,150), CGPointMake(250, 250),
        CGPointMake(250, 250), CGPointMake(50, 250),
        CGPointMake(50, 250), CGPointMake(150,150) };
    
    CGContextStrokeLineSegments(ctx, points, 6);
 }


@end
