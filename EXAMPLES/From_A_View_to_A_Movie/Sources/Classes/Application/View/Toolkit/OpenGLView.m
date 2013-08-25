//---------------------------------------------------------------------------------------
//
//	File: OpenGLView.m
//
//  Abstract: OpenGL view class with text labels and added utility methods
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

#import "QTMediaSampleNotifications.h"

#import "OpenGLView.h"

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

enum OpenGLViewFlags
{
	kOpenGLViewResized = 0,
	kOpenGLViewStopObjectRotation,
	kOpenGLViewCaptureEnabled,
	kOpenGLViewDisplayCounter,
	kOpenGLViewDisplayPrefTimer,
	kOpenGLViewDisplayRenderer,
	kOpenGLViewDisplayBounds
};

typedef enum OpenGLViewFlags OpenGLViewFlags;

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------------------

@implementation OpenGLView

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Post Notification

//---------------------------------------------------------------------------------------

- (void) postOpenGLViewNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(viewWillTerminate:)
												 name:@"NSApplicationWillTerminateNotification"
											   object:NSApp];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(suspendObjectRotation:)
												 name:QTMediaSampleAuthorIsSuspended
											   object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resumeObjectRotation:)
												 name:QTMediaSampleAuthorIsResumed
											   object:nil];
} // postOpenGLViewNotifications

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Labels Initialization

//---------------------------------------------------------------------------------------

- (void) initPrefTimerLabel:(const NSRect *)theBounds
				  textColor:(NSColor *)theTextColor 
				   boxColor:(NSColor *)theBoxColor 
				borderColor:(NSColor *)theBorderColor 
{
	NSPoint prefTimerInfoCoordinates = NSMakePoint(10.0f, 32.0f);
	
	prefTimerLabel = [[OpenGLPrefTimerLabel alloc] initLabelWithFormat:nil 
															  fontName:@"Helvetica" 
															  fontSize:20.0f 
															 textColor:theTextColor 
															  boxColor:theBoxColor 
														   borderColor:theBorderColor
														   coordinates:&prefTimerInfoCoordinates 
																bounds:theBounds];
} // initPrefTimerLabel

//---------------------------------------------------------------------------------------

- (void) initRendererLabel:(const NSRect *)theBounds
				 textColor:(NSColor *)theTextColor 
				  boxColor:(NSColor *)theBoxColor 
			   borderColor:(NSColor *)theBorderColor 
{
	NSRect bounds = [self bounds];
	
	NSPoint infoCoordinates = NSMakePoint(10.0f, bounds.size.height - 52.0f);
	
	rendererLabel = [[OpenGLRendererLabel alloc] initLabelWithFontName:@"Helvetica" 
															  fontSize:12.0 
															 textColor:theTextColor 
															  boxColor:theBoxColor 
														   borderColor:theBorderColor
														   coordinates:&infoCoordinates
																bounds:theBounds];
} // initRendererLabel

//---------------------------------------------------------------------------------------

- (void) initViewBoundsLabel:(const NSRect *)theBounds
				   textColor:(NSColor *)theTextColor 
					boxColor:(NSColor *)theBoxColor 
				 borderColor:(NSColor *)theBorderColor 
{
	NSPoint infoCoordinates = NSMakePoint(10.0f, 10.0f);

	viewBoundsLabel = [[OpenGLViewBoundsLabel alloc] initLabelWithFormat:nil
																fontName:@"Helvetica" 
																fontSize:12.0 
															   textColor:theTextColor 
																boxColor:theBoxColor 
															 borderColor:theBorderColor
															 coordinates:&infoCoordinates
																  bounds:theBounds];
} // initViewBoundsLabel

//---------------------------------------------------------------------------------------

- (void) initLabels:(const NSRect *)theBounds
{
	NSColor *textColor = [NSColor colorWithDeviceRed:1.0f 
											   green:1.0f 
												blue:1.0f 
											   alpha:1.0f];
	
	NSColor *boxColor = [NSColor colorWithDeviceRed:0.5f 
											  green:0.5f 
											   blue:0.5f 
											  alpha:0.5f];
	
	NSColor *borderColor = [NSColor colorWithDeviceRed:0.8f 
												 green:0.8f 
												  blue:0.8f 
												 alpha:0.8f];

	[self initPrefTimerLabel:theBounds
				   textColor:textColor 
					boxColor:boxColor 
				 borderColor:borderColor];	

	[self initRendererLabel:theBounds
				  textColor:textColor 
				   boxColor:boxColor 
				borderColor:borderColor];	
	
	[self initViewBoundsLabel:theBounds
					textColor:textColor 
					 boxColor:boxColor 
				  borderColor:borderColor];	
} // initLabels

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated initializer

