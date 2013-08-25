//-------------------------------------------------------------------------
//
//	File: CGBitmapImageRep.c
//
//  Abstract: Utility functions for converting XRGB pixels into RGBA
//            CG image opaque references.
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
//-------------------------------------------------------------------------

//------------------------------------------------------------------------

#include "CGBitmapImageRep.h"
#include "OpenGLTextureSourceTypes.h"

//------------------------------------------------------------------------

//------------------------------------------------------------------------

struct CGBitmapImageRep
{
	GLuint           bitsPerComponent;
    GLvoid          *data;				// Pointer to the top left pixel of the buffer
    GLuint           height;			// The height (in pixels) of the buffer
    GLuint           width;				// The width (in pixels) of the buffer
    GLuint           rowBytes;			// The number of bytes in a pixel row
    GLuint           size;				// The image size
	CFStringRef      colorSpaceName;
	CGColorSpaceRef  colorSpace;
	CGBitmapInfo     bitmapInfo;
	CGContextRef     contextRef;
};

typedef struct CGBitmapImageRep   CGBitmapImageRep;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

BOOL CGBitmapImageRepRelease( CGBitmapImageRepRef bitmapImage )
{
	BOOL  imageBitmapFreed = NO;
	
	if( bitmapImage != NULL )
	{
		if( bitmapImage->colorSpace != NULL )
		{
			CGColorSpaceRelease( bitmapImage->colorSpace );
		} // if
		
		if( bitmapImage->contextRef != NULL )
		{
			CGContextRelease( bitmapImage->contextRef );
		} // if
		
		free( bitmapImage );
		
		bitmapImage = NULL;
		
		imageBitmapFreed = YES;
	} // if
	
	return imageBitmapFreed;
} // CGBitmapImageRepRelease

//------------------------------------------------------------------------

static BOOL CGBitmapImageRepIsValid( CGBitmapImageRepRef theBitmapImage )
{
	BOOL bitmapDataIsValid = theBitmapImage->data       != NULL;
	BOOL colorSpaceIsValid = theBitmapImage->colorSpace != NULL;
	BOOL contextIsValid    = theBitmapImage->contextRef != NULL;
	
	return( bitmapDataIsValid && colorSpaceIsValid && contextIsValid );
} // CGBitmapImageRepIsValid

//------------------------------------------------------------------------

CGBitmapImageRepRef CGBitmapImageRepCreate(const NSSize *theSize,
										   void *theImage)
{
	CGBitmapImageRepRef bitmapImage = NULL;
	
	if( theImage != NULL )
	{
		bitmapImage = (CGBitmapImageRepRef)malloc(sizeof(CGBitmapImageRep));
		
		if( bitmapImage != NULL )
		{
			bitmapImage->colorSpaceName = kCGColorSpaceGenericRGB;
			bitmapImage->colorSpace     = CGColorSpaceCreateWithName( bitmapImage->colorSpaceName );
			
			if( bitmapImage->colorSpace != NULL )
			{
				bitmapImage->bitsPerComponent = kTextureMaxBPS;
				bitmapImage->data             = theImage;
				bitmapImage->width            = (GLuint)theSize->width;
				bitmapImage->height           = (GLuint)theSize->height;
				bitmapImage->rowBytes         = kTextureMaxSPP * bitmapImage->width;
				bitmapImage->size             = bitmapImage->rowBytes * bitmapImage->height;
				
				#if __BIG_ENDIAN__
					bitmapImage->bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big;		// XRGB Big Endian
				#else
					bitmapImage->bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little;	// XRGB Little Endian
				#endif

				bitmapImage->contextRef = CGBitmapContextCreate(bitmapImage->data, 
																bitmapImage->width, 
																bitmapImage->height, 
																bitmapImage->bitsPerComponent,
																bitmapImage->rowBytes, 
																bitmapImage->colorSpace, 
																bitmapImage->bitmapInfo);
			} // if
		} // if
		
		if( !CGBitmapImageRepIsValid( bitmapImage ) )
		{
			CGBitmapImageRepRelease( bitmapImage );
		} // if
	} // if
	
	return( bitmapImage );
} // CGBitmapImageRepCreate

//------------------------------------------------------------------------

void CGBitmapImageRepSetImage(void *theImage, 
							  CGBitmapImageRepRef theBitmapImage)
{
	if( theImage != NULL )
	{
		theBitmapImage->data = theImage;
	} // if
} // CGBitmapImageRepSetImage

//------------------------------------------------------------------------

void CGBitmapImageRepCopyImage(void *theImage, 
							   CGBitmapImageRepRef theBitmapImage)
{
	memcpy( theBitmapImage->data, theImage, theBitmapImage->size );
} // CGBitmapImageRepCopyImage

//------------------------------------------------------------------------

CGImageRef CGImageCreateFromBitmapImageRep( CGBitmapImageRepRef theBitmapImage )
{
	CGImageRef imageRef = NULL;
	
	if( ( theBitmapImage != NULL ) && ( theBitmapImage->contextRef != NULL ) )
	{		
		// Create a new image from the bitmap context
			
		imageRef = CGBitmapContextCreateImage( theBitmapImage->contextRef );
	} // if
	
	return( imageRef );
} // CGImageCreateFromBitmapImageRep

//------------------------------------------------------------------------

//------------------------------------------------------------------------

