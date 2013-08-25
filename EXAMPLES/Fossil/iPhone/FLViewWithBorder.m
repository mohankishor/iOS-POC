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

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
	NSSet *allTouches = [event allTouches];
	
	switch ([allTouches count])
	{
		case 1:
		{ //Single touch
			//Get the first touch.
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			switch ([touch tapCount])
			{
				case 1:
				{
				}
					break;
					
				case 2:
				{
					NSLog(@"Double Tap :%d",[touch tapCount]);
				}
					break;
		    }
		}
			break;
		case 2:
		{
			NSLog(@"Double TOUCH");
			
			//Double Touch
		} 
			break;
		default:
			break;
	}
}

- (void) dealloc
{
    [super dealloc];
}


@end
