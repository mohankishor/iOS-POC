//---------------------------------------------------------------------------
//
//	File: QTMediaSampleDescription.m
//
//  Abstract: Base utility toolkit for creating core data types associated
//            with a movie description
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
//  Copyright (c) 2009 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#import "OpenGLTextureSourceTypes.h"
#import "QTMediaSampleDescription.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Macro Constants

//---------------------------------------------------------------------------

#define DEFAULT_SCALE	600		// Default time scale to produce 1 FPS generated movies.
#define DEFAULT_FPS		30		// Default FPS to produce 29.97 FPS generated movies.

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Constants

//---------------------------------------------------------------------------

static const int kDefaultFlag = 0;

//---------------------------------------------------------------------------
//
// Default frame duration to produce 1 FPS generated movies.
//
//---------------------------------------------------------------------------

static const TimeValue kDefaultFrameDuration = DEFAULT_SCALE / DEFAULT_FPS;

//---------------------------------------------------------------------------
//
// Defines how a chroma subsampled YCbCr buffer was created.
//
// In the case where the chroma location information is also stored in the 
// encoded bitstream (e.g., H.264), the information returned by the codec 
// takes precedence.
//
//---------------------------------------------------------------------------
//
// Chroma Location Image Description Extension, Read/Write
//
//---------------------------------------------------------------------------

static const OSType kICMImageDescriptionPropertyIDChromaLocation = 'chrm';

//---------------------------------------------------------------------------

static const OSType kQTMoviePlayerCreator = 'TVOD';

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structure

//---------------------------------------------------------------------------

struct QTMediaSampleDescriptionAttributes
{
	BOOL                    mediaSampleAdded;
	short                   trackVolume;
	short                   sampleFlags;
	unsigned long           sampleWidth;
	unsigned long           sampleHeight;
	unsigned long           sampleSize;
	unsigned long           numberOfSamples;
	CFStringRef             path;
	CFURLRef                url;
	OSType                  mediaType;
	OSType                  dataRefType;
	OSErr                   err;
	Handle                  dataRef;
	Movie                   movie;
	Track	                track;
	Media	                media;
	DataReferenceRecord     outputDataRef;
	ComponentInstance	    outputDataHandler;
	ImageDescriptionHandle  hImage;
	TimeScale               scale;
	TimeValue               sampleTime;
	TimeValue               durationPerSample;
}; // QTMediaSampleDescriptionAttributes

typedef struct QTMediaSampleDescriptionAttributes   QTMediaSampleDescriptionAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Create Media Sample