//---------------------------------------------------------------------------------------
//
// Create an OpenGL Context to use - i.e. init the animated view superclass
//
//---------------------------------------------------------------------------------------

- (id) initWithFrame:(NSRect)theFrame 
		 pixelFormat:(NSOpenGLPixelFormat *)thePixelFormat
{
	self = [super initWithFrame:theFrame 
					pixelFormat:thePixelFormat];
	
	if( self )
	{
		// Instantiate label objects for displaying 
		// performance timer and view bounds
		
		[self initLabels:&theFrame];

		viewSnapshot = nil;
		viewCapture  = nil;
		
		movieDirectoryPathname = nil;
		
		viewFlags[kOpenGLViewResized]            = NO;
		viewFlags[kOpenGLViewStopObjectRotation] = NO;
		viewFlags[kOpenGLViewCaptureEnabled]     = NO;
	
		viewFlags[kOpenGLViewDisplayPrefTimer] = YES;
		viewFlags[kOpenGLViewDisplayRenderer]  = YES;
		viewFlags[kOpenGLViewDisplayBounds]    = YES;
		
		[self postOpenGLViewNotifications];
	} // if
	
	return( self );
} // initWithFrame

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Deallocating Resources

//---------------------------------------------------------------------------------------

- (void) releaseOpenGLViewCapture
{
	if( viewCapture )
	{
		[viewCapture release];
		
		viewCapture = nil;
	} // if
} // releaseOpenGLViewCapture

//---------------------------------------------------------------------------------------

- (void) releaseOpenGLViewSnapshot
{
	if( viewSnapshot )
	{
		[viewSnapshot release];
		
		viewSnapshot = nil;
	} // if
} // releaseOpenGLViewSnapshot

//---------------------------------------------------------------------------------------

- (void) releaseOpenGLPrefTimerLabel
{
	if( prefTimerLabel )
	{
		[prefTimerLabel release];
		
		prefTimerLabel = nil;
	} // if
} // releaseOpenGLPrefTimerLabel

//---------------------------------------------------------------------------------------

- (void) releaseOpenGLRendererLabel
{
	if( rendererLabel )
	{
		[rendererLabel release];
		
		rendererLabel = nil;
	} // if
} // releaseOpenGLRendererLabel

//---------------------------------------------------------------------------------------

- (void) releaseOpenGLViewBoundsLabel
{
	if( viewBoundsLabel )
	{
		[viewBoundsLabel release];
		
		viewBoundsLabel = nil;
	} // if
} // releaseOpenGLViewBoundsLabel

//---------------------------------------------------------------------------------------

- (void) releaseMovieDirectoryPathname
{
	if( movieDirectoryPathname )
	{
		[movieDirectoryPathname release];
		
		movieDirectoryPathname = nil;
	} // if
} // releaseMovieDirectoryPathname

//---------------------------------------------------------------------------------------

- (void) cleanUpOpenGLView
{	
	// Release the renderer's label
	
	[self releaseOpenGLRendererLabel];
	
	// Release the view bounds' label
	
	[self releaseOpenGLViewBoundsLabel];
	
	// Release perf timer's label
	
	[self releaseOpenGLPrefTimerLabel];
	
	// Release the view snapshot object
	
	[self releaseOpenGLViewSnapshot];
	
	// Release the view capture object
	
	[self releaseOpenGLViewCapture];

	// Release the directory pathname string
	
	[self releaseMovieDirectoryPathname];
} // cleanUpOpenGLView

//---------------------------------------------------------------------------------------

