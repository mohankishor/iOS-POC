//---------------------------------------------------------------------------
//
//	File: OpenGLPlasmaExhibitsView.m
//
//  Abstract: Main rendering class for all GLSL plasma exhibits
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
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#import "PreferencesMediator.h"
#import "OpenGLPlasmaExhibitsView.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@implementation OpenGLPlasmaExhibitsView

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Post Notification

//---------------------------------------------------------------------------

- (void) postPlasmaExhibitsViewTerminationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(plasmaExhibitsViewWillTerminate:)
												 name:@"NSApplicationWillTerminateNotification"
											   object:NSApp];
} // postPlasmaExhibitsViewTerminationNotification

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated Initializer

//---------------------------------------------------------------------------

- (void) initExibitDefault
{
	NSNumber *exibitTypeNum = [preferences objectForKey:@"Exhibit Type"];
	
	if( exibitTypeNum )
	{
		[exhibits setExhibitWithType:[exibitTypeNum unsignedIntValue]];
	} // if
	else
	{
		[exhibits setExhibitWithType:kPlasmaExhibitIsTranguloidTrefoilSurface];
	} // else
} // initExibitDefault

//---------------------------------------------------------------------------

- (void) initLightPositionDefaults
{
	NSNumber *lightXPositionNum = [preferences objectForKey:@"Light X Position"];
	NSNumber *lightYPositionNum = [preferences objectForKey:@"Light Y Position"];
	NSNumber *lightZPositionNum = [preferences objectForKey:@"Light Z Position"];
	
	if( lightXPositionNum )
	{
		lightPos[0] = [lightXPositionNum floatValue];
	} // if
	
	if( lightYPositionNum )
	{
		lightPos[1] = [lightYPositionNum floatValue];
	} // if

	if( lightZPositionNum )
	{
		lightPos[2] = [lightZPositionNum floatValue];
	} // if
} // initLightPositionDefaults

//---------------------------------------------------------------------------

- (void) initLabelDefaults
{
	NSNumber *displayViewBoundsLabelNum = [preferences objectForKey:@"Display View Bounds Label"];
	NSNumber *displayPrefTimerLabelNum  = [preferences objectForKey:@"Display Pref Timer Label"];
	NSNumber *displayRendererLabelNum   = [preferences objectForKey:@"Display Renderer Label"];
	
	if( displayViewBoundsLabelNum )
	{
		[self viewBoundsDisplayLabel:[displayViewBoundsLabelNum boolValue]];
	} // if
	
	if( displayPrefTimerLabelNum )
	{
		[self prefTimerDisplayLabel:[displayPrefTimerLabelNum boolValue]];
	} // if
	
	if( displayRendererLabelNum )
	{
		[self rendererDisplayLabel:[displayRendererLabelNum boolValue]];
	} // if
} // initLabelDefaults

//---------------------------------------------------------------------------

- (void) initDefaults
{
	preferences = [OpenGLPlasmaExhibitsPrefsMediator new];
	
	if( preferences )
	{
		[self initLabelDefaults];
		[self initLightPositionDefaults];
		[self initExibitDefault];
	} // if
	else
	{
		[exhibits setExhibitWithType:kPlasmaExhibitIsTranguloidTrefoilSurface];
	} // else
} // initDefaults

//---------------------------------------------------------------------------

- (id) initWithFrame:(NSRect)theFrame
{
	self = [super initWithFrame:theFrame];
	
	if( self )
	{
		lightPos[0] = 0.0f;
		lightPos[1] = 0.0f;
		lightPos[2] = 0.0f;
		
		exhibits = [OpenGLPlasmaExhibitsMediator new];
		
		if( exhibits )
		{
			[self initDefaults];
		} // if
		
		pathname = [DefaultPathname new];
		
		[self postPlasmaExhibitsViewTerminationNotification];
	} // if
	
	return( self );
} // initWithFrame

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Deallocating Resources

//---------------------------------------------------------------------------
//
// Delete exhibits
//
//---------------------------------------------------------------------------

- (void) cleanUpExhibitsView
{
	if( preferences )
	{
		[preferences write];
		[preferences release];
		
		preferences = nil;
	} // if
	
	if( exhibits )
	{
		[exhibits release];
		
		exhibits = nil;
	} // if
	
	if( pathname )
	{
		[pathname release];
		
		pathname = nil;
	} // if
} // cleanUpExhibitsView

//---------------------------------------------------------------------------

- (void) dealloc
{
	// Delete exhibits
	
	[self cleanUpExhibitsView];
	
	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Capturing from a View

//---------------------------------------------------------------------------

- (void) viewSnapshot
{
	NSString *imageDirectory = [preferences objectForKey:@"Image Directory"];
	NSString *imagePathname  = [pathname pathnameWithDirectory:imageDirectory 
														  name:@"image"];
	
	[super viewSnapshot:imagePathname
				   type:[preferences objectForKey:@"Image Type"]
			compression:[preferences objectForKey:@"Image Compression"]
				  title:[preferences objectForKey:@"PDF Optional Title"]
				 author:[preferences objectForKey:@"PDF Optional Author"]
				subject:[preferences objectForKey:@"PDF Optional Subject"]
				creator:[preferences objectForKey:@"PDF Optional Creator"]];
} // viewSnapshot

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Recording from a View

//---------------------------------------------------------------------------

- (void) viewCaptureEnable
{
	NSString *movieDirectory = [preferences objectForKey:@"Movie Directory"];
	
	[super viewCaptureEnable:movieDirectory];
} // viewCaptureEnable

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Drawing the content

//---------------------------------------------------------------------------

- (void) drawRect:(NSRect) theRect
{
	[self drawBegin];
	
	[exhibits executeExhibit:lightPos];
	
	[self drawEnd];
} // drawRect

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Setters for Uniforms & Exhibits

//---------------------------------------------------------------------------

- (void) setExhibitItem:(const OpenGLPlasmaExhibitType)theExhibitSelected
{
	[exhibits setExhibitWithType:theExhibitSelected];
} // setExhibitItem

//---------------------------------------------------------------------------

- (void) setUniformUsingControls:(const GLfloat)theUniformValue 
			  coordinatePosition:(const GLuint)theCoordinatePosition
{
	lightPos[theCoordinatePosition] = theUniformValue;
} // setUniformUsingControls

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Application Preference Accessors

//---------------------------------------------------------------------------

- (id) preferenceGetObjectForKey:(id)theKey
{
	return( [preferences objectForKey:theKey] );
} // preferenceGetObjectForKey

//---------------------------------------------------------------------------

- (void) preferenceSetObject:(id)theObject
					  forKey:(NSString *)theKey
{
	[preferences setObject:theObject
					forKey:theKey];
} // preferenceSetObject

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Notification

//---------------------------------------------------------------------------
//
// It's important to clean up our rendering objects before we terminate -- 
// Cocoa will not specifically release everything on application termination, 
// so we explicitly call our clean up routine ourselves.
//
//---------------------------------------------------------------------------

- (void) plasmaExhibitsViewWillTerminate:(NSNotification *)notification
{
	[self cleanUpExhibitsView];
} // plasmaExhibitsViewWillTerminate

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

