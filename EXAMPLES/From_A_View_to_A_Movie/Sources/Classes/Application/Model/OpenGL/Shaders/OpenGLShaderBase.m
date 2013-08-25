//------------------------------------------------------------------------------//
//	File: OpenGLShaderBase.m
//
//  Abstract: Utility toolkit for fragement and vertex shaders
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
//  Copyright (c) 2007-2009 Apple Inc., All rights reserved.
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

#import "OpenGLShaderBase.h"

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structure

//------------------------------------------------------------------------------

struct OpenGLShaderAttributes
{
	const GLcharARB    *fragmentShaderSource;	// the GLSL source for our fragment Shader
	const GLcharARB    *vertexShaderSource;		// the GLSL source for our vertex Shader
	GLhandleARB		    programObject;			// the program object
};

typedef struct OpenGLShaderAttributes   OpenGLShaderAttributes;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

#pragma mark -
#pragma mark Compiling, linking and validating

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

static GLhandleARB CompileShader(GLenum theShaderType, 
								 const GLcharARB **theShader, 
								 GLint *theShaderCompiled) 
{
	GLhandleARB shaderObject = NULL;
	
	if( *theShader != NULL ) 
	{
		GLint infoLogLength = 0;
		
		shaderObject = glCreateShaderObjectARB(theShaderType);
		
		glShaderSourceARB(shaderObject, 1, theShader, NULL);
		glCompileShaderARB(shaderObject);
		
		glGetObjectParameterivARB(shaderObject, 
								  GL_OBJECT_INFO_LOG_LENGTH_ARB, 
								  &infoLogLength);
		
		if( infoLogLength > 0 ) 
		{
			GLcharARB *infoLog = (GLcharARB *)malloc(infoLogLength);
			
			if( infoLog != NULL )
			{
				glGetInfoLogARB(shaderObject, 
								infoLogLength, 
								&infoLogLength, 
								infoLog);
				
				NSLog(@">> INFO: OpenGL Shader Base - Shader compile log:\n%s\n", infoLog);
				
				free(infoLog);
			} // if
		} // if

		glGetObjectParameterivARB(shaderObject, 
								  GL_OBJECT_COMPILE_STATUS_ARB, 
								  theShaderCompiled);
		
		if( *theShaderCompiled == 0 )
		{
			NSLog(@">> WARNING: OpenGL Shader Base - Failed to compile shader!\n%s\n", theShader);
		} // if
	} // if
	else 
	{
		*theShaderCompiled = 0;
	} // else
	
	return shaderObject;
} // CompileShader

//------------------------------------------------------------------------------

static BOOL LinkProgram(GLhandleARB programObject) 
{
	GLint  infoLogLength = 0;
	GLint  programLinked = 0;
	BOOL   linkSuccess   = NO;
	
	glLinkProgramARB(programObject);
	
	glGetObjectParameterivARB(programObject, 
							  GL_OBJECT_INFO_LOG_LENGTH_ARB, 
							  &infoLogLength);
	
	if( infoLogLength >  0 ) 
	{
		GLcharARB *infoLog = (GLcharARB *)malloc(infoLogLength);
		
		if( infoLog != NULL )
		{
			glGetInfoLogARB(programObject, 
							infoLogLength, 
							&infoLogLength, 
							infoLog);
			
			NSLog(@">> INFO: OpenGL Shader Base - Program link log:\n%s\n", infoLog);
			
			free(infoLog);
		} // if
	} // if
	
	glGetObjectParameterivARB(programObject, 
							  GL_OBJECT_LINK_STATUS_ARB,
							  &programLinked);
	
	if( programLinked == 0 )
	{
		NSLog(@">> WARNING: OpenGL Shader Base - Failed to link program 0x%lx\n", &programObject);
	} // if
	else
	{
		linkSuccess = YES;
	} // else
	
	return  linkSuccess;
} // LinkProgram

//------------------------------------------------------------------------------

static GLhandleARB GetShader(GLenum theShaderType, 
							 OpenGLShaderAttributesRef theShaderAttributes)
{
	GLhandleARB  shaderHandle   = NULL;
	GLint        shaderCompiled = GL_FALSE;
		
	switch( theShaderType )
	{
		case GL_VERTEX_SHADER:
			
			shaderHandle = CompileShader(theShaderType, 
										 &theShaderAttributes->vertexShaderSource, 
										 &shaderCompiled);
			break;
			
		case GL_FRAGMENT_SHADER:
		
		default:
			
			shaderHandle = CompileShader(theShaderType, 
										 &theShaderAttributes->fragmentShaderSource, 
										 &shaderCompiled);
			break;
	} // switch
			
	if( !shaderCompiled ) 
	{
		if ( shaderHandle ) 
		{
			glDeleteObjectARB(shaderHandle);
			shaderHandle = NULL;
		} // if
	} // if
	
	return shaderHandle;
} // GetShader

//------------------------------------------------------------------------------

