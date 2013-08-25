//
//  FLViewWithBorder.m
//  Fossil
//
//  Created by Ganesh Nayak on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLViewWithBorder.h"


@implementation FLViewWithBorder


- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect) rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetLineWidth(context, 5.0);
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);


	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

	CGContextFillRect(context, rect);
	
	CGContextStrokeRect(context, rect);

}














//    CGFloat radius = 30.0;
//    CGFloat width = CGRectGetWidth(rrect);
//    CGFloat height = CGRectGetHeight(rrect);

//    // Make sure corner radius isn't larger than half the shorter side
//    if (radius > width/2.0)
//        radius = width/2.0;
//    if (radius > height/2.0)
//        radius = height/2.0;    
//	
//    CGFloat minx = CGRectGetMinX(rrect);
//    CGFloat midx = CGRectGetMidX(rrect);
//    CGFloat maxx = CGRectGetMaxX(rrect);
//    CGFloat miny = CGRectGetMinY(rrect);
//    CGFloat midy = CGRectGetMidY(rrect);
//    CGFloat maxy = CGRectGetMaxY(rrect);
//    CGContextMoveToPoint(context, minx, midy);
//    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
//    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
//    CGContextClosePath(context);
- (void) dealloc
{
    [super dealloc];
}


@end
