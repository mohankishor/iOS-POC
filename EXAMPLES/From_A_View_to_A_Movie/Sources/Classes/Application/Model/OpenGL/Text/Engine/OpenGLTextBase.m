//---------------------------------------------------------------------------
//
// File: OpenGLTextBase.m
//
// Abstract: Utility toolkit to render anti-aliased system fonts as 
//           textures.
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
// Copyright ( C ) 2003-2009 Apple Inc. All Rights Reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#import "NSBezierPath+RoundRect.h"
#import "OpenGLTextBase.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structure 

//---------------------------------------------------------------------------

struct OpenGLTextBorder
{
	NSSize	 margins;		// offset or frame size, default is 4 width 2 height
	NSRect	 frame;			// offset or frame size, default is 4 width 2 height
	GLfloat  cornerRadius;	// if 0 just a rectangle. Defaults to 4.0f
	BOOL     isStatic;		// default is NO
	BOOL     hasBorder;		// flag is set depending on the designated initializer
};

typedef struct OpenGLTextBorder  OpenGLTextBorder;

//---------------------------------------------------------------------------

struct OpenGLTextTexture
{
	GLvoid             *image;		// the texture image
	NSSize              size;		// the texture width & height
	OpenGLTextureUsage  usage;		// for using PBOs or texture range
	BOOL                update;		// a flag to determine if the texture needs an update
	BOOL                antialias;	// default is YES
};

typedef struct OpenGLTextTexture  OpenGLTextTexture;

//---------------------------------------------------------------------------

struct OpenGLTextAttributes
{
	NSRect             viewBounds;	// OpenGL view bounds
	OpenGLTextBorder   border;		// String border properties
	OpenGLTextTexture  texture;		// String texture properties
};

typedef struct OpenGLTextAttributes  OpenGLTextAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark OpenGLTextBase

//---------------------------------------------------------------------------
//
// OpenGLTextBase
//
//---------------------------------------------------------------------------

@implementation OpenGLTextBase

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Initializers

//---------------------------------------------------------------------------
//
// Make sure client goes through designated initializer
//
//---------------------------------------------------------------------------

- (id) init
{
	[self doesNotRecognizeSelector:_cmd];
	
	return nil;
} // init

//---------------------------------------------------------------------------
//
// Designated initializers
//
//---------------------------------------------------------------------------

