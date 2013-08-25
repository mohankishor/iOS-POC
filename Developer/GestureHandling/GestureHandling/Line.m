//
//  Line.m
//  GestureHandling
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Line.h"

@implementation Line
@synthesize currentX = _currentX,currentY = _currentY,previousX = _previousX,previousY = _previousY;
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
    NSLog(@"Entered Drawrect");
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //get the graphics context
    CGContextSetRGBStrokeColor(ctx, 1.0, 0, 0, 1); //there are two relevant color states, "Stroke" -- used in Stroke drawing functions and "Fill" - used in fill drawing functions
    //now we build a "path"
    // you can either directly build it on the context or build a path object, here I build it on the context
    CGContextMoveToPoint(ctx, _previousX,_previousY);
    //add a line from 0,0 to the point 100,100
    CGContextAddLineToPoint( ctx, _currentX,_currentY);
    //"stroke" the path
    CGContextStrokePath(ctx);

}


@end
