//---------------------------------------------------------------------------------------
//
//	File: OpenGLAnimation.m
//
//  Abstract: Animated OpenGL scene utility kit
// 			 
//  Disclaimer: IMPORTANT:  This Apple software is supplied to you by
//  Inc. ("Apple") in consideration of your agreement to the following terms, 
//  and your use, installation, modification or redistribution of this Apple 
//  software constitutes acceptance of these terms.  If you do not agree with 
//  these terms, please do not use, install, modify or redistribute this 
//  Apple software.
//  
//  In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Apple grants you a personal, non-exclusive
//  license, under Apple's copyrights in this original Apple software (the
//  "Apple Software"), to use, reproduce, modify and redistribute the Apple
//  Software, with or without modifications, in source and/or binary forms;
//  provided that if you redistribute the Apple Software in its entirety and
//  without modifications, you must retain this notice and the following
//  text and disclaimers in all such redistributions of the Apple Software. 
//  Neither the name, trademarks, service marks or logos of Apple Inc. may 
//  be used to endorse or promote products derived from the Apple Software 
//  without specific prior written permission from Apple.  Except as 
//  expressly stated in this notice, no other rights or licenses, express
//  or implied, are granted by Apple herein, including but not limited to
//  any patent rights that may be infringed by your derivative works or by
//  other works in which the Apple Software may be incorporated.
//  
//  The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
//  MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
//  THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
//  OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//  
//  IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
//  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
//  MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
//  AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
//  STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
// 
//  Copyright (c) 2008-2009 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#import "OpenGLAnimation.h"

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------------------

@implementation OpenGLAnimation

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Initialize Timer

//---------------------------------------------------------------------------------------
//
// Update the animation
//
//---------------------------------------------------------------------------------------

- (void) animationUpdate
{
	// Change the state of the scene by updating the
	// object's rotation state
	
	[self updateRotation:referenceTime];
	
	//	Reset time in all cases
	
	referenceTime = CFAbsoluteTimeGetCurrent();
	
	// Draw the contents of the view
	
	[view drawRect:[view bounds]];
} // animationUpdate

//---------------------------------------------------------------------------------------

- (void) initAnimationTimer:(const NSTimeInterval)theTimeInterval
{	
	timer = [NSTimer timerWithTimeInterval:theTimeInterval 
									target:self 
								  selector:@selector(animationUpdate) 
								  userInfo:nil 
								   repeats:YES];
	
	
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	
	if( runLoop )
	{
		[runLoop addTimer:timer 
				  forMode:NSDefaultRunLoopMode];
		
		// Ensure timer fires during resize
		
		[runLoop addTimer:timer 
				  forMode:NSEventTrackingRunLoopMode];
	} // if
} // initAnimationTimer

//---------------------------------------------------------------------------------------

- (void) initOpenGLAnimation:(const NSTimeInterval)theTimeInterval
{
	// Initialize last frame's reference time 
	
	referenceTime = CFAbsoluteTimeGetCurrent();
	timeInterval  = theTimeInterval;
	
	// New timer for updating (animating) a 3D object
	
	[self initAnimationTimer:theTimeInterval];
} // initOpenGLAnimation

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated initializer

//---------------------------------------------------------------------------------------

- (id) initWithOpenGLView:(NSOpenGLView *)theView
			 timeInterval:(const NSTimeInterval)theTimeInterval
{
	self = [super init];
	
	if( self )
	{
		view = theView;
		
		[self initOpenGLAnimation:theTimeInterval];
	} // if
	
	return self;
} // initWithOpenGLView

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Deallocating Resources

//---------------------------------------------------------------------------------------

- (void) cleanUpAnimation
{
	if( timer )
	{
		[timer invalidate];
		[timer release];
		
		timer = nil;
	} // if
} // cleanUpAnimation

//---------------------------------------------------------------------------------------

- (void) dealloc
{
	// Release the update (animation) timer
	
	[self cleanUpAnimation];
	
	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Animation States

//---------------------------------------------------------------------------------------

- (void) animationSetTimeInterval:(const NSTimeInterval)theTimeInterval
{
	timeInterval = theTimeInterval;
} // animationSetTimeInterval

//---------------------------------------------------------------------------------------

- (void) animationEnable
{
	[self initOpenGLAnimation:timeInterval];
} // animationEnable

//---------------------------------------------------------------------------------------

- (void) animationDisable
{
	[self cleanUpAnimation];
} // animationEnable

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Rotation States

//---------------------------------------------------------------------------------------

- (void) rotationEnable
{
	[self setRotation:YES];
} // rotationEnable

//---------------------------------------------------------------------------------------

- (void) rotationDisable
{
	[self setRotation:NO];
} // rotationDisable

//---------------------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

