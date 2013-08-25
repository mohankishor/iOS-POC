//-------------------------------------------------------------------------
//
//	File: OpenGLViewSnapshot.m
//
//  Abstract: Utility class for capturing a snapshot of an OpenGL view 
//            and then generating a Image I/O supported file formats
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

#import "OpenGLViewSnapshot.h"

//------------------------------------------------------------------------

//------------------------------------------------------------------------

struct CGImageOptions
{
	CFMutableDictionaryRef file;
	CFMutableDictionaryRef image;
};

typedef struct CGImageOptions CGImageOptions;

//------------------------------------------------------------------------

struct CGFileDescription
{
	CFIndex                 index;
	CFStringRef             UTI;
	CFMutableDictionaryRef  auxInfo;
	CGImageOptions          options;
};

typedef struct CGFileDescription CGFileDescription;

//------------------------------------------------------------------------

struct CGFile
{
	ImageFileFormats   format;
	CGFileDescription  description;
};

typedef struct CGFile   CGFile;
typedef struct CGFile  *CGFileRef;

//------------------------------------------------------------------------

struct OpenGLViewSnapshotAttributes
{
	NSRect     frame;
	CGImageRef imageRef;
	CGFile     file;
};

typedef struct OpenGLViewSnapshotAttributes   OpenGLViewSnapshotAttributes;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

static const int kTiffCompressionIsLZW = 5;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

@implementation OpenGLViewSnapshot

//------------------------------------------------------------------------

