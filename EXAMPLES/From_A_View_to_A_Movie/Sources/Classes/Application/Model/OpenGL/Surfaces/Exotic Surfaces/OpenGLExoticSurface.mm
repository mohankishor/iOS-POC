//---------------------------------------------------------------------------
//
//	File: OpenGLExoticSurface.mm
//
//  Abstract: Exotic surface geometry class
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
//
// Uses techniques described by Paul Bourke 1999 - 2002
// Tranguloid Trefoil and other example surfaces by Roger Bagula 
// see <http://astronomy.swin.edu.au/~pbourke/surfaces/> 
//
//---------------------------------------------------------------------------

//------------------------------------------------------------------------

//------------------------------------------------------------------------

#include <cmath>
#include <vector>

//------------------------------------------------------------------------

#include "Vector3.hpp"

//------------------------------------------------------------------------

#import "GeometryConstants.h"
#import "OpenGLExoticSurface.h"

//------------------------------------------------------------------------

//------------------------------------------------------------------------

typedef void (*ComputeSurfaceFuncPtr)(GLdouble u,
									  GLdouble v,
									  DPosition3 *p);

//------------------------------------------------------------------------

//------------------------------------------------------------------------

struct OpenGLExoticSurfaceVertex
{
	DPosition3  positions;
	DPosition3  normals;
	DPosition2  texCoords;
}; 

typedef struct	OpenGLExoticSurfaceVertex OpenGLExoticSurfaceVertex;

//------------------------------------------------------------------------

typedef std::vector<OpenGLExoticSurfaceVertex>  OpenGLExoticSurfaceVertices;

//------------------------------------------------------------------------

struct OpenGLExoticSurfaceGeometry
{
	GLint  rows;
	GLint  columns;
	
	OpenGLExoticSurfaceVertices  vertices;
}; 

typedef struct	OpenGLExoticSurfaceGeometry OpenGLExoticSurfaceGeometry;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

static DPosition3 ComputeNormals(const DPosition3 *p, 
								 const DPosition3 *q, 
								 const DPosition3 *r)
{
	DPosition3 normalPos;
	
	DVector3 u(p);
	DVector3 v(q);
	DVector3 w(r);
		
	DVector3 n = u.normals( v, w );
	
	normalPos = n.position();

	return normalPos;
} // ComputeNormals

//------------------------------------------------------------------------
//
// Note that -Pi <= u <= Pi and -Pi <= v <= Pi
//
//------------------------------------------------------------------------

static void TranguloidTrefoilExoticSurface(GLdouble u, 
										   GLdouble v, 
										   DPosition3  *p)
{
	GLdouble  t = v + kTwoPiThird;
	GLdouble  w = 2.0 * u;
	GLdouble  A = 2.0 + cos(t);
	GLdouble  B = 2.0 + cos(v);
	
	p->x = 2.0  * sin(3.0 * u) / B;
	p->y = 2.0  * (sin(u) + 2.0 * sin(w)) / A;
	p->z = 0.25 * (cos(u) - 2.0 * cos(w)) * A * B;
} // TranguloidTrefoilExoticSurface

//------------------------------------------------------------------------

static void TriaxialTritorusExoticSurface(GLdouble u, 
										  GLdouble v, 
										  DPosition3  *p)
{
	p->x = 2.0 * sin(u) * (1 + cos(v));
	p->y = 2.0 * sin(u + kTwoPiThird) * (1 + cos(v + kTwoPiThird));
	p->z = 2.0 * sin(u + kFourPiThird) * (1 + cos(v + kFourPiThird));
} // TriaxialTritorusExoticSurface

//------------------------------------------------------------------------

static void StilettoExoticSurface(GLdouble u, 
								  GLdouble v, 
								  DPosition3  *p)
{
	// reverse u and v for better distribution or points

	GLdouble s = u;
	GLdouble t = 0.0;
	GLdouble w = 0.0;
	
	u = v + kPi; 
	v = 0.5 * (s + kPi); // convert to: 0 <= u <= 2 kPi, 0 <= v <= 2 kPi
	w = v + kTwoPiThird;

	t = pow(sin(w),2) * pow(cos(w),2);
	
	p->x =  4.0 * (2.0 + cos(u)) * pow(cos(v), 3) * sin(v);
	p->y =  4.0 * (2.0 + cos(u + kTwoPiThird)) * t;
	p->z = -4.0 * (2.0 + cos(u - kTwoPiThird)) * t;
} // StilettoExoticSurface

