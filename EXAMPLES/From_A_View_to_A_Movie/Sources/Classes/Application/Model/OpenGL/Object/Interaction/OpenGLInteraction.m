//---------------------------------------------------------------------------------------
//
//	File: OpenGLInteraction.h
//
//  Abstract: OpenGL utilities to interact with 3D objects
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

#import "OpenGLInteraction.h"

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------------------

struct OpenGLVector
{
	GLdouble x;
	GLdouble y;
	GLdouble z;
};

typedef struct	OpenGLVector OpenGLVector;

//---------------------------------------------------------------------------------------

struct OpenGLClippingPlanes
{
	GLdouble left;
	GLdouble right;
	GLdouble top;
	GLdouble bottom;
	GLdouble near;
	GLdouble far;
};

typedef struct	OpenGLClippingPlanes  OpenGLClippingPlanes;

//---------------------------------------------------------------------------------------

struct OpenGLCamera
{
	OpenGLVector position;		// View position
	OpenGLVector direction;		// View direction vector
	OpenGLVector directionUp;	// View up direction
	GLdouble     aperture;		// camera aperture
	NSSize       size;			// current window/screen width & height
	NSPoint      origin;		// coordinate origins;
};

typedef struct	OpenGLCamera OpenGLCamera;

//---------------------------------------------------------------------------------------

struct OpenGLObjectSpin
{
	GLfloat world[4];
	GLfloat body[4];
	GLfloat trackball[4];
};

typedef struct	OpenGLObjectSpin OpenGLObjectSpin;

//---------------------------------------------------------------------------------------

struct OpenGLObjectTracking
{
	OpenGLObjectSpin  spin;			// 3d object spin states
	NSPoint           startPoint;	// dolly pan start point
};

typedef struct	OpenGLObjectTracking OpenGLObjectTracking;

//---------------------------------------------------------------------------------------

struct OpenGLObjectPhysics
{
	GLfloat spin[3];
	GLfloat velocity[3];
	GLfloat acceleration[3];
};

typedef struct	OpenGLObjectPhysics OpenGLObjectPhysics;

//---------------------------------------------------------------------------------------

struct OpenGLObject
{
	GLfloat               maxRadius;
	OpenGLObjectTracking  tracking;
	OpenGLObjectPhysics   physics;
};

typedef struct	OpenGLObject OpenGLObject;

//---------------------------------------------------------------------------------------

struct OpenGLStates
{
	BOOL mouseIsDown;
	BOOL dolly;
	BOOL pan;
	BOOL trackball;
	BOOL rotate;
};

typedef struct	OpenGLStates OpenGLStates;

//---------------------------------------------------------------------------------------

struct OpenGLInteractionAttributes
{
	OpenGLCamera          camera;
	OpenGLClippingPlanes  planes;
	OpenGLObject          object;
	OpenGLStates          states;
};

typedef struct	OpenGLInteractionAttributes OpenGLInteractionAttributes;

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Constants

//---------------------------------------------------------------------------------------

static const GLuint    kObjectAttributesSize      = sizeof( OpenGLInteractionAttributes );
static const GLfloat   kMaximumVelocity           = 2.0f; 
static const GLdouble  kNearMinTolerance          = 0.00001; 
static const GLdouble  kNearMaxTolerance          = 1.0; 
static const GLdouble  kHalfDegrees2Radians       = M_PI / 360.0; 
static const GLdouble  kCameraApertureScale       = -1.0 / 200.0;
static const GLdouble  kCameraPositionDollyZScale = -1.0 / 300.0;
static const GLdouble  kCameraPositionPanZScale   = -1.0 / 900.0;

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------------------

@implementation OpenGLInteraction

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Initialize OpenGL States

//---------------------------------------------------------------------------------------
//
// sets the camera data to an initial condition
//
//---------------------------------------------------------------------------------------

- (void) initOpenGLCamera
{
	interaction->camera.aperture = 40.0;
	
	interaction->camera.position.x =   0.0;
	interaction->camera.position.y =   0.0;
	interaction->camera.position.z = -10.0;
	
	interaction->camera.direction.x =  0.0; 
	interaction->camera.direction.y =  0.0; 
	interaction->camera.direction.z = 10.0;
	
	interaction->camera.directionUp.x = 0.0; 
	interaction->camera.directionUp.y = 1.0; 
	interaction->camera.directionUp.z = 0.0;
	
	interaction->camera.size.width  = 0.0f;
	interaction->camera.size.height = 0.0f;
	
	interaction->camera.origin.x = 0.0f;
	interaction->camera.origin.y = 0.0f;
} // initOpenGLCamera