static GLhandleARB NewProgramObject(GLhandleARB theVertexShader, 
									GLhandleARB theFragmentShader)
{
	GLhandleARB programObject = NULL;
	
	// Create a program object and link shaders
	
	if( ( theVertexShader != NULL ) || ( theFragmentShader != NULL ) )
	{
		programObject = glCreateProgramObjectARB();
		
		if( programObject != NULL )
		{
			BOOL fragmentShaderAttached = NO;
			BOOL vertexShaderAttached   = NO;
			BOOL programObjectLinked    = NO;
			
			if( theVertexShader != NULL )
			{
				vertexShaderAttached = YES;
				
				glAttachObjectARB(programObject, theVertexShader);
				glDeleteObjectARB(theVertexShader);   // Release
				
				theVertexShader = NULL;
			} // if
			
			if( theFragmentShader != NULL )
			{
				fragmentShaderAttached = YES;
				
				glAttachObjectARB(programObject, theFragmentShader);
				glDeleteObjectARB(theFragmentShader); // Release
				
				theFragmentShader = NULL;
			} // if
			
			if( vertexShaderAttached || fragmentShaderAttached )
			{
				programObjectLinked = LinkProgram(programObject);

				if( !programObjectLinked ) 
				{
					glDeleteObjectARB(programObject);
					
					programObject = NULL;
				} // if
			} // if
		} // if
	} // if
	
	return programObject;
} // NewProgramObject

//------------------------------------------------------------------------------

static BOOL GetProgramObject(OpenGLShaderAttributesRef theShaderAttributes)
{
	BOOL  newProgramObject = NO;
	
	// Load and compile both shaders
	
	GLhandleARB vertexShader = GetShader(GL_VERTEX_SHADER, 
										 theShaderAttributes);
	
	GLhandleARB fragmentShader = GetShader(GL_FRAGMENT_SHADER, 
										   theShaderAttributes);
	
	// Create a program object and link both shaders
			
	theShaderAttributes->programObject = NewProgramObject(vertexShader, 
														  fragmentShader);
	
	if( theShaderAttributes->programObject != NULL )
	{
		newProgramObject = YES;
	} // if
	
	return  newProgramObject;
} // GetProgramObject

//------------------------------------------------------------------------------

static BOOL ValidateProgramObject(OpenGLShaderAttributesRef theShaderAttributes)
{
	BOOL  programObjectValidated = YES;
	GLint validateStatusSuccess;

	glValidateProgramARB(theShaderAttributes->programObject);
	
	glGetObjectParameterivARB(theShaderAttributes->programObject, 
							  GL_VALIDATE_STATUS, 
							  &validateStatusSuccess);
	
	if( !validateStatusSuccess )
	{
		GLint  infoLogLength = 0;
		
		glGetObjectParameterivARB(theShaderAttributes->programObject , 
								  GL_OBJECT_INFO_LOG_LENGTH_ARB, 
								  &infoLogLength);
		
		if( infoLogLength >  0 ) 
		{
			GLcharARB *infoLog = (GLcharARB *)malloc(infoLogLength);
			
			if( infoLog != NULL )
			{
				glGetInfoLogARB(theShaderAttributes->programObject, 
								infoLogLength, 
								&infoLogLength, 
								infoLog);				

				NSLog(@">> ERROR: OpenGL Shader Base - Validating program object!\n%s\n", infoLog);
				
				free( infoLog );
			} // if
		} // if
		
		programObjectValidated = NO;
	} // if
	
	return  programObjectValidated;
} // ValidateProgramObject

//------------------------------------------------------------------------------

static GLint GetUniformLocation(GLhandleARB theProgramObject, 
								const GLcharARB *theUniformName)
{
	GLint uniformLoacation = glGetUniformLocationARB(theProgramObject, theUniformName);
	
	if( uniformLoacation == -1 ) 
	{
		NSLog( @">> WARNING: OpenGL Shader Base - No such uniform named \"%s\"!", theUniformName );
	} // if

	return uniformLoacation;
} // getUniformLocation

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

@implementation OpenGLShaderBase

//------------------------------------------------------------------------------

#pragma mark -
#pragma mark Get shaders from resource

//------------------------------------------------------------------------------

- (GLcharARB *) getShaderSourceFromResource:(NSString *)theShaderResourceName 
								  extension:(NSString *)theExtension
{
	NSBundle  *appBundle      = [NSBundle mainBundle];
	NSString  *shaderPathname = [appBundle pathForResource:theShaderResourceName 
													ofType:theExtension];
	
	NSString *shaderString = [NSString stringWithContentsOfFile:shaderPathname 
													   encoding:NSUTF8StringEncoding 
														  error:NULL];
	
	GLcharARB *shaderSource = (GLcharARB *)[shaderString cStringUsingEncoding:NSUTF8StringEncoding];
	
	return  shaderSource;
} // getShaderSourceFromResource