- (id) initWithAttributedString:(NSAttributedString *)theAttributedString 
					stringColor:(NSColor *)theTextColor 
					   boxColor:(NSColor *)theBoxColor 
					borderColor:(NSColor *)theBorderColor
						 bounds:(const NSRect *)theBounds
{
	self = [super init];
	{
		textAttribs = (OpenGLTextAttributesRef)malloc(sizeof(OpenGLTextAttributes));
		
		if( textAttribs != NULL )
		{
			textAttribs->texture.size.width       = 0.0f;
			textAttribs->texture.size.height      = 0.0f;
			textAttribs->texture.update           = YES;
			textAttribs->texture.antialias        = YES;
			textAttribs->texture.usage            = GL_STORAGE_CACHED_APPLE;
			textAttribs->border.margins.width     = 4.0f;
			textAttribs->border.margins.height    = 2.0f;
			textAttribs->border.frame.origin.x    = 0.0f;
			textAttribs->border.frame.origin.y    = 0.0f;
			textAttribs->border.frame.size.width  = 0.0f;
			textAttribs->border.frame.size.height = 0.0f;
			textAttribs->border.cornerRadius      = 4.0f;
			textAttribs->border.isStatic          = NO;
			textAttribs->border.hasBorder         = NO;
			textAttribs->viewBounds               = *theBounds;
			
			textString = nil;
			bitmap     = nil;
			
			[theAttributedString retain];
			textString = theAttributedString;
			
			if( theTextColor )
			{
				[theTextColor retain];
				textStringColor = theTextColor;
			} // if
			else
			{
				textStringColor =[NSColor whiteColor];		
			} // else
			
			if( theBorderColor )
			{
				[theBoxColor retain];
				boxColor = theBoxColor;
				
				[theBorderColor retain];
				borderColor = theBorderColor;
				
				textAttribs->border.hasBorder = YES;
			} // if
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Text Base - Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return( self );
} // initWithAttributedString

//---------------------------------------------------------------------------

- (id) initWithString:(NSString *)theString 
		   attributes:(NSDictionary *)theAttributes 
		  stringColor:(NSColor *)theTextColor 
			 boxColor:(NSColor *)theBoxColor 
		  borderColor:(NSColor *)theBorderColor
			   bounds:(const NSRect *)theBounds
{
	return( [self initWithAttributedString:[[[NSAttributedString alloc] initWithString:theString 
																			attributes:theAttributes] autorelease] 
							   stringColor:theTextColor 
								  boxColor:theBoxColor 
							   borderColor:theBorderColor
									bounds:theBounds] );
} // initWithString

//---------------------------------------------------------------------------
//
// Designated initializer for an attributed string without borders
//
//---------------------------------------------------------------------------

- (id) initWithAttributedString:(NSAttributedString *)attributedString
						 bounds:(const NSRect *)theBounds
{
	return( [self initWithAttributedString:attributedString 
							   stringColor:nil 
								  boxColor:nil 
							   borderColor:nil
									bounds:theBounds] );
} // initWithAttributedString

//---------------------------------------------------------------------------
//
// Designated initializer for a string without borders
//
//---------------------------------------------------------------------------

- (id) initWithString:(NSString *)theString 
		   attributes:(NSDictionary *)theAttributes
			   bounds:(const NSRect *)theBounds
{
	return( [self initWithAttributedString:[[[NSAttributedString alloc] initWithString:theString 
																			attributes:theAttributes] autorelease] 
							   stringColor:nil 
								  boxColor:nil
							   borderColor:nil
									bounds:theBounds] );
} // initWithString

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Dealloc

//---------------------------------------------------------------------------

- (void) cleanUpTextBase
{
	if( textureMediator )
	{
		[textureMediator release];
		
		textureMediator = nil;
	} // if
	
	if( textStringColor )
	{
		[textStringColor release];
		
		textStringColor = nil;
	} // if
	
	if( boxColor )
	{
		[boxColor release];
		
		boxColor = nil;
	} // if
	
	if( borderColor )
	{
		[borderColor release];
		
		borderColor = nil;
	} // if
	
	if( textString )
	{
		[textString release];
		
		textString = nil;
	} // if
	
	if( textAttribs != NULL )
	{
		free( textAttribs );
		
		textAttribs = NULL;
	} // if
} // cleanUpTextBase

//---------------------------------------------------------------------------

- (void) dealloc
{
	[self cleanUpTextBase];
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Text Color

//---------------------------------------------------------------------------
//
// Set the default to use PBOs or texture range
//
//---------------------------------------------------------------------------

- (void) setUsage:(const OpenGLTextureUsage)theUsage 
{
	textAttribs->texture.usage = theUsage;
} // setUsage

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Text Color

//---------------------------------------------------------------------------
//
// Set default the text color
//
//---------------------------------------------------------------------------

- (void) setTextColor:(NSColor *)color 
{
	[color retain];
	[textStringColor release];
	
	textStringColor = color;
	
	textAttribs->texture.update = YES;
} // setTextColor

//---------------------------------------------------------------------------
//
// Get the pre-multiplied default text color (includes alpha) string 
// attributes could override this
//
//---------------------------------------------------------------------------

- (NSColor *) stringColor
{
	return( textStringColor );
} // stringColor

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Box Color

//---------------------------------------------------------------------------
//
// Set default theTextColor color
//
//---------------------------------------------------------------------------

- (void) setBoxColor:(NSColor *)color 
{
	[color retain];
	[boxColor release];
	
	boxColor = color;
	
	textAttribs->texture.update = YES;
} // setBoxColor

//---------------------------------------------------------------------------
//
// Get the pre-multiplied box color (includes alpha) alpha of 0.0 means no 
// background box color
//
//---------------------------------------------------------------------------

- (NSColor *) boxColor
{
	return( boxColor );
} // boxColor

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Border Color

//---------------------------------------------------------------------------
//
// Set default text color
//
//---------------------------------------------------------------------------

- (void) setBorderColor:(NSColor *)color 
{
	[color retain];
	[borderColor release];
	
	borderColor = color;
	
	textAttribs->texture.update = YES;
} // setBorderColor

//---------------------------------------------------------------------------
//
// Get the pre-multiplied border color (includes alpha) alpha of 0.0 means 
// no boeder color
//
//---------------------------------------------------------------------------

- (NSColor *) borderColor
{
	return( borderColor );
} // borderColor

//---------------------------------------------------------------------------

#pragma mark Border Margins

//---------------------------------------------------------------------------
//
// Set offset size and size to fit with offset
//
// This method will force the texture to be regenerated at the next draw
//
//---------------------------------------------------------------------------

- (void) setBorderMargins:(const NSSize *)theMargin
{
	textAttribs->border.margins = *theMargin;
	
	if( textAttribs->border.isStatic == NO ) 
	{ 
		// ensure dynamic frame sizes will be recalculated
		
		textAttribs->border.frame.size.width  = 0.0f;
		textAttribs->border.frame.size.height = 0.0f;
	} // if
	
	textAttribs->texture.update = YES;
} // setBorderMargins

//---------------------------------------------------------------------------
//
// Current margins for text color offset and pads for dynamic frame
//
//---------------------------------------------------------------------------

- (NSSize) borderMargins
{
	return( textAttribs->border.margins );
} // borderMargins

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark Border Properties

//---------------------------------------------------------------------------

- (void) updateBorderSize
{
	if( (textAttribs->border.isStatic == NO) 
		&& (textAttribs->border.frame.size.width == 0.0f) 
		&& (textAttribs->border.frame.size.height == 0.0f) ) 
	{ 
		// find frame size if we have not already found it
		
		// current string size
		
		textAttribs->border.frame.size = [textString size];
		
		// add padding
		
		textAttribs->border.frame.size.width  += textAttribs->border.margins.width  * 2.0f;
		textAttribs->border.frame.size.height += textAttribs->border.margins.height * 2.0f;
	} // if
} // updateBorderSize

//---------------------------------------------------------------------------
//
// Returns either dynamc frame (text color size + margins) or static frame 
// size (switch with static frame)
//
//---------------------------------------------------------------------------

- (NSSize) borderFrame
{
	[self updateBorderSize];
	
	return( textAttribs->border.frame.size );
} // borderFrame

//---------------------------------------------------------------------------
//
// Returns whether or not a static frame will be used
//
//---------------------------------------------------------------------------

- (BOOL) borderIsStatic
{
	return( textAttribs->border.isStatic );
} // borderIsStatic

//---------------------------------------------------------------------------
//
// Set static frame size and size to frame
//
// This method will force the texture to be regenerated at the next draw
//
//---------------------------------------------------------------------------

- (void) useStaticBorder:(const NSSize *)theBorder
{
	textAttribs->border.frame.size = *theBorder;
	textAttribs->border.isStatic   =  YES;
	textAttribs->texture.update    =  YES;
} // useStaticBorder

//---------------------------------------------------------------------------
//
// Use dynamic instead of static frame
//
// This method will force the texture to be regenerated at the next draw
//
//---------------------------------------------------------------------------

- (void) useDynamicBorder
{
	if( textAttribs->border.isStatic ) 
	{ 
		// set to dynamic frame and set to regenerate texture
		
		textAttribs->border.isStatic = NO;
		
		// ensure frame sizes will be recalculated
		
		textAttribs->border.frame.size.width  = 0.0f;
		textAttribs->border.frame.size.height = 0.0f;
		
		textAttribs->texture.update = YES;
	} // if
} // useDynamicBorder

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Antialiasing

//---------------------------------------------------------------------------
//
// The current anitaliasing state of the selected font
//
//---------------------------------------------------------------------------

- (BOOL) antialias
{
	return( textAttribs->texture.antialias );
} // antialias

//---------------------------------------------------------------------------
//
// Set the anitaliasing state of a font
//
//---------------------------------------------------------------------------

- (void) setAntialias:(const BOOL)theAntialiasState
{
	textAttribs->texture.antialias = theAntialiasState;
	textAttribs->texture.update    = YES;
} // setAntialias

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark String

//---------------------------------------------------------------------------
//
// Set string after initial creation
//
//---------------------------------------------------------------------------

- (void) setString:(NSAttributedString *)attributedString
{
	[attributedString retain];
	
	if( textString )
	{
		[textString release];
		
		textString = nil;
	} // if
	
	textString = attributedString;
	
	if( textAttribs->border.isStatic == NO ) 
	{ 
		// ensure dynamic frame sizes will be recalculated
		
		textAttribs->border.frame.size.width  = 0.0f;
		textAttribs->border.frame.size.height = 0.0f;
	} // if
	
	textAttribs->texture.update = YES;
} // setString

//---------------------------------------------------------------------------
//
// Set string after initial creation
//
//---------------------------------------------------------------------------

- (void) setString:(NSString *)theString 
		attributes:(NSDictionary *)theAttributes
{
	[self setString:[[[NSAttributedString alloc] initWithString:theString 
													 attributes:theAttributes] autorelease]];
} // setString

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark OpenGL View Bounds

//---------------------------------------------------------------------------
//
// Set the current OpenGL view bounds
//
//---------------------------------------------------------------------------

- (void) viewSetBounds:(const NSRect *)theBounds
{
	textAttribs->viewBounds = *theBounds;
	
	textAttribs->texture.update = YES;
} // viewSetBounds

//---------------------------------------------------------------------------

- (NSRect) viewBounds
{
	return( textAttribs->viewBounds );
} // viewBounds

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Texture Updates

//---------------------------------------------------------------------------

- (void) updateBorder
{
	if( textAttribs->border.hasBorder )
	{
		NSRect insetRect = NSInsetRect(textAttribs->border.frame,0.5, 0.5);
		
		if( [boxColor alphaComponent] ) 
		{ 
			// this should be == 0.0f but need to make sure
			
			[boxColor set]; 
			
			NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:insetRect
															cornerRadius:textAttribs->border.cornerRadius];
			[path fill];
		} // if
		
		if( [borderColor alphaComponent] ) 
		{
			[borderColor set];
			
			NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:insetRect 
															cornerRadius:textAttribs->border.cornerRadius];
			[path setLineWidth:1.0f];
			[path stroke];
		} // if
	} // if
} // updateBorder

//---------------------------------------------------------------------------

- (void) updateWithNewBitmapImageRep
{
	NSImage *image = [[NSImage alloc] initWithSize:textAttribs->border.frame.size];
	
	[image lockFocus];
		
		[[NSGraphicsContext currentContext] setShouldAntialias:textAttribs->texture.antialias];
		
		[self updateBorder];
		
		[textStringColor set]; 
		
		// draw at offset position
		
		[textString drawAtPoint:NSMakePoint(textAttribs->border.margins.width, 
											textAttribs->border.margins.height)];
		
		bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect:textAttribs->border.frame];
	
	[image unlockFocus];
	
	[image release];
} // updateWithNewBitmapImageRep

