//---------------------------------------------------------------------------
//
//	File: OpenGLKleinSurface.mm
//
//  Abstract: Klein surface geometry class
//            Based on the work by Philip Rideout 
//            ((C) 2002-2006 3Dlabs Inc.)
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
//  Copyright (c) 2004-2008 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//------------------------------------------------------------------------

//------------------------------------------------------------------------

#include <cmath>

#include "GeometryConstants.h"
#include "Vector3.hpp"

//------------------------------------------------------------------------

//------------------------------------------------------------------------

#import "OpenGLKleinSurface.h"

//------------------------------------------------------------------------

//------------------------------------------------------------------------

static const GLdouble  kEpsilon = 0.00001;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

struct OpenGLKleinVertex
{
	DVector3  p[4];
	DVector3  normal;
}; 

typedef struct OpenGLKleinVertex OpenGLKleinVertex;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

static void KleinSurfaceCompute(DVector2& domain, 
								DVector3& range )
{
	GLdouble u = (1.0 - domain.u) * kTwoPi;
	GLdouble v = domain.v * kTwoPi;

	GLdouble p0 = cos(v);
	GLdouble p1 = cos(v + kPi);
	
	GLdouble q0 = sin(v);
	
	GLdouble r0 = sin(u);
	GLdouble r1 = 8.0 * r0;
	GLdouble r2 = 1.0 + r0;
	
	GLdouble s0 = cos(u);
	GLdouble s1 = 3.0 * s0;
	GLdouble s2 = 2.0 - s0;
	
	GLdouble t0 = s2 * p0;
	GLdouble t1 = s1 * r2;
	
	GLdouble x0 = t1 + t0 * s0;
	GLdouble y0 = r1 + t0 * r0;

	GLdouble x1 = t1 + s2 * p1;
	GLdouble y1 = r1;

	range.x = u < kPi ? x0 : x1;
	range.y = u < kPi ? y0 : y1;
	range.z = s2 * q0;
	
	range = range * 0.1;
	
	range.y = -range.y;

	// Tweak the texture coordinates.
	
	domain.u *= 4.0;
} // KleinSurfaceCompute

//-------------------------------------------------------------------------
//
// Flip the normals along a segment of the Klein bottle so that we don't 
// need two-sided lighting.
//
//-------------------------------------------------------------------------

static inline GLboolean KleinSurfaceFlipNormals(const GLdouble u)
{
	return( u < 0.125 );
} // KleinSurfaceFlipNormals

//-------------------------------------------------------------------------

static void GetKleinSurfaceVertex(const GLboolean flippedKleinSurface, 
								  GLdouble du, 
								  GLdouble dv, 
								  DVector2& domain, 
								  OpenGLKleinVertex& vKlein)
{
	GLdouble  u = domain.u;
	GLdouble  v = domain.v;
	GLdouble  w = u + 0.5 * du;
	
	KleinSurfaceCompute(domain, vKlein.p[0]);
	
	DVector2 z1(w, v);
	
	KleinSurfaceCompute(z1, vKlein.p[1]);
	
	DVector2 z2(w + du, v);
	
	KleinSurfaceCompute(z2, vKlein.p[3]);

	if( flippedKleinSurface ) 
	{
		DVector2 z3(w, v - dv);
		
		KleinSurfaceCompute(z3, vKlein.p[2]);
	}  // if
	else 
	{
		DVector2 z4(w, v + dv);
		
		KleinSurfaceCompute(z4, vKlein.p[2]);
	} // else
} // GetKleinSurfaceVertex

//-------------------------------------------------------------------------

static void SetKleinSurfaceVertexAttributes(OpenGLKleinVertex& vKlein)
{
	GLint  tangentLoc  = -1;
	GLint  binormalLoc = -1;
	
	DVector3 tangent  = vKlein.p[3] - vKlein.p[1];
	DVector3 binormal = vKlein.p[2] - vKlein.p[1];
	
	vKlein.normal = tangent ^ binormal; // Exterior cross product
	
	if( vKlein.normal.magnitude() < kEpsilon )
	{
		vKlein.normal = vKlein.p[0];
	} // if
	
	vKlein.normal.normalize();

	if( tangent.magnitude() < kEpsilon )
	{
		tangent = binormal ^ vKlein.normal; // Exterior cross product
	} // if
	
	tangent.normalize();
	
	glVertexAttrib3dv(tangentLoc, tangent.position().V);

	binormal.normalize();
	
	binormal = -binormal;
	
	glVertexAttrib3dv(binormalLoc, binormal.position().V);
} // SetKleinSurfaceVertexAttributes