//------------------------------------------------------------------------------

- (void) getFragmentShaderSourceFromResource:(NSString *)theFragmentShaderResourceName
{
	shaderAttribs->fragmentShaderSource 
		= [self getShaderSourceFromResource:theFragmentShaderResourceName 
								  extension:@"fs" ];
} // getFragmentShaderSourceFromResource

//------------------------------------------------------------------------------

- (void) getVertexShaderSourceFromResource:(NSString *)theVertexShaderResourceName
{
	shaderAttribs->vertexShaderSource 
		= [self getShaderSourceFromResource:theVertexShaderResourceName 
								  extension:@"vs" ];
} // getVertexShaderSourceFromResource

//------------------------------------------------------------------------------

- (BOOL) getProgramObject:(NSString *)theShadersName
				 validate:(const BOOL)theShaderNeedsValidation
{
	BOOL  gotProgramObject       = NO;
	BOOL  validatedProgramObject = NO;
	BOOL  shaderIsValid          = NO;

	gotProgramObject = GetProgramObject(shaderAttribs);
	
	if( !gotProgramObject )
	{
		NSLog(@">> WARNING: OpenGL Shader Base - Failed to compile+link GLSL \"%@\" fragment and/or vertex shader(s)!", theShadersName);
	} // if
	else
	{
		if( theShaderNeedsValidation )
		{
			validatedProgramObject = ValidateProgramObject(shaderAttribs);
			
			if( !validatedProgramObject )
			{
				NSLog(@">> WARNING: OpenGL Shader Base - Failed to validate the program object!");
			} // if
			
			shaderIsValid = gotProgramObject && validatedProgramObject;
		} // if
		else
		{
			shaderIsValid = gotProgramObject;
		} // else
	} // else
	
	return ( shaderIsValid );
} // getProgramObject

//------------------------------------------------------------------------------

- (BOOL) getProgramObjectWithShadersName:(NSString *)theShadersName
								validate:(const BOOL)theShaderNeedsValidation
{
	[self getVertexShaderSourceFromResource:theShadersName];
	[self getFragmentShaderSourceFromResource:theShadersName];

	BOOL shadersReadyToUse = [self getProgramObject:theShadersName
										   validate:theShaderNeedsValidation];
	
	return shadersReadyToUse;
} // getProgramObjectWithShadersName

//------------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated initializer

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

//------------------------------------------------------------------------------

- (id) initWithOpenGLShadersInAppBundle:(NSString *)theShadersName
							   validate:(const BOOL)theShaderNeedsValidation
{
	self = [super init];
	
	if( self )
	{
		shaderAttribs = (OpenGLShaderAttributesRef)malloc(sizeof(OpenGLShaderAttributes));
		
		if( shaderAttribs != NULL )
		{
			if( ![self getProgramObjectWithShadersName:theShadersName  
											  validate:theShaderNeedsValidation] )
			{
				NSLog( @">> ERROR: OpenGL Shader Base - Failed to generate a program object with the \"%@\" shader",theShadersName );
			} // if
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Shader Base - Failure Allocating Memory For Attributes!" );
		} // else
	} // self
	
	return self;
} // initWithOpenGLShadersInAppBundle

//------------------------------------------------------------------------------

#pragma mark -
#pragma mark Deallocating Resources

//------------------------------------------------------------------------------

- (void) cleanUpShadertBase
{
	if( shaderAttribs != NULL )
	{
		if( shaderAttribs->programObject != NULL )
		{
			glDeleteObjectARB(shaderAttribs->programObject);
		} // if
		
		free( shaderAttribs );
		
		shaderAttribs = NULL;
	} // if
} // cleanUpShadertBase

//------------------------------------------------------------------------------

- (void) dealloc
{
	[self cleanUpShadertBase];
	
	[super dealloc];
} // dealloc

//------------------------------------------------------------------------------

#pragma mark -
#pragma mark Accessors

//------------------------------------------------------------------------------

- (GLhandleARB) programObject
{
	return( shaderAttribs->programObject );
} // programObject

//------------------------------------------------------------------------------

#pragma mark -
#pragma mark Utilities

//------------------------------------------------------------------------------

- (void) enable
{
	glUseProgramObjectARB( shaderAttribs->programObject );
} // enable

//------------------------------------------------------------------------------

- (void) disable
{
	glUseProgramObjectARB( NULL );
} // disable

//------------------------------------------------------------------------------

- (GLint) uniformLocation:(NSString *)theUniformName
{
	GLint uniformLoacation = -1;
	
	if( theUniformName )
	{
		const GLcharARB *uniformName = (GLcharARB *)[theUniformName cStringUsingEncoding:NSASCIIStringEncoding];
		
		uniformLoacation = GetUniformLocation(shaderAttribs->programObject, 
											  uniformName );
	} // if
	
	return uniformLoacation;
} // uniformLocation

//------------------------------------------------------------------------------

@end

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