//---------------------------------------------------------------------------

- (void) updateBitmapImageRep
{
	if( bitmap )
	{
		[bitmap release];
		
		bitmap = nil;
	} // if

	[self updateWithNewBitmapImageRep];

	textAttribs->texture.size.width  = [bitmap pixelsWide];
	textAttribs->texture.size.height = [bitmap pixelsHigh];
	textAttribs->texture.image       = [bitmap bitmapData];
} // updateBitmapImageRep

//---------------------------------------------------------------------------
//
// Generates a string texture without drawing the texture to current context.
//
//---------------------------------------------------------------------------

- (void) updateTexture:(const NSPoint *)theOrigin
{
	if( textAttribs->texture.update )
	{
		[self updateBorderSize];
		[self updateBitmapImageRep];
		
		NSRect frame = NSMakeRect(theOrigin->x, 
								  theOrigin->y, 
								  textAttribs->texture.size.width, 
								  textAttribs->texture.size.height);
		
		if( textureMediator == nil )
		{
			// Instantiate a new texture controller object
			
			textureMediator = [[OpenGLTextureMediator alloc] initTextureManager:textAttribs->texture.usage];
		} // if
		
		[textureMediator update:textAttribs->texture.image
						  frame:&frame];
		
		textAttribs->texture.update = NO;
	} // if

	[textureMediator draw];
} // updateTexture

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Drawing

