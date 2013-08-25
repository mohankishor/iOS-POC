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
	//TODO:remove all non used functionality in image view
@synthesize number = mNumber;
@synthesize delegate = mDelegate;
@synthesize timer = mTimer;

- (id) initWithImage:(UIImage *) image
{
	self = [super initWithImage:image];
	
	if (self) 
	{
		self.userInteractionEnabled = YES;	
	}
		
	return self;
}
 
- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{

	NSSet *allTouches = [event allTouches];
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		if([touch tapCount]==1)
		{
			if ([mDelegate respondsToSelector:@selector(toggleBars)])
			{		
				[self performSelector:@selector(toggleBars)];
    		}
		}
}
					
- (void) toggleBars
{
	[mDelegate toggleBars];
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
