//
//  CustomAlertView.m
//  TryOnWatch
//
//  Created by Sanath on 27/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "CustomAlertView.h"


@interface CustomAlertView (Private)
- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef) context withRadius:(CGFloat) radius;
@end

static UIColor *fillColor = nil;
static UIColor *borderColor = nil;

@implementation CustomAlertView
@synthesize delegate = mDelegate;

- (void) setBackgroundColor:(UIColor *) background withStrokeColor:(UIColor*) stroke
{
	if(fillColor != nil)
	{
		[fillColor release];
		[borderColor release];
	}
	
	fillColor = [background retain];
	borderColor = [stroke retain];
}

- (void) addButtonWithTitle:(NSString *)title withFrame:(CGRect) theRect andWithButtonIndex:(NSInteger) buttonIndex
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 	[button setFrame:theRect];
	[button setTag:buttonIndex];
	[button setBackgroundColor:[UIColor blackColor]];
	[button setTitle:title forState:UIControlStateNormal] ;
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	if(button.tag==1)
	{
		[button addTarget:self.delegate action:@selector(savePhotos:) forControlEvents:UIControlStateHighlighted];
	}
	else
	{
		[button addTarget:self.delegate action:@selector(cancelPhotos:) forControlEvents:UIControlStateHighlighted];		
	}
	[self addSubview:button];
}



- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		NSLog(@"initWithFrame");
		
		if(fillColor == nil)
		{
			fillColor = [[UIColor clearColor] retain];
			borderColor = [[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8] retain];
		}
    }
    return self;
}


- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context withRadius:(CGFloat) radius
{
	CGContextBeginPath (context);
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	NSLog(@"drawRect");
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextClearRect(context, rect);
	//CGContextSetAllowsAntialiasing(context, true);
	//CGContextSetLineWidth(context, 0.0);
	CGContextSetAlpha(context, 0.8); 
	CGContextSetLineWidth(context, 3.0);
	CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);
	
	// Draw background
	CGFloat backOffset = 2;
	CGRect backRect = CGRectMake(rect.origin.x + backOffset, rect.origin.y + backOffset, rect.size.width - backOffset*4, rect.size.height - backOffset*2);
	[self drawRoundedRect:backRect inContext:context withRadius:8];
	CGContextDrawPath(context, kCGPathFillStroke);
	
	// Clip Context
	CGRect clipRect = CGRectMake(backRect.origin.x + backOffset-1, backRect.origin.y + backOffset-1, backRect.size.width - (backOffset-1)*2, backRect.size.height - (backOffset-1)*2);
	[self drawRoundedRect:clipRect inContext:context withRadius:8];
	CGContextClip (context);
	
	//Draw highlight
	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35, 1.0, 1.0, 1.0, 0.06 };
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
	CGRect ovalRect = CGRectMake(-130, -115, (rect.size.width*2), rect.size.width/2);
	
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.size.height/5);
	
	CGContextSetAlpha(context, 1.0); 
	CGContextAddEllipseInRect(context, ovalRect);
	CGContextClip (context);
	
	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
	
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace); 
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	NSLog(@"dismissed");
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		NSLog(@".....................................   ......");
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