//-------------------------------------------------------------------------

static void NewKleinSurfaceVertex(DVector2& domain, 
								  OpenGLKleinVertex& vKlein)
{
	DPosition2 w = domain.position();
	
	glNormal3dv( vKlein.normal.position().V );
	glTexCoord2d( w.s, w.t );
	glVertex3dv( vKlein.p[0].position().V );
} // NewKleinSurfaceVertex

//-------------------------------------------------------------------------
//
// Send out a normal, texture coordinate, vertex coordinate, and an
// optional custom attribute.
//
//-------------------------------------------------------------------------

static void KleinSurfaceGetVertex(const GLboolean flippedKleinSurface, 
								  GLdouble du, 
								  GLdouble dv, 
								  DVector2& domain)
{
	OpenGLKleinVertex vKlein;
	
	GetKleinSurfaceVertex(flippedKleinSurface, du, dv, domain, vKlein);
	SetKleinSurfaceVertexAttributes(vKlein);
	NewKleinSurfaceVertex(domain, vKlein);
} // KleinSurfaceGetVertex

//-------------------------------------------------------------------------

static GLuint KleinSurfaceNewDisplayList(const GLsizei theTessellationFactor)
{
	GLuint  displayList;
	GLint   stacks = theTessellationFactor / 2;

	GLdouble u;
	GLdouble v;
	
	GLdouble du = 1.0 / (GLdouble)theTessellationFactor;
	GLdouble dv = 1.0 / (GLdouble)stacks;
	
	GLdouble uMax = 1.0 - 0.5 * du;
	GLdouble vMax = 1.0 + 0.5 * dv;
	
	GLboolean flippedKleinSurface = GL_FALSE;

	displayList = glGenLists(1);
	
	glNewList(displayList, GL_COMPILE);
	
		for( u = 0.0; u < uMax; u += du ) 
		{
			glBegin(GL_QUAD_STRIP);
			
				flippedKleinSurface = KleinSurfaceFlipNormals(u);
								
				if(  KleinSurfaceFlipNormals(u) )
				{
					for( v = 0.0; v < vMax; v += dv ) 
					{
						DVector2 domain1(u + du, v);
						DVector2 domain2(u, v);
		
						KleinSurfaceGetVertex(flippedKleinSurface, du, dv, domain1);
						KleinSurfaceGetVertex(flippedKleinSurface, du, dv, domain2);
					} // for
				} // if
				else 
				{
					for( v = 0.0; v < vMax; v += dv ) 
					{
						DVector2 domain1(u, v);
						DVector2 domain2(u + du, v);
		
						KleinSurfaceGetVertex(flippedKleinSurface, du, dv, domain1);
						KleinSurfaceGetVertex(flippedKleinSurface, du, dv, domain2);
					} // for
				} // else
				
			glEnd();
		} // for 

	glEndList();
	
	return displayList;
} // KleinSurfaceNewDisplayList

//-------------------------------------------------------------------------

//------------------------------------------------------------------------

@implementation OpenGLKleinSurface

//------------------------------------------------------------------------

- (id) initOpenGLKleinSurfaceWithTessellationFactor:(const GLsizei)theTessellationFactor
{
	self = [super init];
	
	if( self )
	{
		displayList = KleinSurfaceNewDisplayList(theTessellationFactor);
	} // if
	
	return self;
} // init

//------------------------------------------------------------------------

- (void) dealloc 
{
	// delete the last used display list
	
	if( displayList )
	{
		glDeleteLists( displayList, 1 );
	} // if
	
	[super dealloc];
} // dealloc

//------------------------------------------------------------------------

- (GLuint) displayList
{
	return displayList;
} // displayList

//------------------------------------------------------------------------

- (void) callList
{
	glCallList( displayList );
} // callList

//------------------------------------------------------------------------

@end

//------------------------------------------------------------------------

//------------------------------------------------------------------------