//------------------------------------------------------------------------

static void SlippersExoticSurface(GLdouble u, 
								  GLdouble v, 
								  DPosition3  *p)
{
	GLdouble w = u;
	GLdouble s = 0.0;
	GLdouble t = 0.0;
	
	u = v + kTwoPi; 
	v = w + kPi; // convert to: 0 <= u <= 4 kPi, 0 <= v <= 2 kPi 

	s = kTwoPiThird + v;
	t = kTwoPiThird - v;
	
	p->x =  4.0 * (2.0 + cos(u)) * pow(cos(v), 3) * sin(v);
	p->y =  4.0 * (2.0 + cos(u + kTwoPiThird)) * pow(cos(s), 2) * pow(sin(s), 2);
	p->z = -4.0 * (2.0 + cos(u - kTwoPiThird)) * pow(cos(t), 2) * pow(sin(t), 3);
} // SlippersExoticSurface

//------------------------------------------------------------------------

static void MaedersOwlExoticSurface(GLdouble u, 
									GLdouble v, 
									DPosition3  *p)
{
	GLdouble t = 0.0;
	GLdouble r = 0.0;
	GLdouble s = 0.0;

	u = 2.0 * (u + kPi); 
	v = kTwoPiInv * (v + kPi); // convert to: 0 <= u <= 4 kPi, 0 <= v <= 1 
	
	t = 2.0 * u;
	r = 0.5 * v * v;
	s = 3.0 * v;
	
	p->x =  s * cos(u) - r * cos(t);
	p->y = -s * sin(u) - r * sin(t);
	p->z =  4.0 * pow(v,1.5) * cos(1.5*u);
} // MaedersOwlExoticSurface

//------------------------------------------------------------------------

static void DefaultExoticSurface(GLdouble u, 
								 GLdouble v, 
								 DPosition3  *p)
{
	p->x = 0.0;
	p->y = 0.0;
	p->z = 0.0;
} // DefaultExoticSurface

//------------------------------------------------------------------------
//
// From a surface type, get a function pointer for computing parametric
// values for a specific surface.
//
//------------------------------------------------------------------------

static ComputeSurfaceFuncPtr GetComputeSurfaceFunctionPtr(const OpenGLExoticSurfaceType surfaceType)
{
	ComputeSurfaceFuncPtr computeSurfaceFuncPtr = NULL;
	
	switch( surfaceType )
	{
		case kTranguloidTrefoil:
			computeSurfaceFuncPtr = &TranguloidTrefoilExoticSurface;
			break;
			
		case kTriaxialTritorus:
			computeSurfaceFuncPtr = &TriaxialTritorusExoticSurface;
			break;
		
		case kStilettoSurface:
			computeSurfaceFuncPtr = &StilettoExoticSurface;
			break;
		
		case kSlipperSurface:
			computeSurfaceFuncPtr = &SlippersExoticSurface;
			break;
		
		case kMaedersOwlSurface:
			computeSurfaceFuncPtr = &MaedersOwlExoticSurface;
			break;
		
		case kDefaultSurface:
		default:
			computeSurfaceFuncPtr = &DefaultExoticSurface;
			break;
	} // switch
	
	return computeSurfaceFuncPtr;
} // GetComputeSurfaceFunctionPtr

//------------------------------------------------------------------------

