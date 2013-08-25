//---------------------------------------------------------------------------
//
//	File: OpenGLFBOStatus.m
//
//  Abstract: Class that implements a utility toolkit for fbo status
//            check.
//
//  Disclaimer: IMPORTANT:  This Apple software is supplied to you by
//  Apple Inc. ("Apple") in consideration of your agreement to the
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
//  Neither the name, trademarks, service marks or logos of Apple Inc.
//  may be used to endorse or promote products derived from the Apple
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

#import "OpenGLFBOAlertPanelMessages.h"
#import "OpenGLFBOStatus.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

static void GetFBOAlertMessage(const GLenum theFBOStatus,
							   NSMutableString *theFBOAlertMessage)
{
	switch( theFBOStatus )
	{
		case GL_FRAMEBUFFER_UNSUPPORTED_EXT:
			
			[theFBOAlertMessage setString:kOpenGLFramebufferUnsupported];
			break;
			
		case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT:
			
			[theFBOAlertMessage setString:kOpenGLFramebufferIncompleteAttachement];
			break;
			
		case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT:
			
			[theFBOAlertMessage setString:kOpenGLFramebufferIncompleteMissingAttachement];
			break;
			
		case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT:
			
			[theFBOAlertMessage setString:KOpenGLFramebufferIncompleteDimensions];
			break;
			
		case GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT:
			
			[theFBOAlertMessage setString:kOpenGLFramebufferIncompleteFormats];
			break;
			
		case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT:
			
			[theFBOAlertMessage setString:kOpenGLFramebufferIncompleteDrawBuffer];
			break;
			
		case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT:
			
			[theFBOAlertMessage setString:kOpenGLFramebufferIncompleteReadBuffer];
			break;
			
		default:
			
			[theFBOAlertMessage setString:kOpenGLFramebufferDefaultAlertPanelMessage];
			break;
	} // switch
} // GetFBOAlertMessage

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation OpenGLFBOStatus

//---------------------------------------------------------------------------

- (id) initStatusWithFBOTarget:(const GLenum)theFBOTarget 
						  exit:(const BOOL)theExitFlag
{	
	NSMutableString *message = [NSMutableString new];
	
	if( message )
	{
		GLenum status = glCheckFramebufferStatusEXT( theFBOTarget );       
		
		GetFBOAlertMessage( status, message );
		
		self = [super init];
		
		if( self )
		{
			fboAlertMessage = message;
			fboGLStatus     = status;
			fboExitStatus   = theExitFlag;
		} // if
	} // if
	
	return( self );
} // initStatusWithFBOTarget

//------------------------------------------------------------------------

+ (id) statusWithFBOTarget:(const GLenum)theFBOTarget 
					  exit:(const BOOL)theExitFlag
{
	return( [[[OpenGLFBOStatus allocWithZone:[self zone]] initStatusWithFBOTarget:theFBOTarget
																			 exit:theExitFlag] autorelease] );
} // statusWithFBOTarget

//------------------------------------------------------------------------

- (void) dealloc
{
	if( fboAlertMessage )
	{
		[fboAlertMessage release];
		
		fboAlertMessage = nil;
	} // if

	[super dealloc];
} // dealloc

//------------------------------------------------------------------------

- (BOOL) framebufferComplete
{
	BOOL fboStatusIsOk = NO;
	
	if( fboGLStatus == GL_FRAMEBUFFER_COMPLETE_EXT )
	{
		fboStatusIsOk = YES;
	} // if
	else
	{
		NSRunAlertPanel(@"OpenGL FBO Status",
						fboAlertMessage, 
						@"OK", 
						nil, 
						nil);
		
		if( fboExitStatus )
		{
			exit( -1 );
		} // if
	} // else
	
	return( fboStatusIsOk );
} // framebufferComplete

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------


