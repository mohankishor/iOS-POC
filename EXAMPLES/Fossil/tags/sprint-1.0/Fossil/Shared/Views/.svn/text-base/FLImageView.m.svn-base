//
//  FLImageView.m
//  Fossil
//
//  Created by Shirish Gone on 09/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLImageView.h"


@implementation FLImageView

@synthesize number = mNumber;
@synthesize delegate = mDelegate;

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
	[self performSelector:@selector(longTap) withObject:nil afterDelay:0.5];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self 
											 selector:@selector(longTap) object:nil];

	if ([mDelegate respondsToSelector:@selector(toggleBars)] && ([touches count]==1)) 
	{			
		UITouch *touch = (UITouch*)[touches anyObject];
		
		if (touch.tapCount == 1) 
		{			
			[mDelegate toggleBars];
		}
	}
	
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self 
											 selector:@selector(longTap) object:nil];
}

-(void) longTap 
{
	if([mDelegate respondsToSelector:@selector(imageTapped:)]) 
	{
		[mDelegate imageTapped:self];
	}
}


- (void)dealloc
{
    [super dealloc];
}


@end
