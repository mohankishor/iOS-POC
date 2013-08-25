//---------------------------------------------------------------------------
//
//	File: QTMediaSampleExporter.m
//
//  Abstract: Utility toolkit for exporting a smaple to a QT movie
// 			 
//  Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
//  Computer, Inc. ("Apple") in consideration of your agreement to the
//  following terms, and your use, installation, modification or
//  redistribution of this Apple software constitutes acceptance of these
//  terms.  If you do not agree with these terms, please do not use,
//  install, modify or redistribute this Apple software.
//  
//  In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Apple grants you a personal, non-exclusive
//  license, under Apple's copyrights in this original Apple software (the
//  "Apple Software"), to use, reproduce, modify and redistribute the Apple
//  Software, with or without modifications, in source and/or binary forms;
//  provided that if you redistribute the Apple Software in its entirety and
//  without modifications, you must retain this notice and the following
//  text and disclaimers in all such redistributions of the Apple Software. 
//  Neither the name, trademarks, service marks or logos of Apple Computer,
//  Inc. may be used to endorse or promote products derived from the Apple
//  Software without specific prior written permission from Apple.  Except
//  as expressly stated in this notice, no other rights or licenses, express
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
//  Copyright (c) 2009 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#import "QTMediaSampleNotifications.h"
#import "QTMediaSampleExporter.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@interface QTMediaSampleExporter( PrivateMethods )

- (void) progressSync;
- (void) closeSync;

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@implementation  QTMediaSampleExporter( PrivateMethods )

//---------------------------------------------------------------------------

- (void) progressSync
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];

	[NSThread setThreadPriority:0.5];
		
	NSInteger maxItems = [mediaSampleAuthor count];
	
	if( maxItems > 5 )
	{
		NSRect      contentRect = NSMakeRect(0.0f, 0.0f, 400.0f, 50.0f);
		NSUInteger  styleMask   = NSTitledWindowMask | NSTexturedBackgroundWindowMask;
		
		NSProgressIndicator *progressIndicator = nil;
		
		NSPanel *progressIndicatorPanel = [[NSPanel alloc] initWithContentRect:contentRect 
																	 styleMask:styleMask 
																	   backing:NSBackingStoreBuffered 
																		 defer:NO];
		
		if( progressIndicatorPanel )
		{
			[progressIndicatorPanel setFloatingPanel:YES];
			[progressIndicatorPanel setHidesOnDeactivate:YES];
			[progressIndicatorPanel setExcludedFromWindowsMenu:YES];
			[progressIndicatorPanel setMenu:nil];
			[progressIndicatorPanel center];
			[progressIndicatorPanel setTitle:@"Authoring a Movie..."];
			[progressIndicatorPanel setReleasedWhenClosed:YES];
			
			NSView *contentView = [progressIndicatorPanel contentView];
			
			if( contentView )
			{
				NSRect contentFrame = [contentView frame];
				
				contentFrame.origin.x = 10.0;
				contentFrame.origin.y = 15.0;
				
				contentFrame.size.width  -= 20.0;
				contentFrame.size.height -= 30.0;
				
				progressIndicator = [[NSProgressIndicator alloc] initWithFrame:contentFrame];
				
				if( progressIndicator )
				{
					[progressIndicator setHidden:NO];
					[progressIndicator setMaxValue:(double)(maxItems-1)];
					[progressIndicator setMinValue:0.0];
					[progressIndicator setIndeterminate:NO];
					[progressIndicator setStyle:NSProgressIndicatorBarStyle];
					[progressIndicator sizeToFit];
					
					[contentView addSubview:progressIndicator];
					
					[progressIndicatorPanel makeKeyAndOrderFront:nil];
					
					double    currentValue  = 0.0;
					double    previousValue = currentValue;
					NSInteger currentItem   = maxItems;
					
					while( currentItem )
					{
						currentValue = (double)(maxItems - currentItem);
						
						if( currentValue != previousValue )
						{
							[progressIndicator setDoubleValue:currentValue];
							
							previousValue = currentValue;
						} // if
						
						currentItem = [mediaSampleAuthor count];
					} // while
					
					[progressIndicator setHidden:YES];
				} // if
			} // if
			
			CGFloat alpha      = [progressIndicatorPanel alphaValue];
			CGFloat alphaDelta = 0.0000175f;
			
			while( alpha > 0.0f )
			{
				[progressIndicatorPanel setAlphaValue:alpha];
				
				alpha -= alphaDelta;
			} // while
			
			[progressIndicator release];
			[progressIndicatorPanel close];
		} // if
	} // if
	
	[pool drain];
} // progressSync

//---------------------------------------------------------------------------

- (void) closeSync
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	[NSThread setThreadPriority:1.0];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:QTMediaSampleAuthorIsFinalized 
														object:self];
	
	if( [mediaSampleAuthor close] )
	{
		if( [self addReferences:[mediaSampleAuthor samples]] )
		{
			mediaEditEnded = [self editsFinalize];
		} // if
	} // if
	
	[pool drain];
} // closeSync

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@implementation QTMediaSampleExporter

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Utilities