//---------------------------------------------------------------------------
//
// Image initializations
//
//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionInitImageAttribs(const NSSize *size,
													  QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	mediaSampleDescAttribs->sampleWidth  = (long)size->width;
	mediaSampleDescAttribs->sampleHeight = (long)size->height;
	mediaSampleDescAttribs->sampleSize   = kTextureMaxSPP * mediaSampleDescAttribs->sampleWidth * mediaSampleDescAttribs->sampleHeight;
	
	return( mediaSampleDescAttribs->sampleSize > 0 );
} // QTMediaDescriptionInitImageAttribs

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionFileCreateWithSystemPath(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	mediaSampleDescAttribs->url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, 
																mediaSampleDescAttribs->path, 
																kCFURLPOSIXPathStyle, 
																NO);
	
	return( mediaSampleDescAttribs->url != NULL );
} // QTMediaDescriptionFileCreateWithSystemPath

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionCreateDataRefFromFile(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	UInt32 flags = 0;
	
	mediaSampleDescAttribs->err = QTNewDataReferenceFromCFURL(mediaSampleDescAttribs->url, 
															  flags, 
															  &mediaSampleDescAttribs->outputDataRef.dataRef, 
															  &mediaSampleDescAttribs->outputDataRef.dataRefType); 
	
	return( mediaSampleDescAttribs->err == noErr );
} // QTMediaDescriptionCreateDataRefFromFile

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionCreateMovieStorage(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	mediaSampleDescAttribs->err = CreateMovieStorage(mediaSampleDescAttribs->outputDataRef.dataRef, 
													 mediaSampleDescAttribs->outputDataRef.dataRefType, 
													 kQTMoviePlayerCreator, 
													 smCurrentScript, 
													 createMovieFileDeleteCurFile | createMovieFileDontCreateResFile, 
													 &mediaSampleDescAttribs->outputDataHandler, 
													 &mediaSampleDescAttribs->movie);
	
	return( mediaSampleDescAttribs->err == noErr );
} // QTMediaDescriptionCreateMovieStorage

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionCreateImageHandle(const NSSize *size,
													   QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	BOOL hImgDescIsValid = NO;
	
	mediaSampleDescAttribs->hImage = (ImageDescriptionHandle)NewHandleClear(sizeof(ImageDescription));
	
	hImgDescIsValid =  ( mediaSampleDescAttribs->hImage != NULL ) && ( *mediaSampleDescAttribs->hImage != NULL );
	
	if( hImgDescIsValid )
	{
		HLock((Handle)mediaSampleDescAttribs->hImage);
		
		(*mediaSampleDescAttribs->hImage)->cType          = k32BGRAPixelFormat;			// From QuickDraw Types
		(*mediaSampleDescAttribs->hImage)->width          = (short)size->width;
		(*mediaSampleDescAttribs->hImage)->height         = (short)size->height;
		(*mediaSampleDescAttribs->hImage)->idSize         = sizeof(ImageDescription);
		(*mediaSampleDescAttribs->hImage)->spatialQuality = codecLosslessQuality;
		(*mediaSampleDescAttribs->hImage)->hRes           = 72 << 16;								
		(*mediaSampleDescAttribs->hImage)->vRes           = 72 << 16;								
		(*mediaSampleDescAttribs->hImage)->depth          = 32;									
		(*mediaSampleDescAttribs->hImage)->clutID         = -1;	
		
		HUnlock((Handle)mediaSampleDescAttribs->hImage);
	} // if
	
	return( hImgDescIsValid );
} // QTMediaDescriptionCreateImageHandle

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionSetNCLCColorInfo(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	// Set the primaries, matrix, and transfer function
	
	NCLCColorInfoImageDescriptionExtension nclc;
	
	nclc.colorParamType   = kVideoColorInfoImageDescriptionExtensionType;
	nclc.primaries        = kQTPrimaries_ITU_R709_2;				
	nclc.transferFunction = kQTTransferFunction_ITU_R709_2;
	nclc.matrix           = kQTMatrix_ITU_R_709_2;
	
	mediaSampleDescAttribs->err = ICMImageDescriptionSetProperty(mediaSampleDescAttribs->hImage, 
																 kQTPropertyClass_ImageDescription, 
																 kICMImageDescriptionPropertyID_NCLCColorInfo, 
																 sizeof(NCLCColorInfoImageDescriptionExtension), 
																 &nclc);
	
	return( mediaSampleDescAttribs->err == noErr );
} // QTMediaDescriptionSetNCLCColorInfo

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionSetFieldInfo(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	// Field count/detail
	
	// assume progressive unless otherwise stated
	
	FieldInfoImageDescriptionExtension2 fieldInfo = { 0, 0 };
	
	// Values found in the doc:
	//
	// http://developer.apple.com/quicktime/icefloe/dispatch019.html#fiel
	
	fieldInfo.fields = kQTFieldsProgressiveScan;
	fieldInfo.detail = kQTFieldDetailUnknown;
	
	mediaSampleDescAttribs->err = ICMImageDescriptionSetProperty(mediaSampleDescAttribs->hImage, 
																 kQTPropertyClass_ImageDescription, 
																 kICMImageDescriptionPropertyID_FieldInfo, 
																 sizeof(FieldInfoImageDescriptionExtension2), 
																 &fieldInfo);
	
	return( mediaSampleDescAttribs->err == noErr );
} // QTMediaDescriptionSetFieldInfo

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionSetMovieTimeScale(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	// Media Edit
	
	mediaSampleDescAttribs->scale = DEFAULT_SCALE;
	
	SetMovieTimeScale(mediaSampleDescAttribs->movie, 
					  mediaSampleDescAttribs->scale);
	
	OSErr error = GetMoviesError();
	
	return( error == noErr );
} // QTMediaDescriptionSetMovieTimeScale

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionCreateMovieTrack(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	mediaSampleDescAttribs->trackVolume = 0;
	
	mediaSampleDescAttribs->track = NewMovieTrack(mediaSampleDescAttribs->movie, 
												  Long2Fix(mediaSampleDescAttribs->sampleWidth), 
												  Long2Fix(mediaSampleDescAttribs->sampleHeight), 
												  mediaSampleDescAttribs->trackVolume);
	
	OSErr error = GetMoviesError();
	
	return( error == noErr );
} // QTMediaDescriptionCreateMovieTrack

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionCreateTrackMedia(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	mediaSampleDescAttribs->mediaType   = VIDEO_TYPE;
	mediaSampleDescAttribs->dataRef     = NULL;
	mediaSampleDescAttribs->dataRefType = 0;
	
	mediaSampleDescAttribs->media = NewTrackMedia(mediaSampleDescAttribs->track, 
												  mediaSampleDescAttribs->mediaType, 
												  mediaSampleDescAttribs->scale, 
												  mediaSampleDescAttribs->dataRef, 
												  mediaSampleDescAttribs->dataRefType);
	
	OSErr error = GetMoviesError();
	
	return( error == noErr );
} // QTMediaDescriptionCreateTrackMedia

