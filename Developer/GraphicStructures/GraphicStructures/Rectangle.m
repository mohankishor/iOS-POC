//
//  Rectangle.m
//  GraphicStructures
//
//  Created by test on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle
@synthesize length = _length;
@synthesize width = _width;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id) initWithLength:(CGFloat)length width:(CGFloat)width
{
    self = [super init];
    if (self) {
        _length = length;
        _width = width;
    }
    return self;
}
- (void) drawRect:(CGRect) rect
{   
    NSLog(@"%f",_length);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGContextMoveToPoint(context, _length, _length);
    CGContextAddLineToPoint(context, _width, _length);
    CGContextAddLineToPoint(context, _width, _width);
    CGContextAddLineToPoint(context, _length, _width);
    CGContextAddLineToPoint(context, _length, _length);
    
    CGContextStrokePath(context);
}


@end