static void NewExoticSurface(const OpenGLExoticSurfaceType surfaceType, 
							 OpenGLExoticSurfaceGeometry *geometry)
{
	GLint       i;
	GLint       j;
	GLint       maxI    = geometry->rows;
	GLint       maxJ    = geometry->columns;
	GLdouble    invMaxI = 1.0 / (GLdouble)maxI;
	GLdouble    invMaxJ = 1.0 / (GLdouble)maxJ;
	GLdouble    u[2]    = { 0.0, 0.0 };
	GLdouble    delta   = 0.0005;
	DPosition3  position[2];
	
	OpenGLExoticSurfaceVertex  vertex;
	
	ComputeSurfaceFuncPtr computeSurfaceFuncPtr = GetComputeSurfaceFunctionPtr( surfaceType );
		
	for( i = 0; i < maxI; i++ ) 
	{
		for( j = 0; j < maxJ; j++ ) 
		{
			u[0] = kTwoPi * (i % maxI) * invMaxI - kPi;
			u[1] = kTwoPi * (j % maxJ) * invMaxJ - kPi ;
			
			computeSurfaceFuncPtr(u[0], u[1], &vertex.positions);
			
			computeSurfaceFuncPtr(u[0] + delta, u[1], &position[0]);
			computeSurfaceFuncPtr(u[0], u[1] + delta, &position[1]);
			
			vertex.normals = ComputeNormals(&vertex.positions, &position[0], &position[1]);
			
			vertex.texCoords.s = (GLdouble)i * invMaxI * 5.0;
			vertex.texCoords.t = (GLdouble)j * invMaxJ;
			
			geometry->vertices.push_back(vertex);
		} // for
	} // for
} // NewExoticSurface

//------------------------------------------------------------------------

static void BuildVertex(const GLint index, 
						OpenGLExoticSurfaceGeometry *geometry)
{
	glNormal3dv(geometry->vertices[index].normals.V);
	glTexCoord2dv(geometry->vertices[index].texCoords.V);
	glVertex3dv(geometry->vertices[index].positions.V);
} // BuildVertex

//------------------------------------------------------------------------

static GLuint NewExoticSurfaceDisplayList(OpenGLExoticSurfaceGeometry *geometry)
{
	GLint   i;
	GLint   j;
	GLint   k;
	GLint   l;
	GLint   m;
	GLint   maxI = geometry->rows;
	GLint   maxJ = geometry->columns;
	GLuint  displayList;
	
	displayList = glGenLists(1);
	
	glNewList(displayList, GL_COMPILE);
	
		for( i = 0; i < maxI; i++ ) 
		{
			glBegin(GL_TRIANGLE_STRIP);
			
				for( j = 0; j <= maxJ; j++ ) 
				{
					m = j % maxJ;
					
					k = (i % maxI) * maxJ + m;

					BuildVertex(k, geometry);
		
					l = ((i + 1) % maxI) * maxJ + m;

					BuildVertex(l, geometry);
				} // for
			
			glEnd();
		} // for
		
	glEndList();
	
	return displayList;
} // NewExoticSurfaceDisplayList

//------------------------------------------------------------------------

static GLuint GetExoticSurfaceDisplayList(const OpenGLExoticSurfaceType surfaceType, 
										  const GLuint subdivisions, 
										  const GLuint xyRatio)
{
	OpenGLExoticSurfaceGeometry  geometry;

	geometry.rows    = subdivisions * xyRatio;  
	geometry.columns = subdivisions;  
		
	// Build surface

	NewExoticSurface(surfaceType, &geometry);
		
	// Now get the display list

	GLuint displayList = NewExoticSurfaceDisplayList(&geometry);
	
	return displayList;
} // GetExoticSurfaceDisplayList

//------------------------------------------------------------------------

//------------------------------------------------------------------------

@implementation OpenGLExoticSurface

//------------------------------------------------------------------------

//------------------------------------------------------------------------

- (id) initOpenGLExoticSurfaceWithType:(const OpenGLExoticSurfaceType)theSurfaceType
						  subdivisions:(const GLuint)theSubdivisions 
								 ratio:(const GLuint)theRatio
{
	self = [super init];
	
	if( self )
	{
		displayList = GetExoticSurfaceDisplayList(theSurfaceType,
												  theSubdivisions, 
												  theRatio);
	} // if
	
	return self;
} // initOpenGLExoticSurface

//------------------------------------------------------------------------

- (void) dealloc 
{
	// delete the last used display list
	
	if( displayList )
	{
		glDeleteLists(displayList, 1);
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