//---------------------------------------------------------------------------------------
//
// sets the clipping planes to an initial condition
//
//---------------------------------------------------------------------------------------

- (void) initOpenGLClippingPlanes
{
	interaction->planes.left   = 0.0;
	interaction->planes.right  = 0.0;
	interaction->planes.top    = 0.0;
	interaction->planes.bottom = 0.0;
	interaction->planes.near   = 0.0;
	interaction->planes.far    = 0.0;
} // initOpenGLClippingPlanes

//---------------------------------------------------------------------------------------
//
// Set start values...
//
//---------------------------------------------------------------------------------------

- (void) initOpenGLObjectPhysics
{
	interaction->object.physics.spin[0] = 0.0; 
	interaction->object.physics.spin[1] = 0.0; 
	interaction->object.physics.spin[2] = 0.0;
	
	interaction->object.physics.velocity[0] = 0.3; 
	interaction->object.physics.velocity[1] = 0.1; 
	interaction->object.physics.velocity[2] = 0.2; 
	
	interaction->object.physics.acceleration[0] =  0.003; 
	interaction->object.physics.acceleration[1] = -0.005; 
	interaction->object.physics.acceleration[2] =  0.004;
} // initOpenGLObjectPhysics

//---------------------------------------------------------------------------------------

- (void) initOpenGLObjectTracking
{
	interaction->object.tracking.startPoint.x = 0.0f;
	interaction->object.tracking.startPoint.y = 0.0f;
	
	interaction->object.tracking.spin.world[0] = 0.0f;
	interaction->object.tracking.spin.world[1] = 0.0f;
	interaction->object.tracking.spin.world[2] = 0.0f;
	interaction->object.tracking.spin.world[3] = 0.0f;
	
	interaction->object.tracking.spin.body[0] = 0.0f;
	interaction->object.tracking.spin.body[1] = 0.0f;
	interaction->object.tracking.spin.body[2] = 0.0f;
	interaction->object.tracking.spin.body[3] = 0.0f;
	
	interaction->object.tracking.spin.trackball[0] = 0.0f;
	interaction->object.tracking.spin.trackball[1] = 0.0f;
	interaction->object.tracking.spin.trackball[2] = 0.0f;
	interaction->object.tracking.spin.trackball[3] = 0.0f;
} // initOpenGLObjectTracking

//---------------------------------------------------------------------------------------

- (void) initOpenGLObjectStates
{
	interaction->states.mouseIsDown =  NO;
	interaction->states.dolly       =  NO;
	interaction->states.pan         =  NO;
	interaction->states.trackball   =  NO;
	interaction->states.rotate      =  YES;
} // initOpenGLObjectStates

//---------------------------------------------------------------------------------------

- (void) initOpenGLObjectAttributes
{
	// Object's maximum radius
	
	interaction->object.maxRadius = 7.0f;
	
	// Clipping plane initializations
	
	[self initOpenGLClippingPlanes];
	
	// Object's initial states
	
	[self initOpenGLObjectPhysics];
	
	// Tracking initializations
	
	[self initOpenGLObjectTracking];
	
	// Tracking initial states
	
	[self initOpenGLObjectStates];
	
	// Camera initializations
	
	[self initOpenGLCamera];	
} // initOpenGLObjectAttributes

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Default Initializer

//---------------------------------------------------------------------------------------
//
// Create a GL Context to use - i.e. init the superclass
//
//---------------------------------------------------------------------------------------

- (id) init
{
	self = [super init];
	
	if( self )
	{
		interaction = (OpenGLInteractionAttributesRef)malloc(kObjectAttributesSize);
		
		if( interaction != NULL )
		{
			// View attributes initilizations
			
			[self initOpenGLObjectAttributes];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Interaction - Failure Allocating Memory For Attributes!" );
			NSLog( @">>                             From the default initializer." );
		}  // else
	} // if
	
	return( self );
} // init

//---------------------------------------------------------------------------------------