//---------------------------------------------------------------------------
//
// Add Media sample initializations
//
//---------------------------------------------------------------------------

static inline void QTMediaDescriptionInitSampleAttribs(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	mediaSampleDescAttribs->numberOfSamples = 1;
	mediaSampleDescAttribs->sampleFlags     = kDefaultFlag;
	mediaSampleDescAttribs->sampleTime      = 0;
} // QTMediaDescriptionInitSampleAttribs

//---------------------------------------------------------------------------

static inline void QTMediaDescriptionSetFrameDuration(const TimeValue fps,
													  QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	if( ( fps > 0 ) && ( fps < 30 ) )
	{
		mediaSampleDescAttribs->durationPerSample = DEFAULT_SCALE / fps;
	} // if
	else
	{
		mediaSampleDescAttribs->durationPerSample = kDefaultFrameDuration;
	} // else
} // QTMediaDescriptionSetFrameDuration

//---------------------------------------------------------------------------

static BOOL QTMediaDescriptionCreate(const NSSize *size,
									 const TimeValue fps,
									 QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	if( !QTMediaDescriptionInitImageAttribs(size,mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionFileCreateWithSystemPath(mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionCreateDataRefFromFile(mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionCreateMovieStorage(mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionCreateImageHandle(size, mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionSetNCLCColorInfo(mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionSetFieldInfo(mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionSetMovieTimeScale(mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionCreateMovieTrack(mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	if( !QTMediaDescriptionCreateTrackMedia(mediaSampleDescAttribs) )
	{
		return( NO );
	} // if
	
	QTMediaDescriptionInitSampleAttribs(mediaSampleDescAttribs);
	QTMediaDescriptionSetFrameDuration(fps, mediaSampleDescAttribs);
	
	return( YES );
} // QTMediaDescriptionCreate

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Release Media Sample

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionReleaseURL(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	BOOL released = NO;
	
	if( mediaSampleDescAttribs->url != NULL )
	{
		CFRelease(mediaSampleDescAttribs->url);
		
		released = YES;
	} // if
	
	return( released );
} // QTMediaDescriptionReleaseURL

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionCloseMovieStorage(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	BOOL closed = NO;
	
	if( mediaSampleDescAttribs->outputDataHandler ) 
	{
		CloseMovieStorage( mediaSampleDescAttribs->outputDataHandler );
		
		closed = YES;
	} // if
	
	return( closed );
} // QTMediaDescriptionCloseMovieStorage

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionDisposeDataHandler(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	BOOL disposed = NO;
	
	if( mediaSampleDescAttribs->outputDataRef.dataRef )
	{
		DisposeHandle(mediaSampleDescAttribs->outputDataRef.dataRef);
		
		disposed = YES;
	} // if
	
	return( disposed );
} // QTMediaDescriptionDisposeDataHandler

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionDisposeImageHandle(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	BOOL disposed = NO;
	
	if( mediaSampleDescAttribs->hImage )
	{
		DisposeHandle((Handle)mediaSampleDescAttribs->hImage);
		
		disposed = YES;
	} // if
	
	return( disposed );
} // QTMediaDescriptionDisposeImageHandle

//---------------------------------------------------------------------------

static inline BOOL QTMediaDescriptionDisposeMovie(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	BOOL disposed = NO;
	
	if( mediaSampleDescAttribs->movie )
	{
		DisposeMovie(mediaSampleDescAttribs->movie);
		
		disposed = YES;
	} // if
	
	return( disposed );
} // QTMediaDescriptionDisposeMovie

//---------------------------------------------------------------------------

static BOOL QTMediaDescriptionRelease(QTMediaSampleDescriptionAttributesRef mediaSampleDescAttribs)
{
	BOOL released = NO;
	
	if( mediaSampleDescAttribs != NULL )
	{
		released = QTMediaDescriptionReleaseURL(mediaSampleDescAttribs);
		released = released && QTMediaDescriptionCloseMovieStorage(mediaSampleDescAttribs);
		released = released && QTMediaDescriptionDisposeDataHandler(mediaSampleDescAttribs);
		released = released && QTMediaDescriptionDisposeImageHandle(mediaSampleDescAttribs);
		released = released && QTMediaDescriptionDisposeMovie(mediaSampleDescAttribs);
		
		mediaSampleDescAttribs->movie             = NULL;
		mediaSampleDescAttribs->outputDataHandler = NULL;
		mediaSampleDescAttribs->track             = NULL;
		mediaSampleDescAttribs->media             = NULL;
		mediaSampleDescAttribs->url               = NULL;
	} // if
	
	return( released );
} // QTMediaDescriptionRelease

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@implementation QTMediaSampleDescription

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Initialization

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
// Initialize a frame compressor object with the specified codec,
// bounds, compressor options and timescale
//
//---------------------------------------------------------------------------

- (id) initMediaSampleDescriptionWithMoviePath:(NSString *)theMoviePath
									 frameSize:(const NSSize *)theSize
								  framesPerSec:(const TimeValue)theFPS
{
	self = [super init];
	
	if( self )
	{
		mediaSampleDescAttribs = (QTMediaSampleDescriptionAttributesRef)malloc(sizeof(QTMediaSampleDescriptionAttributes));
		
		if( mediaSampleDescAttribs != NULL )
		{
			mediaSampleDescAttribs->path = CFStringCreateCopy(kCFAllocatorDefault,
															  (CFStringRef)theMoviePath);
			
			if( mediaSampleDescAttribs->path != NULL )
			{
				QTMediaDescriptionCreate(theSize, 
										 theFPS, 
										 mediaSampleDescAttribs);
			} // if
		} // if
		else
		{
			NSLog( @">> ERROR: QT Media Sample Description - Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return( self );
} // initMediaSampleDescriptionWithMoviePath

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Dealloc

//---------------------------------------------------------------------------

- (void) cleanUpDescription 
{
	if( mediaSampleDescAttribs != NULL )
	{
		QTMediaDescriptionRelease( mediaSampleDescAttribs );
		
		if( mediaSampleDescAttribs->path != NULL )
		{
			CFRelease(mediaSampleDescAttribs->path);
		} // if
		
		free( mediaSampleDescAttribs );
		
		mediaSampleDescAttribs = NULL;
	} // if
} // cleanUpDescription

//---------------------------------------------------------------------------

- (void) dealloc
{
	[self cleanUpDescription];
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Accessors

//---------------------------------------------------------------------------

- (Media) media
{
	return( mediaSampleDescAttribs->media );
} // media

//---------------------------------------------------------------------------

- (Track) track
{
	return( mediaSampleDescAttribs->track );
} // track

//---------------------------------------------------------------------------

- (Movie) movie
{
	return( mediaSampleDescAttribs->movie );
} // movie

//---------------------------------------------------------------------------

- (DataHandler) dataHandler
{
	return( mediaSampleDescAttribs->outputDataHandler );
} // dataHandler

//---------------------------------------------------------------------------

- (TimeValue) durationPerSample
{
	return( mediaSampleDescAttribs->durationPerSample );
} // durationPerSample

//---------------------------------------------------------------------------

- (TimeValue) sampleTime
{
	return( mediaSampleDescAttribs->sampleTime );
} // sampleTime

//---------------------------------------------------------------------------

- (SampleDescriptionHandle) sampleDescriptionHandle
{
	return( (SampleDescriptionHandle)mediaSampleDescAttribs->hImage );
} // sampleDescriptionHandle

//---------------------------------------------------------------------------

- (unsigned long) sampleSize
{
	return( mediaSampleDescAttribs->sampleSize );
} // sampleSize

//---------------------------------------------------------------------------

- (unsigned long) numberOfSamples
{
	return( mediaSampleDescAttribs->numberOfSamples );
} // numberOfSamples

//---------------------------------------------------------------------------

- (short) sampleFlags
{
	return( mediaSampleDescAttribs->sampleFlags );
} // sampleFlags

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
