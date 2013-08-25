//
//  DrawSquare.m
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawSquare.h"

@implementation DrawSquare
@synthesize length = _length;
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
    
    CGContextMoveToPoint(ctx,0.0, 0.0);
    
    CGContextAddLineToPoint(ctx, _length, 0.0);
    
    CGContextAddLineToPoint(ctx, _length, _length);
    
    CGContextAddLineToPoint(ctx, 0.0, _length);
    
    CGContextAddLineToPoint(ctx, 0.0, 0.0);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);

}


@end