//---------------------------------------------------------------------------

- (void) stringDrawAtPoint:(const NSPoint *)theOrigin
{
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);

	// GL_COLOR_BUFFER_BIT for glBlendFunc, GL_ENABLE_BIT for enable/disable pair
	
	glPushAttrib(GL_ENABLE_BIT | GL_TEXTURE_BIT | GL_COLOR_BUFFER_BIT);
	
		// ensure text color is not removed by depth buffer test.
		
		glDisable(GL_DEPTH_TEST);
		
		// for the text color fading
		
		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		
		// update the texture
	
		[self updateTexture:theOrigin];
	
	glPopAttrib();
} // stringDrawAtPoint

//---------------------------------------------------------------------------
//
// Draw the string at the (x,y) coordinate points
//
//---------------------------------------------------------------------------

- (void) stringScale
{
	GLfloat scaleX =  2.0f / textAttribs->viewBounds.size.width;
	GLfloat scaleY = -2.0f / textAttribs->viewBounds.size.height;
	GLfloat scaleZ =  1.0f;
	
	glScalef(scaleX, scaleY, scaleZ);
} // stringScale

//---------------------------------------------------------------------------

- (void) stringTranslate
{
	GLfloat translateX = -0.5f * textAttribs->viewBounds.size.width;
	GLfloat translateY = -0.5f * textAttribs->viewBounds.size.height;
	GLfloat translateZ =  0.0f;
	
	glTranslatef(translateX, translateY, translateZ);
} // stringTranslate

//---------------------------------------------------------------------------

- (GLint) stringDrawPrep
{
	GLint matrixMode = 0;
	
	// set orthograhic 1:1  pixel transform in local view coords
	
	glGetIntegerv(GL_MATRIX_MODE, &matrixMode);
	
	glMatrixMode(GL_PROJECTION);
	
	glPushMatrix();
	
	glLoadIdentity();
	glMatrixMode (GL_MODELVIEW);
	
	glPushMatrix();
	
	glLoadIdentity();
	
	return( matrixMode );
} // stringDrawPrep

//---------------------------------------------------------------------------

- (void) stringDrawReset:(const GLint)theMatrixMode
{
	// reset orginal martices
	
	glPopMatrix(); // GL_MODELVIEW
	
	glMatrixMode(GL_PROJECTION);
	
	glPopMatrix();
	
	glMatrixMode(theMatrixMode);
} // stringDrawReset

//---------------------------------------------------------------------------

- (void) drawString:(const NSPoint *)theOrigin
{
	GLint matrixMode = [self stringDrawPrep];
	
	[self stringScale];
	[self stringTranslate];
	
	[self stringDrawAtPoint:theOrigin];
	
	[self stringDrawReset:matrixMode];
} // drawString

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