- (id) initWithData:(NSData *)theData
{
	self = [super init];
	
	if( self )
	{
		interaction = (OpenGLInteractionAttributesRef)malloc(kObjectAttributesSize);
		
		if( interaction != NULL )
		{
			// View attributes initilizations
			
			[theData getBytes:interaction];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Object - Failure Allocating Memory For Attributes!" );
			NSLog( @">>                        From the designated initializer using data." );
		}  // else
	} // if
	
	return( self );
} // initWithData

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Deallocating Resources

//---------------------------------------------------------------------------------------

- (void) dealloc
{
	// View memory container isn't needed
	
	if( interaction != NULL )
	{
		free( interaction );
		
		interaction = NULL;
	} //if
	
	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Scene Accessors

//---------------------------------------------------------------------------------------

- (NSData *) data
{
	return [[[NSData alloc] dataWithBytes:interaction 
								   length:kObjectAttributesSize] autorelease];
} // data

//---------------------------------------------------------------------------------------

- (BOOL) setData:(NSData *)theData
{
	BOOL dataSet = NO;
	
	if( theData )
	{
		[theData getBytes:interaction];
		
		dataSet = YES;
	} // if

	return dataSet;
} // setData

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Rotation Accessors

//---------------------------------------------------------------------------------------

- (BOOL) rotation
{
	return( interaction->states.rotate );
} // rotation

//---------------------------------------------------------------------------------------

- (void) setRotation:(const BOOL)theRotationState
{
	interaction->states.rotate = theRotationState;
} // setRotation

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Updating Scene

//---------------------------------------------------------------------------------------
//
// Update the projection matrix based on camera and object bounds
//
//---------------------------------------------------------------------------------------

- (void) updateClippingPlanes
{
	GLdouble radians   = 0.0;
	GLdouble wd2       = 0.0;
	GLdouble maxRadius = 0.5 * interaction->object.maxRadius;
	GLdouble ratio     = (GLdouble)(interaction->camera.size.width/interaction->camera.size.height);
	
	// set projection
	
	interaction->planes.near = -(maxRadius + interaction->camera.position.z);
	
	if( interaction->planes.near < kNearMinTolerance )
	{
		interaction->planes.near = kNearMinTolerance;
	} // if
	else if( interaction->planes.near < kNearMaxTolerance )
	{
		interaction->planes.near = kNearMaxTolerance;
	} // if
	
	interaction->planes.far = maxRadius - interaction->camera.position.z;
	
	radians = kHalfDegrees2Radians * interaction->camera.aperture;
	wd2     = interaction->planes.near * tan(radians);
	
	if( ratio >= 1.0 ) 
	{
		interaction->planes.left   = -ratio * wd2;
		interaction->planes.right  =  ratio * wd2;
		interaction->planes.top    =  wd2;
		interaction->planes.bottom = -wd2;	
	} // if
	else 
	{
		interaction->planes.left   = -wd2;
		interaction->planes.right  =  wd2;
		interaction->planes.top    =  wd2 / ratio;
		interaction->planes.bottom = -wd2 / ratio;	
	} // else
} // updateClippingPlanes

//---------------------------------------------------------------------------------------

- (void) updateProjection
{
	[self updateClippingPlanes];
	
	glMatrixMode( GL_PROJECTION );
	glLoadIdentity();
	
	glFrustum(interaction->planes.left, 
			  interaction->planes.right, 
			  interaction->planes.bottom, 
			  interaction->planes.top, 
			  interaction->planes.near, 
			  interaction->planes.far );
	
	glMatrixMode( GL_MODELVIEW );
} // updateProjection

//---------------------------------------------------------------------------------------
//
// Updates the contexts model object matrix for object and camera moves
//
//---------------------------------------------------------------------------------------

- (void) updateModelView
{
	// move object
	
	glMatrixMode( GL_MODELVIEW );
	glLoadIdentity();
	
	gluLookAt(interaction->camera.position.x, 
			  interaction->camera.position.y, 
			  interaction->camera.position.z,
			  interaction->camera.position.x + interaction->camera.direction.x,
			  interaction->camera.position.y + interaction->camera.direction.y,
			  interaction->camera.position.z + interaction->camera.direction.z,
			  interaction->camera.directionUp.x, 
			  interaction->camera.directionUp.y,
			  interaction->camera.directionUp.z);
	
	// if we have trackball rotation to map (this is the test one  
	// would want as it can be explicitly 0.0f)
	
	if( interaction->object.tracking.spin.trackball[0] != 0.0f ) 
	{
		glRotatef(interaction->object.tracking.spin.trackball[0], 
				  interaction->object.tracking.spin.trackball[1], 
				  interaction->object.tracking.spin.trackball[2], 
				  interaction->object.tracking.spin.trackball[3]);
	} // if
	
	// accumlated world rotation via trackball
	
	glRotatef(interaction->object.tracking.spin.world[0], 
			  interaction->object.tracking.spin.world[1], 
			  interaction->object.tracking.spin.world[2], 
			  interaction->object.tracking.spin.world[3]);
	
	// object itself rotating applied after camera rotation
	
	glRotatef(interaction->object.tracking.spin.body[0], 
			  interaction->object.tracking.spin.body[1], 
			  interaction->object.tracking.spin.body[2], 
			  interaction->object.tracking.spin.body[3]);
	
	// reset animation rotations (do in all cases to prevent rotating 
	// while moving with trackball)
	
	interaction->object.physics.spin[0] = 0.0f;
	interaction->object.physics.spin[1] = 0.0f;
	interaction->object.physics.spin[2] = 0.0f;
} // updateModelView

//---------------------------------------------------------------------------------------

- (void) updateObjectVelocityAtIndex:(const GLshort)theIndex
								time:(const GLfloat)theTime
{
	interaction->object.physics.velocity[theIndex] += theTime * interaction->object.physics.acceleration[theIndex];
	
	if( interaction->object.physics.velocity[theIndex] > kMaximumVelocity ) 
	{
		interaction->object.physics.acceleration[theIndex] *= -1.0f;
		interaction->object.physics.velocity[theIndex]      =  kMaximumVelocity;
	} // if
	else if( interaction->object.physics.velocity[theIndex] < -kMaximumVelocity ) 
	{
		interaction->object.physics.acceleration[theIndex] *= -1.0f;
		interaction->object.physics.velocity[theIndex]      = -kMaximumVelocity;
	} // else if
} // updateObjectVelocity

//---------------------------------------------------------------------------------------

- (void) updateObjectSpinAtIndex:(const GLshort)theIndex
							time:(const GLfloat)theTime
{
	interaction->object.physics.spin[theIndex] += theTime * interaction->object.physics.velocity[theIndex];
	
	if( interaction->object.physics.spin[theIndex] > 360.0f )
	{
		interaction->object.physics.spin[theIndex] -= 360.0f;
	} // while
	else if( interaction->object.physics.spin[theIndex] < -360.0f )
	{
		interaction->object.physics.spin[theIndex] += 360.0f;
	} // while
} // updateObjectSpin

//---------------------------------------------------------------------------------------

- (void) updateObjectTrackingSpin
{
	GLfloat spin[4] = {0.0f, 0.0f, 0.0f, 0.0f};
	
	spin[0] = interaction->object.physics.spin[0];
	spin[1] = 1.0f;
	
	[self addToRotation:spin 
	   existingRotation:interaction->object.tracking.spin.body];
	
	spin[0] = interaction->object.physics.spin[1];
	spin[1] = 0.0f; 
	spin[2] = 1.0f;
	
	[self addToRotation:spin 
	   existingRotation:interaction->object.tracking.spin.body];
	
	spin[0] = interaction->object.physics.spin[2];
	spin[2] = 0.0f; 
	spin[3] = 1.0f;
	
	[self addToRotation:spin 
	   existingRotation:interaction->object.tracking.spin.body];
} // updateObjectTrackingSpin

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Updating Scene

//---------------------------------------------------------------------------------------
//
// Given a delta time in seconds and current rotation acceleration, velocity and 
// position, update overall object rotation, as well as skip pauses - for values
// that are greater than 10.0.
//
//---------------------------------------------------------------------------------------

- (BOOL) updateRotation:(const CFAbsoluteTime)theTime
{
	BOOL rotationUpdated = NO;

	if( interaction->states.rotate )
	{
		CFAbsoluteTime  timeNow   = CFAbsoluteTimeGetCurrent();
		CFAbsoluteTime  timeDelta = timeNow - theTime;
		
		// Change the state of the object by updating the
		// object's rotation state for the time

		if( timeDelta <= 10.0 )
		{
			if( !interaction->states.mouseIsDown && !interaction->states.trackball )
			{
				GLfloat t = timeDelta * 20.0f;
				GLshort i;
				
				for( i = 0; i < 3; i++ ) 
				{
					[self updateObjectVelocityAtIndex:i 
												 time:t];
					
					[self updateObjectSpinAtIndex:i 
											 time:t];
				} // for
				
				[self updateObjectTrackingSpin];
				
				rotationUpdated = YES;
			} // if
		} // if
	} // if
	
	return rotationUpdated;
} // updateRotation

//---------------------------------------------------------------------------------------
//
// Handles resizing of OpenGL object, if the window dimensions change, window dimensions
// update, viewports reset, and projection matrix update.
//
//---------------------------------------------------------------------------------------

- (BOOL) updateView:(const NSRect *)theBounds
{
	BOOL viewBoundsChanged = NO;
	
	if( ( interaction->camera.size.width  != theBounds->size.width  ) 
	   || ( interaction->camera.size.height != theBounds->size.height ) )
	{
		viewBoundsChanged = YES;
	} // if
	
	GLsizei width  = (GLsizei)theBounds->size.width;
	GLsizei height = (GLsizei)theBounds->size.height;
	
	interaction->camera.size = theBounds->size;
	
	glViewport( 0, 0, width, height );
	
	// Update projection matrix
	
	[self updateProjection];
	
	// update model-view matrix for the 3D object
	
	[self updateModelView];
	
	return viewBoundsChanged;
} // updateView

//---------------------------------------------------------------------------------------

- (BOOL) updateCameraAperture:(const GLdouble)theDelta
{
	BOOL cameraApertureUpdated = NO;
	
	if( theDelta )
	{
		GLdouble deltaAperture = kCameraApertureScale * interaction->camera.aperture * theDelta;
		
		interaction->camera.aperture += deltaAperture;
		
		if( interaction->camera.aperture < 0.1 ) 
		{
			// do not let aperture <= 0.1
			
			interaction->camera.aperture = 0.1;
		} // if
		
		if( interaction->camera.aperture > 179.9 ) 
		{
			// do not let aperture >= 180
			
			interaction->camera.aperture = 179.9;
		} // if
		
		// update projection matrix
		
		[self updateProjection];
		
		cameraApertureUpdated = YES;
	} // if
	
	return cameraApertureUpdated;
} // updateCameraAperture

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Moving Camera in 3D Space

//---------------------------------------------------------------------------------------
//
// Move camera in z axis
//
//---------------------------------------------------------------------------------------

- (void) mouseDolly:(const NSPoint *)theLocation
{
	GLdouble dollyDelta = (GLdouble)(interaction->object.tracking.startPoint.y - theLocation->y);
	GLdouble dolly      = kCameraPositionDollyZScale * interaction->camera.position.z * dollyDelta;
	
	interaction->camera.position.z += dolly;
	
	// do not let z = 0.0
	
	if( interaction->camera.position.z == 0.0 )
	{
		interaction->camera.position.z = 0.0001;
	} // if
	
	interaction->object.tracking.startPoint = *theLocation;
} // mouseDolly

//---------------------------------------------------------------------------------------
//
// Move camera in x/y plane
//
//---------------------------------------------------------------------------------------

- (void) mousePan:(const NSPoint *)theLocation
{
	GLdouble factor = kCameraPositionPanZScale * interaction->camera.position.z;
	
	GLdouble panX = factor * ((GLdouble)(interaction->object.tracking.startPoint.x - theLocation->x));
	GLdouble panY = factor * ((GLdouble)(interaction->object.tracking.startPoint.y - theLocation->y));
	
	interaction->camera.position.x -= panX;
	interaction->camera.position.y -= panY;
	
	interaction->object.tracking.startPoint = *theLocation;
} // mousePan

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Interacting With the Mouse

//---------------------------------------------------------------------------------------
//
// Left Mouse
//
//---------------------------------------------------------------------------------------

- (void) mouseIsDown:(NSPoint *)theLocation
{
	theLocation->y = interaction->camera.size.height - theLocation->y;
	
	interaction->states.dolly     = NO;	// no dolly
	interaction->states.pan       = NO;	// no pan
	interaction->states.trackball = YES;
		
	[self start:theLocation
		 origin:&interaction->camera.origin
		   size:&interaction->camera.size];

	interaction->states.mouseIsDown = YES;
} // mouseIsDownUpdate

//---------------------------------------------------------------------------------------
//
// Pan
//
//---------------------------------------------------------------------------------------

- (void) rightMouseIsDown:(NSPoint *)theLocation
{
	theLocation->y = interaction->camera.size.height - theLocation->y;
	
	if( interaction->states.trackball ) 
	{ 
		// if we are currently tracking, end trackball
		
		if( interaction->object.tracking.spin.trackball[0] != 0.0 )
		{
			[self addToRotation:interaction->object.tracking.spin.trackball 
			   existingRotation:interaction->object.tracking.spin.world];
		} // if
		
		interaction->object.tracking.spin.trackball[0] = 0.0f;
		interaction->object.tracking.spin.trackball[1] = 0.0f;
		interaction->object.tracking.spin.trackball[2] = 0.0f;
		interaction->object.tracking.spin.trackball[3] = 0.0f;
	} // if

	interaction->object.tracking.startPoint = *theLocation;

	interaction->states.dolly       = NO;	// no dolly
	interaction->states.pan         = YES; 
	interaction->states.trackball   = NO;	// no trackball
	interaction->states.mouseIsDown = YES;
} // rightMouseIsDownUpdate

//---------------------------------------------------------------------------------------
//
// Dolly
//
//---------------------------------------------------------------------------------------

- (void) otherMouseIsDown:(NSPoint *)theLocation
{
	theLocation->y = interaction->camera.size.height - theLocation->y;
	
	if( interaction->states.trackball ) 
	{ 
		// if we are currently tracking, end trackball
		
		if( interaction->object.tracking.spin.trackball[0] != 0.0 )
		{
			[self addToRotation:interaction->object.tracking.spin.trackball 
			   existingRotation:interaction->object.tracking.spin.world];
		} // if
		
		interaction->object.tracking.spin.trackball[0] = 0.0f;
		interaction->object.tracking.spin.trackball[1] = 0.0f;
		interaction->object.tracking.spin.trackball[2] = 0.0f;
		interaction->object.tracking.spin.trackball[3] = 0.0f;
	} // if
	
	interaction->object.tracking.startPoint = *theLocation;

	interaction->states.dolly       = YES;
	interaction->states.pan         = NO;	// no pan
	interaction->states.trackball   = NO;	// no trackball
	interaction->states.mouseIsDown = YES;
} // otherMouseIsDownUpdate

//---------------------------------------------------------------------------------------

- (void) mouseIsUp
{
	if( interaction->states.dolly ) 
	{ 
		// end dolly
		
		interaction->states.dolly = NO;
	} // if
	else if( interaction->states.pan ) 
	{ 
		// end pan
		
		interaction->states.pan = NO;
	} // else if
	else if( interaction->states.trackball ) 
	{ 
		// end trackball
		
		interaction->states.trackball = NO;
		
		if( interaction->object.tracking.spin.trackball[0] != 0.0 )
		{
			[self addToRotation:interaction->object.tracking.spin.trackball 
			   existingRotation:interaction->object.tracking.spin.world ];
		} // if
		
		interaction->object.tracking.spin.trackball[0] = 0.0f;
		interaction->object.tracking.spin.trackball[1] = 0.0f;
		interaction->object.tracking.spin.trackball[2] = 0.0f;
		interaction->object.tracking.spin.trackball[3] = 0.0f;
	} // else if
	
	interaction->states.mouseIsDown = NO;
} // mouseIsUp

//---------------------------------------------------------------------------------------

- (void) mouseIsDragged:(NSPoint *)theLocation
{
	theLocation->y = interaction->camera.size.height - theLocation->y;
	
	if( interaction->states.trackball ) 
	{
		[self rollTo:theLocation
			rotation:interaction->object.tracking.spin.trackball]; 
	} // if
	else if( interaction->states.dolly ) 
	{
		[self mouseDolly:theLocation];
		
		// update projection matrix (not normally done on draw)
		
		[self updateProjection];
	} // else if
	else if( interaction->states.pan ) 
	{
		[self mousePan:theLocation];
	} // if
} // mouseIsDragged

//---------------------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

