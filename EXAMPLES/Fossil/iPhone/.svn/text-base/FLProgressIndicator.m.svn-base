//
//  FLProgressIndicator.m
//  FLTryOnWatch
//
//  Created by Sanath on 11/10/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "FLProgressIndicator.h"
#import <QuartzCore/QuartzCore.h>


@implementation FLProgressIndicator


- (id)initWithFrame:(CGRect)frame isWatchList:(BOOL)isList
{
    if ((self = [super initWithFrame:frame])) 
	{
		NSLog(@"self.frame.size.width %f",self.frame.size.width);
		NSLog(@"self.frame.size.height %f",self.frame.size.height);
		UIView *transparentLayer = [[UIView alloc] init];
        // Initialization code
		
		if (isList == YES)
		{
			[transparentLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		}
		else
		{
			[transparentLayer setFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
		}

		transparentLayer.backgroundColor = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.1 alpha:0.3];
		[self addSubview:transparentLayer];
		mSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		UIView *backgroundLayer =[[UIView alloc] init];
		
		if (FL_IS_IPAD)
		{
			[backgroundLayer setFrame:CGRectMake((self.frame.size.height/2) - 40, (self.frame.size.width/2) - 40, 80, 80)]; 
		}
		else
		{
			if (isList == YES)
			{
				[backgroundLayer setFrame:CGRectMake((self.frame.size.width/2) - 30, (self.frame.size.height/2) - 30, 60, 60)]; 

			}
			else
			{
				[backgroundLayer setFrame:CGRectMake((self.frame.size.height/2) - 30, (self.frame.size.width/2) - 30, 60, 60)]; 
			}
		}
		
		backgroundLayer.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.5 brightness:0 alpha:0.7];
		[backgroundLayer.layer setCornerRadius:10.0];
		[transparentLayer addSubview:backgroundLayer];
		[backgroundLayer release];
		
			
		[mSpinner setCenter:CGPointMake(backgroundLayer.frame.size.height/2.0, backgroundLayer.frame.size.width/2.0)]; 
		[backgroundLayer addSubview:mSpinner]; 
    }
    return self;
}

-(void) start
{
	NSLog(@"start");
    [mSpinner startAnimating];
}

-(void) stop
{
	NSLog(@"stop");
	[mSpinner stopAnimating];
}


- (void)dealloc 
{
	[mSpinner release];
    [super dealloc];
}


@end
