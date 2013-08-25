//
//  PolygonFill.m
//  Quartz2DTry
//
//  Created by test on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PolygonFill.h"

@implementation PolygonFill
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
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	// Drawing with a blue fill color
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 2.0);
    
	CGPoint center;
    
	// Add a star to the current path
	center = CGPointMake(90.0, 90.0);
	CGContextMoveToPoint(context, center.x, center.y + 60.0);
	for(int i = 1; i < 5; ++i)
	{
		CGFloat x = 60.0 * sinf(i * 4.0 * M_PI / 5.0);
		CGFloat y = 60.0 * cosf(i * 4.0 * M_PI / 5.0);
		CGContextAddLineToPoint(context, center.x + x, center.y + y);
	}
	// And close the subpath.
	CGContextClosePath(context);
	
	// Now draw the star & hexagon with the current drawing mode.
	CGContextDrawPath(context, kCGPathFillStroke);
    
    center = CGPointMake(210.0, 90.0);
	CGContextMoveToPoint(context, center.x, center.y + 60.0);
	for(int i = 1; i < 6; ++i)
	{
		CGFloat x = 60.0 * sinf(i * 2.0 * M_PI / 6.0);
		CGFloat y = 60.0 * cosf(i * 2.0 * M_PI / 6.0);
		CGContextAddLineToPoint(context, center.x + x, center.y + y);
	}
	// And close the subpath.
	CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    center = CGPointMake(90.0, 200.0);
    CGContextMoveToPoint(context, center.x, center.y + 60.0);
    CGContextAddLineToPoint(context, center.x + 60, center.y);
    CGContextAddLineToPoint(context, center.x + 60, center.y + 60);
    CGContextAddLineToPoint(context, center.x, center.y+60);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
}


@end