- (id) initViewSnapshotWithSubFrame:(const NSRect *)theSubFrame
							   view:(NSOpenGLView *)theBaseView
{
	self = [super initViewCGImageWithSubFrame:theSubFrame
										 view:theBaseView];
	
	if( self )
	{		
		snapshotAttribs = (OpenGLViewSnapshotAttributesRef)malloc(sizeof(OpenGLViewSnapshotAttributes));
		
		if( snapshotAttribs != NULL )
		{
			CFIndex auxInfoCount   = 2;
			CFIndex imageInfoCount = 1;
			
			snapshotAttribs->imageRef = NULL;
			snapshotAttribs->frame    = *theSubFrame;
			
			snapshotAttribs->file.format = kFileFormatIsJPEG;
			
			snapshotAttribs->file.description.index = 1;
			snapshotAttribs->file.description.UTI   = 0;
			
			snapshotAttribs->file.description.options.file = NULL;
			
			snapshotAttribs->file.description.options.image = CFDictionaryCreateMutable(kCFAllocatorDefault, 
																						imageInfoCount,
																						&kCFTypeDictionaryKeyCallBacks,
																						&kCFTypeDictionaryValueCallBacks);
			
			snapshotAttribs->file.description.auxInfo = CFDictionaryCreateMutable(kCFAllocatorDefault, 
																				  auxInfoCount,
																				  &kCFTypeDictionaryKeyCallBacks,
																				  &kCFTypeDictionaryValueCallBacks);
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL View Snapshot - Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return( self );
} // initViewSnapshotWithSubFrame

//------------------------------------------------------------------------

- (void) cleanUpViewSnapshot
{
	if( snapshotAttribs != NULL )
	{
		if( snapshotAttribs->file.description.options.file != NULL )
		{
			CFRelease( snapshotAttribs->file.description.options.file ) ;
		} // if
		
		if( snapshotAttribs->file.description.options.image != NULL )
		{
			CFRelease( snapshotAttribs->file.description.options.image );
		} // if
		
		if( snapshotAttribs->file.description.auxInfo != NULL )
		{
			CFRelease( snapshotAttribs->file.description.auxInfo );
		} // if
		
		free( snapshotAttribs );
		
		snapshotAttribs = NULL;
	} // if
} // cleanUpViewSnapshot

//------------------------------------------------------------------------

- (void) dealloc
{
	[self cleanUpViewSnapshot];
	
	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------

+ (id) viewSnapshotWithSubFrame:(const NSRect *)theSubFrame
						   view:(NSOpenGLView *)theBaseView
{
	return( [[[OpenGLViewSnapshot allocWithZone:[self zone]] initViewSnapshotWithSubFrame:theSubFrame 
																				   view:theBaseView] autorelease] );
} // viewSnapshotWithSubFrame

//------------------------------------------------------------------------

- (void) saveAs:(NSString *)theFilePath
		   file:(CGFileRef)theFile
{
	Boolean  isDirectory = false;
	
	CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, 
													 (CFStringRef)theFilePath,
													 kCFURLPOSIXPathStyle, 
													 isDirectory);
	
	if( fileURL != NULL )
	{
		CGImageDestinationRef imageDestRef = CGImageDestinationCreateWithURL(fileURL,
																			 theFile->description.UTI, 
																			 theFile->description.index, 
																			 theFile->description.options.file);
		if( imageDestRef != NULL )
		{
			snapshotAttribs->imageRef = [self imageRef];
			
			CGImageDestinationAddImage(imageDestRef, 
									   snapshotAttribs->imageRef,
									   theFile->description.options.image);
			
			CGImageDestinationFinalize( imageDestRef ) ;
			
			CFRelease( imageDestRef );
		} // if
		
		CFRelease( fileURL );
	} // if
} // saveAs

//------------------------------------------------------------------------

- (void) saveAsBMP:(NSString *)theBMPFilePath
{
	snapshotAttribs->file.format = kFileFormatIsBMP;
	
	snapshotAttribs->file.description.UTI = kUTTypeBMP;
	
	[self saveAs:theBMPFilePath
			file:&snapshotAttribs->file];
} // saveAsBMP

//------------------------------------------------------------------------

- (void) saveAsGIF:(NSString *)theGIFFilePath
{
	snapshotAttribs->file.format = kFileFormatIsGIF;
	
	snapshotAttribs->file.description.UTI = kUTTypeGIF;
	
	[self saveAs:theGIFFilePath
			file:&snapshotAttribs->file];
} // saveAsGIF

//------------------------------------------------------------------------

- (void) saveAsJP2:(NSString *)theJP2FilePath
{
	snapshotAttribs->file.format = kFileFormatIsJP2;
	
	snapshotAttribs->file.description.UTI = kUTTypeJPEG2000;
	
	[self saveAs:theJP2FilePath
			file:&snapshotAttribs->file];
} // saveAsJP2

//------------------------------------------------------------------------

- (void) saveAsJPEG:(NSString *)theJPEGFilePath
{
	snapshotAttribs->file.format = kFileFormatIsJPEG;
	
	snapshotAttribs->file.description.UTI = kUTTypeJPEG;
	
	[self saveAs:theJPEGFilePath
			file:&snapshotAttribs->file];
} // saveAsJPEG

//------------------------------------------------------------------------

- (void) saveAsPNG:(NSString *)thePNGFilePath
{
	snapshotAttribs->file.format = kFileFormatIsPNG;
	
	snapshotAttribs->file.description.UTI = kUTTypePNG;
	
	[self saveAs:thePNGFilePath
			file:&snapshotAttribs->file];
} // saveAsPNG

//------------------------------------------------------------------------

- (void) saveAsTiff:(NSString *)theTiffFilePath
{
	snapshotAttribs->file.format = kFileFormatIsTiff;
	
	snapshotAttribs->file.description.UTI = kUTTypeTIFF;
	
	if( CFDictionaryContainsKey(snapshotAttribs->file.description.options.image, 
								kCGImageDestinationLossyCompressionQuality) )
	{
		int tiffCompression = kTiffCompressionIsLZW;
		
		CFNumberRef tiffCompressionNum = CFNumberCreate(kCFAllocatorDefault, 
														kCFNumberIntType, 
														&tiffCompression);
		
		if( tiffCompressionNum != NULL )
		{
			CFIndex tiffInfoCount = 1;
			
			CFMutableDictionaryRef tiffCompressionDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 
																				   tiffInfoCount,
																				   &kCFTypeDictionaryKeyCallBacks,
																				   &kCFTypeDictionaryValueCallBacks);
			
			if( tiffCompressionDict != NULL )
			{
				CFDictionarySetValue(tiffCompressionDict, 
									 kCGImagePropertyTIFFCompression, 
									 tiffCompressionNum);

				CFDictionarySetValue(snapshotAttribs->file.description.options.image, 
									 kCGImagePropertyTIFFDictionary, 
									 tiffCompressionDict);
				
				CFRelease( tiffCompressionDict );
			} // if
			
			CFRelease( tiffCompressionNum );
		} // if
	} // if
	
	[self saveAs:theTiffFilePath
			file:&snapshotAttribs->file];
} // saveAsTiff

//------------------------------------------------------------------------

- (void) saveAsPDF:(NSString *)thePDFDocPathname
{
	Boolean isDirectory = false;
	
	CFURLRef pdfFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, 
														(CFStringRef)thePDFDocPathname,
														kCFURLPOSIXPathStyle, 
														isDirectory);
	
	if( pdfFileURL != NULL )
	{
		CGRect        pdfPageFrame = NSRectToCGRect([self imageSubFrame]);
		CGContextRef  pdfContext   = CGPDFContextCreateWithURL(pdfFileURL, 
															   &pdfPageFrame, 
															   snapshotAttribs->file.description.auxInfo);
		
		if( pdfContext != NULL )
		{
			CGContextBeginPage(pdfContext, &pdfPageFrame);
			
			CGContextDrawImage(pdfContext, 
							   pdfPageFrame,
							   [self imageRef]);
			
			CGContextEndPage(pdfContext);
			
			CGContextRelease(pdfContext);
		} // if
		
		CFRelease(pdfFileURL);
	} // if
	
	snapshotAttribs->file.format = kFileFormatIsPDF;
} // saveAsPDF

//------------------------------------------------------------------------

- (void) snapshotSetFormat:(const ImageFileFormats)theFileFormat
{
	snapshotAttribs->file.format = theFileFormat;
} // snapshotSetFormat

//------------------------------------------------------------------------

