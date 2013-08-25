//---------------------------------------------------------------------------
//
//	File: OpenGLViewCapture.m
//
//  Abstract: Utility toolkit for recording from a view
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
//  Copyright (c) 2008-2009 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#import "OpenGLViewCapture.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation OpenGLViewCapture

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated Initializer

//---------------------------------------------------------------------------
//
// Make sure client goes through designated initializer
//
//---------------------------------------------------------------------------

- (id) initViewCaptureBaseWithSubFrame:(const NSRect *)theSubFrame
{
	[self doesNotRecognizeSelector:_cmd];
	
	return nil;
} // initViewCaptureBaseWithSubFrame

//---------------------------------------------------------------------------
//
// Initialize
//
//---------------------------------------------------------------------------

- (id) initViewCaptureWithSubFrame:(const NSRect *)theSubFrame
						 directory:(NSString *)theMovieDirectory
							prefix:(NSString *)theMoviePrefix
{
	self = [super initViewCaptureBaseWithSubFrame:theSubFrame];

	if( self )
	{	
		mediaSampleSize = NSMakeSize(theSubFrame->size.width - theSubFrame->origin.x,
									 theSubFrame->size.height - theSubFrame->origin.y);
		
		
		mediaFileDirectory  = [[NSString alloc] initWithString:theMovieDirectory];
		mediaFilePrefix     = [[NSString alloc] initWithString:theMoviePrefix];
		mediaPathname       = [DefaultPathname new];
		mediaExported       = YES;
		mediaSampleExporter = nil;
		viewCaptureState    = kOpenGLViewCaptureDefault;
	} // if
	
	return( self );
} // initViewCaptureWithSubFrame

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Dealloc all the Resources

//---------------------------------------------------------------------------
//
// Since the processing of items in the queue is async, then waite here 
// until all items are processed, before releasing the exporter object.
//
//---------------------------------------------------------------------------

- (void) exported
{
	mediaExported = [mediaSampleExporter exportEnded];
	
	while( !mediaExported )
	{
		mediaExported = [mediaSampleExporter exportEnded];
	} // while
} // exported

//---------------------------------------------------------------------------
//
// If the export was not complete (i.e., stopped properly) then process 
// remaining items in the export queue.
//
//---------------------------------------------------------------------------

- (void) finalized
{
	if( !mediaExported )
	{
		[mediaSampleExporter exportFinalize];
		
		[self exported];
	} // if
} // finalized

//---------------------------------------------------------------------------

- (void) releaseMediaPathname
{
	if( mediaPathname )
	{
		[mediaPathname release];
		
		mediaPathname = nil;
	} // if
} // releaseMediaPathname

//---------------------------------------------------------------------------

- (void) releaseMediaPrefix
{
	if( mediaFilePrefix )
	{
		[mediaFilePrefix release];
		
		mediaFilePrefix = nil;
	} // if
} // releaseMediaPrefix

//---------------------------------------------------------------------------

- (void) releaseMediaFileDirectory
{
	if( mediaFileDirectory )
	{
		[mediaFileDirectory release];
		
		mediaFileDirectory = nil;
	} // if
} // releaseMediaFileDirectory

//---------------------------------------------------------------------------

- (void) releaseMediaSampleExporter
{
	[self finalized];
	
	if( mediaSampleExporter )
	{
		[mediaSampleExporter release];
		
		mediaSampleExporter = nil;
	} // if
} // releaseMediaSampleExporter

//---------------------------------------------------------------------------

- (void) cleanUpCapture
{
	[self releaseMediaPathname];
	[self releaseMediaPrefix];
	[self releaseMediaFileDirectory];
	[self releaseMediaSampleExporter];
} // cleanUpCapture

//---------------------------------------------------------------------------

- (void) dealloc 
{
	[self cleanUpCapture];
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Utilities

//---------------------------------------------------------------------------
//
// Capture from the view with a readback from the FBO using a PBO.
//
//---------------------------------------------------------------------------

- (void) capture
{
	if( viewCaptureState == kOpenGLViewCaptureStarted )
	{
		[self captureSubFrameToBuffer:[mediaSampleExporter pixelBuffer]];
		
		[mediaSampleExporter exportAsync];
	} // if
} // capture

//---------------------------------------------------------------------------

- (void) pause
{
	if( viewCaptureState == kOpenGLViewCaptureStarted )
	{
		viewCaptureState = kOpenGLViewCapturePaused;
	} // if
	else if( viewCaptureState == kOpenGLViewCapturePaused ) 
	{
		viewCaptureState = kOpenGLViewCaptureStarted;
	} // else
} // pause

//---------------------------------------------------------------------------

- (void) startMediaSampleExporter
{
	if( mediaSampleExporter == nil )
	{
		NSString *mediaFilePathName = [mediaPathname pathnameWithDirectory:mediaFileDirectory
																	  name:mediaFilePrefix
																 extension:@"mov"];
		
		if( mediaFilePathName )
		{
			mediaSampleExporter = [[QTMediaSampleExporter alloc] initMediaSampleExporterWithMoviePath:mediaFilePathName 
																							frameSize:&mediaSampleSize
																						 framesPerSec:30];
			
			[mediaFilePathName release];
		} // if
	} // if
} // startMediaSampleExporter

//---------------------------------------------------------------------------

- (void) start
{
	[self releaseMediaSampleExporter];
	[self startMediaSampleExporter];
	
	viewCaptureState = kOpenGLViewCaptureStarted;
	mediaExported    = NO;
} // start

//---------------------------------------------------------------------------

- (void) stop
{
	[mediaSampleExporter exportFinalize];
	
	mediaExported    = YES;
	viewCaptureState = kOpenGLViewCaptureStopped;
} // stop

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Level Indicators

//---------------------------------------------------------------------------

- (void) enableIndicator
{
	[mediaSampleExporter enableIndicator];
} // enableIndicator

//---------------------------------------------------------------------------

- (void) disableIndicator
{
	[mediaSampleExporter disableIndicator];
} // disableIndicator

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Getters

//---------------------------------------------------------------------------

- (NSUInteger) count
{
	return( [mediaSampleExporter count] );
} // count

//---------------------------------------------------------------------------

- (BOOL) isSuspended
{
	return( [mediaSampleExporter isSuspended] );
} // isSuspended

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Setters

//---------------------------------------------------------------------------

- (void) setMoviePrefix:(NSString *)theMoviePrefix
{
	[mediaFilePrefix release];
	[theMoviePrefix retain];
	
	mediaFilePrefix = theMoviePrefix;
} // setMoviePrefix

//---------------------------------------------------------------------------

- (void) setMovieDirectory:(NSString *)theMovieDirectory
{
	[mediaFileDirectory release];
	[theMovieDirectory retain];
	
	mediaFileDirectory = theMovieDirectory;
} // setMediaFileDirectory

//---------------------------------------------------------------------------

- (void) setBounds:(const NSRect *)theBounds
{
	if(		( theBounds->size.width  != mediaSampleSize.width  )
	   ||	( theBounds->size.height != mediaSampleSize.height ) )
	{
		mediaSampleSize = NSMakeSize(theBounds->size.width - theBounds->origin.x,
									 theBounds->size.height - theBounds->origin.y);
		
		if( !mediaExported )
		{
			[self stop];
		} // if
		
		[super setBounds:theBounds];
	} // if
} // setBounds

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