//---------------------------------------------------------------------------
//
// Make sure client goes through designated initializer
//
//---------------------------------------------------------------------------

- (id) initMediaSampleEditorWithMoviePath:(NSString *)theMoviePath
								frameSize:(const NSSize *)theSize
							 framesPerSec:(const TimeValue)theFPS
{
	[self doesNotRecognizeSelector:_cmd];
	
	return( nil );
} // initMediaSampleEditorWithMoviePath

//---------------------------------------------------------------------------
//
// Initialize a frame compressor object with the specified codec,
// bounds, compressor options and timescale
//
//---------------------------------------------------------------------------

- (id) initMediaSampleExporterWithMoviePath:(NSString *)theMoviePath
								  frameSize:(const NSSize *)theSize
							   framesPerSec:(const TimeValue)theFPS
{	
	self = [super initMediaSampleEditorWithMoviePath:theMoviePath
										   frameSize:theSize
										framesPerSec:theFPS];
	
	if( self )
	{
		mediaSample = [[QTMediaSample alloc] initMediaSampleWithSize:theSize];
				
		mediaSampleAuthor = [[QTMediaSampleAuthor alloc] initMediaSampleAuthorWithPathName:theMoviePath
																		   mediaSampleSize:theSize];
		
		mediaSampleFinalizeThread = [[NSThread alloc] initWithTarget:self
															selector:@selector(closeSync)
															  object:nil];
		
		mediaSampleUIThread = [[NSThread alloc] initWithTarget:self
													  selector:@selector(progressSync)
														object:nil];
		
		mediaSampleSize      = *theSize;
		mediaEditEnded       = NO;
		mediaSamplePIDisplay = NO;
	} // if
	
	return( self );
} // initMediaSampleExporterWithMoviePath

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Dealloc

//---------------------------------------------------------------------------

- (void) releaseMediaSampleUIThread
{
	while( [mediaSampleUIThread isExecuting] )
	{
		;
	} // while
	
	if( mediaSampleUIThread )
	{
		[mediaSampleUIThread release];
		
		mediaSampleUIThread = nil;
	} // if
} // releaseMediaSampleUIThread

//---------------------------------------------------------------------------

- (void) releaseMediaSampleFinalizeThread
{
	while( [mediaSampleFinalizeThread isExecuting] )
	{
		;
	} // while
	
	if( mediaSampleFinalizeThread )
	{
		[mediaSampleFinalizeThread release];
		
		mediaSampleFinalizeThread = nil;
	} // if
} // releaseMediaSampleFinalizeThread

//---------------------------------------------------------------------------

- (void) releaseMediaSample
{
	if( mediaSample )
	{
		[mediaSample release];
		
		mediaSample = nil;
	} // if
} // releaseMediaSample

//---------------------------------------------------------------------------

- (void) releaseMediaSampleAuthor
{
	if( mediaSampleAuthor )
	{
		[mediaSampleAuthor release];
		
		mediaSampleAuthor = nil;
	} // if
} // releaseMediaSampleAuthor

//---------------------------------------------------------------------------

- (void) cleanUpExporter
{
	[self releaseMediaSampleUIThread];
	[self releaseMediaSampleFinalizeThread];
	[self releaseMediaSampleAuthor];
	[self releaseMediaSample];
} // cleanUpExporter

//---------------------------------------------------------------------------

- (void) dealloc
{
	[self cleanUpExporter];
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Accessors

//---------------------------------------------------------------------------

- (void) enableIndicator
{
	mediaSamplePIDisplay = YES;
} // enableIndicator

//---------------------------------------------------------------------------

- (void) disableIndicator
{
	mediaSamplePIDisplay = NO;
} // disableIndicator

//---------------------------------------------------------------------------

- (BOOL) isSuspended
{
	return( [mediaSampleAuthor isSuspended]  );
} // isSuspended

//---------------------------------------------------------------------------

- (NSUInteger) count
{
	return( [mediaSampleAuthor count] );
} // count

//---------------------------------------------------------------------------

- (GLvoid *) pixelBuffer
{
	return( [mediaSample buffer] );
} // pixelBuffer

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Utilities

//---------------------------------------------------------------------------

- (void) exportAsync
{
	[mediaSampleAuthor writeAsync:mediaSample];
	
	[mediaSample updateTimeStamp];
	[mediaSample updateIndex];
} // exportAsync

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

- (void) exportFinalize
{
	[mediaSampleFinalizeThread start];
		
	if( mediaSamplePIDisplay )
	{
		[mediaSampleUIThread start];
	} // if
} // exportFinalize

//---------------------------------------------------------------------------

- (BOOL) exportEnded
{
	return( mediaEditEnded );
} // exportEnded

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