- (void) snapshotSetDocumentTitle:(NSString *)theDocTitle
{
	if( snapshotAttribs->file.description.auxInfo != NULL )
	{
		CFStringRef docTitle = NULL;
		
		if( theDocTitle )
		{
			docTitle = (CFStringRef)theDocTitle;
		} // if
		else
		{
			docTitle = CFSTR( "Title" );
		} // else
		
		CFDictionarySetValue(snapshotAttribs->file.description.auxInfo, 
							 kCGPDFContextTitle, 
							 docTitle);
	} // if
} // snapshotSetDocumentTitle

//------------------------------------------------------------------------

- (void) snapshotSetDocumentAuthor:(NSString *)theDocAuthor
{
	if( snapshotAttribs->file.description.auxInfo != NULL )
	{
		CFStringRef docAuthor = NULL;
		
		if( theDocAuthor )
		{
			docAuthor = (CFStringRef)theDocAuthor;
		} // if
		else
		{
			docAuthor = CFSTR( "Author" );
		} // else
		
		CFDictionarySetValue(snapshotAttribs->file.description.auxInfo, 
							 kCGPDFContextAuthor, 
							 docAuthor);
	} // if
} // snapshotSetDocumentAuthor

//------------------------------------------------------------------------

- (void) snapshotSetDocumentSubject:(NSString *)theDocSubject
{
	if( snapshotAttribs->file.description.auxInfo != NULL )
	{
		CFStringRef docSubject= NULL;
		
		if( theDocSubject )
		{
			docSubject = (CFStringRef)theDocSubject;
		} // if
		else
		{
			docSubject = CFSTR( "Subject" );
		} // else
		
		CFDictionarySetValue(snapshotAttribs->file.description.auxInfo, 
							 kCGPDFContextSubject, 
							 docSubject);
	} // if
} // snapshotSetDocumentSubject

//------------------------------------------------------------------------

- (void) snapshotSetDocumentCreator:(NSString *)theDocCreator
{
	if( snapshotAttribs->file.description.auxInfo != NULL )
	{
		CFStringRef docCreator = NULL;
		
		if( theDocCreator )
		{
			docCreator = (CFStringRef)theDocCreator;
		} // if
		else
		{
			docCreator = CFSTR( "Creator" );
		} // else
		
		CFDictionarySetValue(snapshotAttribs->file.description.auxInfo, 
							 kCGPDFContextCreator, 
							 docCreator);
	} // if
} // snapshotSetDocumentCreator

//------------------------------------------------------------------------

- (void) snapshotSetCompression:(const CGFloat)theCompression
{
	if( theCompression < 1.0f )
	{
		CGFloat compression = theCompression;
		
		CFNumberRef compressionNum = CFNumberCreate(kCFAllocatorDefault, 
													kCFNumberFloatType, 
													&compression);
		
		if( compressionNum != NULL )
		{
			CFDictionarySetValue(snapshotAttribs->file.description.options.image, 
								 kCGImageDestinationLossyCompressionQuality, 
								 compressionNum);
		} // if
	} // if
} // snapshotSetCompression

//------------------------------------------------------------------------

- (void) setFrame:(const NSRect *)theFrame
{
	[self imageSetSubFrame:theFrame];
} // setFrame

//------------------------------------------------------------------------

- (void) snapshot
{
	[self imageInvalidate:YES];
} // snapshot

//------------------------------------------------------------------------

- (void) snapshotSaveAs:(NSString *)theFilePathname
{
	NSString *filePathname = nil;
	
	switch( snapshotAttribs->file.format )
	{
		case kFileFormatIsBMP:
			filePathname = [NSString stringWithFormat:@"%@.bmp",theFilePathname];
			[self saveAsBMP:filePathname];
			break;
			
		case kFileFormatIsGIF:
			filePathname = [NSString stringWithFormat:@"%@.gif",theFilePathname];
			[self saveAsGIF:filePathname];
			break;
			
		case kFileFormatIsJP2:
			filePathname = [NSString stringWithFormat:@"%@.jp2",theFilePathname];
			[self saveAsJP2:filePathname];
			break;
			
		case kFileFormatIsPDF:
			filePathname = [NSString stringWithFormat:@"%@.pdf",theFilePathname];
			[self saveAsPDF:filePathname];
			break;
			
		case kFileFormatIsPNG:
			filePathname = [NSString stringWithFormat:@"%@.png",theFilePathname];
			[self saveAsPNG:filePathname];
			break;
			
		case kFileFormatIsTiff:
			filePathname = [NSString stringWithFormat:@"%@.tiff",theFilePathname];
			[self saveAsTiff:filePathname];
			break;
			
		case kFileFormatIsJPEG:
		default:
			filePathname = [NSString stringWithFormat:@"%@.jpeg",theFilePathname];
			[self saveAsJPEG:filePathname];
			break;
	} // switch
} // snapshotSaveAs

//------------------------------------------------------------------------

@end

//------------------------------------------------------------------------

//------------------------------------------------------------------------

