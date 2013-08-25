//
//  DrawFlag.m
//  Quartz2DTry
//
//  Created by test on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawFlag.h"

@implementation DrawFlag

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
    int i, j,
    num_six_star_rows = 5,
    num_five_star_rows = 4;
    CGFloat      start_x = 5.0,
    start_y = 0.0,
    red_stripe_spacing = 34.0,
    h_spacing = 26.0,
    v_spacing = 22.0;
    CGContextRef myLayerContext1,myLayerContext2;
    CGLayerRef   stripeLayer,    starLayer;
    CGRect       myBoundingBox,stripeRect,    starField;
    const CGPoint myStarPoints[] = {{ 5, 5},   {10, 15},
        {10, 15},  {15, 5},
        {15, 5},   {2.5, 11},
        {2.5, 11}, {16.5, 11},
        {16.5, 11},{5, 5}};
    
    stripeRect  = CGRectMake (0, 0, 400, 17); 
    starField  =  CGRectMake (0, 0, 160, 119);     
    myBoundingBox = CGRectMake (0, 0, 320.0, 
                                480.0);
    
    // ***** Creating layers and drawing to them *****
    stripeLayer = CGLayerCreateWithContext (context, 
                                            stripeRect.size, NULL);
    myLayerContext1 = CGLayerGetContext (stripeLayer);
    
    CGContextSetRGBFillColor (myLayerContext1, 1, 0 , 0, 1);
    CGContextFillRect (myLayerContext1, stripeRect);
    
    starLayer = CGLayerCreateWithContext (context,
                                          starField.size, NULL);
    myLayerContext2 = CGLayerGetContext (starLayer);
    CGContextSetRGBFillColor (myLayerContext2, 1.0, 1.0, 1.0, 1);
    CGContextAddLines (myLayerContext2, myStarPoints, 10);
    CGContextFillPath (myLayerContext2);    
    
    // ***** Drawing to the window graphics context *****
    CGContextSaveGState(context);    
    for (i=0; i< 7;  i++)   
    {
        CGContextDrawLayerAtPoint (context, CGPointZero, stripeLayer);
        CGContextTranslateCTM (context, 0.0, red_stripe_spacing);
    }
    CGContextRestoreGState(context);
    
    CGContextSetRGBFillColor (context, 0, 0, 0.329, 1.0);
    CGContextFillRect (context, starField);
    
    CGContextSaveGState (context);              
    CGContextTranslateCTM (context, start_x, start_y);      
    for (j=0; j< num_six_star_rows;  j++)  
    {
        for (i=0; i< 6;  i++)
        {
            CGContextDrawLayerAtPoint (context,CGPointZero,
                                       starLayer);
            CGContextTranslateCTM (context, h_spacing, 0);
        }
        CGContextTranslateCTM (context, (-i*h_spacing), v_spacing); 
    }
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, start_x + h_spacing/2, 
                           start_y + v_spacing/2);
    for (j=0; j< num_five_star_rows;  j++)  
    {
        for (i=0; i< 5;  i++)
        {
            CGContextDrawLayerAtPoint (context, CGPointZero,
                                       starLayer);
            CGContextTranslateCTM (context, h_spacing, 0);
        }
        CGContextTranslateCTM (context, (-i*h_spacing), v_spacing);
    }
    CGContextRestoreGState(context);
    
    CGLayerRelease(stripeLayer);
    CGLayerRelease(starLayer);   
}


@end
