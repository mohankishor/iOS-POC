//
//  FLImageView.m
//  Fossil
//
//  Created by Shirish Gone on 09/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLImageView.h"
#import "FLWatchListViewController.h"

@interface FLImageView ()

@property (nonatomic, assign) NSTimer* timer;

@end

@implementation FLImageView

@synthesize number = mNumber;
@synthesize delegate = mDelegate;
@synthesize timer = mTimer;

- (id)initWithImage:(UIImage *)image
{
	self = [super initWithImage:image];
	
	if (self) 
	{
		self.userInteractionEnabled = YES;	
	}
		
	return self;
}
 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
				case 1: //Single Tap.
				{
					if ([mDelegate respondsToSelector:@selector(toggleBars)]) 
					{						
						//Start a timer for 2 seconds.
						self.timer = [NSTimer scheduledTimerWithTimeInterval:FL_IMAGE_SINGLE_TAP_DELAY
																 target:self 
															   selector:@selector(toggleBars)
															   userInfo:nil
																repeats:NO];
					}
					
					[self performSelector:@selector(longTap) withObject:nil afterDelay:FL_IMAGE_LONG_PRESS_DELAY];					
				}
					break;
				case 2:
				{
					if(self.timer)
					{
						[self.timer invalidate];
						self.timer = nil;
					}
					
					NSLog(@"Double Tap :%d",[touch tapCount]);
					if ([mDelegate respondsToSelector:@selector(zoomInOut:)])
					{
						CGPoint clickedPoint = [[touches anyObject] locationInView:self];
						[mDelegate zoomInOut:clickedPoint];
					}
				} break;
			}
		} break;
		case 2:
		{ 
			//Double Touch
			NSLog(@"Double TOUCH");
		} break;
		default:
			break;
	}

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self 
											 selector:@selector(longTap) object:nil];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(self.timer)
	{
		[self.timer invalidate];
		self.timer = nil;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self 
											 selector:@selector(longTap) object:nil];
}

- (void) longTap 
{
	if(self.timer)
	{
		[self.timer invalidate];
		self.timer = nil;
	}
		

	if([mDelegate respondsToSelector:@selector(imageTapped:)]) 
	{
		[mDelegate imageTapped:self];
	}
	else if ([mDelegate  respondsToSelector:@selector(productPage)])
	{
		[mDelegate productPage];
	}
	else if ([mDelegate  respondsToSelector:@selector(showCustomWatchAlertView)])
	{
		[mDelegate showCustomWatchAlertView];
	}
}

- (void) toggleBars
{
	self.timer = nil;
	[mDelegate toggleBars];
}

- (void)dealloc
{
    [super dealloc];
}


@end
