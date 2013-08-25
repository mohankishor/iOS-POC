//---------------------------------------------------------------------------
//
//	File: NSBezierPath+RoundRect.m
//
//  Abstract: NSBezierPath category to allow for rounded corners of 
//            the border
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
//  Copyright (c) 2007-2008 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#import "NSBezierPath+RoundRect.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation NSBezierPath( RoundRect )

//---------------------------------------------------------------------------

- (void) appendBezierPathWithRoundedRect:(NSRect)theRect 
							cornerRadius:(CGFloat)theRadius 
{
    if( !NSIsEmptyRect(theRect) ) 
	{
		if( theRadius > 0.0f ) 
		{
			CGFloat width  = NSWidth(theRect);
			CGFloat height = NSHeight(theRect);
			CGFloat length = 0.5f * MIN(width, height);
			
			// Clamp radius to be no larger than half the 
			// rectangles's width or height.
			
			CGFloat clampedRadius = MIN(theRadius, length);
			
			CGFloat minX = NSMinX(theRect);
			CGFloat midX = NSMidX(theRect);
			CGFloat maxX = NSMaxX(theRect);
			CGFloat minY = NSMinY(theRect);
			CGFloat maxY = NSMaxY(theRect);
			
			NSPoint origin      = theRect.origin;
			NSPoint coordinate  = NSMakePoint(midX, maxY);
			NSPoint topLeft     = NSMakePoint(minX, maxY);
			NSPoint topRight    = NSMakePoint(maxX, maxY);
			NSPoint bottomRight = NSMakePoint(maxX, minY);
			
			[self moveToPoint:coordinate];
			
			[self appendBezierPathWithArcFromPoint:topLeft
										   toPoint:origin 
											radius:clampedRadius];
			
			[self appendBezierPathWithArcFromPoint:origin 
										   toPoint:bottomRight 
											radius:clampedRadius];
			
			[self appendBezierPathWithArcFromPoint:bottomRight
										   toPoint:topRight
											radius:clampedRadius];
			
			[self appendBezierPathWithArcFromPoint:topRight
										   toPoint:topLeft
											radius:clampedRadius];
			[self closePath];
		} // if
		else 
		{
			// When radius == 0.0, this degenerates to the 
			// simple case of a plain rectangle.
			
			[self appendBezierPathWithRect:theRect];
		} // else
    } // if
} // appendBezierPathWithRoundedRect

//---------------------------------------------------------------------------

+ (NSBezierPath *) bezierPathWithRoundedRect:(NSRect)theRect 
							    cornerRadius:(CGFloat)theRadius 
{
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
	
    [bezierPath appendBezierPathWithRoundedRect:theRect 
								   cornerRadius:theRadius];
	
    return bezierPath;
} // bezierPathWithRoundedRect

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