- (void) dealloc
{
	[self cleanUpOpenGLView];
	
	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Accessor

//---------------------------------------------------------------------------------------

- (BOOL) viewResized
{
	return( viewFlags[kOpenGLViewResized] );
} // viewResized

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Capturing from a View

//---------------------------------------------------------------------------------------

- (void) viewCaptureCreate
{
	if( viewCapture == nil )
	{
		NSRect bounds = [self bounds];
		
		viewCapture = [[OpenGLViewCapture alloc] initViewCaptureWithSubFrame:&bounds
																   directory:movieDirectoryPathname 
																	  prefix:@"capture"];
	} // if
	else 
	{
		[viewCapture setMovieDirectory:movieDirectoryPathname];
	} // else

	if( viewCapture )
	{
		viewFlags[kOpenGLViewCaptureEnabled] = YES;
	} // if
} // viewCaptureCreate

//---------------------------------------------------------------------------------------

- (void) viewCaptureEnable:(NSString *)theMovieDirectory
{
	if( theMovieDirectory )
	{
		[self releaseMovieDirectoryPathname];
		
		if( movieDirectoryPathname == nil )
		{
			movieDirectoryPathname = [[NSString alloc] initWithString:theMovieDirectory];
		} // if
		
		[self viewCaptureCreate];
	} // if
} // viewCaptureEnable

//---------------------------------------------------------------------------------------

- (void) viewCaptureSetDirectory:(NSString *)theMovieDirectory
{
	[viewCapture setMovieDirectory:theMovieDirectory];
} // viewCaptureSetDirectory

//---------------------------------------------------------------------------------------

- (void) viewCaptureDisable
{	
	[self releaseOpenGLViewCapture];
	
	if( viewCapture == nil )
	{
		viewFlags[kOpenGLViewCaptureEnabled] = NO;
	} // if
} // viewCaptureDisable

//---------------------------------------------------------------------------------------

- (void) viewCaptureStart
{
	viewFlags[kOpenGLViewStopObjectRotation] = NO;
	
	[viewCapture start];
} // viewCaptureRestart

//---------------------------------------------------------------------------------------

- (void) viewCaptureStop
{
	viewFlags[kOpenGLViewStopObjectRotation] = YES;
	
	[viewCapture stop];
} // viewCaptureStop

//---------------------------------------------------------------------------------------

- (void) viewCapturePause
{
	[viewCapture pause];
} // viewCapturePause

//---------------------------------------------------------------------------------------

- (NSUInteger) viewCaptureCount
{
	return( [viewCapture count] );
} // viewCaptureCount

//---------------------------------------------------------------------------------------

- (BOOL) viewCaptureIsSuspended
{
	return( [viewCapture isSuspended] );
} // viewCaptureIsSuspended

//---------------------------------------------------------------------------------------

- (void) viewCaptureEnableColorCorrection
{
	[viewCapture enableColorCorrection];
} // viewCaptureEnableColorCorrection

//---------------------------------------------------------------------------------------

- (void) viewCaptureDisableColorCorrection
{
	[viewCapture disableColorCorrection];
} // viewCaptureDisableColorCorrection

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Capturing from a View

//---------------------------------------------------------------------------------------

- (void) viewSnapshot:(NSString *)theDocPath
				 type:(NSNumber *)theDocFormat
		  compression:(NSNumber *)theDocCompression
				title:(NSString *)theDocTitle
			   author:(NSString *)theDocAuthor
			  subject:(NSString *)theDocSubject
			  creator:(NSString *)theDocCreator
{
	if( viewSnapshot == nil )
	{
		NSRect frame = [self bounds];
		
		viewSnapshot = [[OpenGLViewSnapshot alloc] initViewSnapshotWithSubFrame:&frame 
																		   view:self];
	} // if
	
	[viewSnapshot snapshotSetDocumentTitle:theDocTitle];
	[viewSnapshot snapshotSetDocumentAuthor:theDocAuthor];
	[viewSnapshot snapshotSetDocumentSubject:theDocSubject];
	[viewSnapshot snapshotSetDocumentCreator:theDocCreator];

	if( theDocFormat )
	{
		[viewSnapshot snapshotSetFormat:[theDocFormat unsignedIntValue]];
	} // if
	
	if( theDocCompression )
	{
		[viewSnapshot snapshotSetCompression:[theDocCompression floatValue]];
	} // if
	
	[viewSnapshot snapshotSaveAs:theDocPath];
} // viewSnapshot

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Showing/Hiding Labels

//---------------------------------------------------------------------------------------

- (void) prefTimerDisplayLabel:(const BOOL)theDisplayFlag
{
	viewFlags[kOpenGLViewDisplayPrefTimer] = theDisplayFlag;
} // prefTimerLabelSetDisplay

//---------------------------------------------------------------------------------------

- (void) rendererDisplayLabel:(const BOOL)theDisplayFlag
{
	viewFlags[kOpenGLViewDisplayRenderer] = theDisplayFlag;
} // rendererLabelSetDisplay

//---------------------------------------------------------------------------------------

- (void) viewBoundsDisplayLabel:(const BOOL)theDisplayFlag
{
	viewFlags[kOpenGLViewDisplayBounds] = theDisplayFlag;
} // viewBoundsSetDisplay

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Preformance Timer Utilities

//---------------------------------------------------------------------------------------

- (void) prefTimerEnable
{
	[prefTimerLabel labelSetNeedsDisplay:YES];
} // prefTimerEnable

//---------------------------------------------------------------------------------------

- (void) prefTimerDisable
{
	[prefTimerLabel labelSetNeedsDisplay:NO];
} // prefTimerDisable

//---------------------------------------------------------------------------------------

- (void) prefTimerMoveTo:(const NSPoint *)thePoint
{
	[prefTimerLabel moveTo:thePoint];
} // prefTimerMoveTo

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark View Updates

//---------------------------------------------------------------------------------------
//
// Handles resizing of OpenGL view, if the window dimensions change, window dimensions
// update, viewports reset, and projection matrix update.
//
//---------------------------------------------------------------------------------------

- (void) viewResize
{
	viewFlags[kOpenGLViewResized] = [self viewUpdate];
	
	if( viewFlags[kOpenGLViewResized] )
	{
		// OpenGL text objects needs to know the view bounds 
		// have changed as well.
		
		NSRect viewBounds = [self viewBounds];
		
		// Get a new backing store for our view's snapshot
		
		[viewSnapshot setFrame:&viewBounds];
				
		// Resize the capture object

		if( viewFlags[kOpenGLViewCaptureEnabled] )
		{
			[viewCapture setBounds:&viewBounds];
		} // if
		
		// Notify all labels that their bounds have changed
		
		[viewBoundsLabel viewSetBounds:&viewBounds];
		[rendererLabel   viewSetBounds:&viewBounds];
		[prefTimerLabel  viewSetBounds:&viewBounds];
	} // if
} // viewResize

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Draw Utilities

//---------------------------------------------------------------------------------------

- (void) drawBegin
{	
	// Make the OpenGL context the current context
	
	[self contextMakeCurrent];
	
	// Forces projection matrix update (does test for size changes)

	[self viewResize];
	
	// Clear our drawable

	[self viewClear];
} // drawBegin

//---------------------------------------------------------------------------------------
//
// Display the view bounds label
//
//---------------------------------------------------------------------------------------

- (void) drawViewBoundsLabel
{
	if( viewFlags[kOpenGLViewDisplayBounds] )
	{
		[viewBoundsLabel labelDraw];
	} // if
} // drawViewBoundsLabel

//---------------------------------------------------------------------------------------
//
// Display the pref timer label
//
//---------------------------------------------------------------------------------------

- (void) drawPrefTimerLabel
{
	if( viewFlags[kOpenGLViewDisplayPrefTimer] )
	{
		[prefTimerLabel labelSetNeedsUpdate:[self rotation]];
		[prefTimerLabel labelDraw];
	} // if
} // drawPrefTimerLabel

//---------------------------------------------------------------------------------------
//
// Display the renderer label
//
//---------------------------------------------------------------------------------------

- (void) drawRendererLabel
{
	if( viewFlags[kOpenGLViewDisplayRenderer] )
	{
		[rendererLabel labelDraw];
	} // if
} // drawRendererLabel

//---------------------------------------------------------------------------------------

- (void) drawEnd
{
	// Take a snapshot of the view
	
	[viewSnapshot snapshot];
	
	// Start recording from a frame
	
	[viewCapture capture];
	
	// Draw the view bounds
	
	[self drawViewBoundsLabel];
	
	// Draw the pref timer
	
	[self drawPrefTimerLabel];

	// Draw the renderer's info
	
	[self drawRendererLabel];

	// Flush the current context
	
	[self contextFlushBuffer];
} // drawEnd

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Notification

//---------------------------------------------------------------------------------------
//
// It's important to clean up our rendering objects before we terminate -- Cocoa will 
// not specifically release everything on application termination, so we explicitly 
// call our clean up routine ourselves.
//
//---------------------------------------------------------------------------------------

- (void) viewWillTerminate:(NSNotification *)notification
{
	[self cleanUpOpenGLView];
} // viewWillTerminate

//---------------------------------------------------------------------------------------
//
// When flushing media author queue one needs to stop object rotation.
//
//---------------------------------------------------------------------------------------

- (void) suspendObjectRotation:(NSNotification *)notification
{
	if( !viewFlags[kOpenGLViewStopObjectRotation] )
	{	
		[self rotationStop];
		
		viewFlags[kOpenGLViewStopObjectRotation] = YES;
	} // if
} // suspendObjectRotation

//---------------------------------------------------------------------------------------
//
// When media sample authoring is restarted, one needs to restart object rotation.
//
//---------------------------------------------------------------------------------------

- (void) resumeObjectRotation:(NSNotification *)notification
{
	if( viewFlags[kOpenGLViewStopObjectRotation] )
	{
		[self rotationStart];
		
		viewFlags[kOpenGLViewStopObjectRotation] = NO;
	} // if
} // resumeObjectRotation

//---------------------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

