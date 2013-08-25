//---------------------------------------------------------------------------
//
// File: QTMediaSampleFile.m
//
// Abstract: Utility class for manging file operations using a file 
//           descriptor.
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

#include <errno.h>
#include <limits.h>
#include <unistd.h>

//---------------------------------------------------------------------------

#import "QTMediaSampleFile.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Macros

//---------------------------------------------------------------------------

#define QTMediaSampleFileWriteTypes  2

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Enumerated Types

//---------------------------------------------------------------------------

enum QTMediaSampleFileWriteType
{
	kQTMediaSampleFilePWrite = 0,
	kQTMediaSampleFileWrite
};

typedef enum QTMediaSampleFileWriteType QTMediaSampleFileWriteType;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------

struct QTMediaSampleFileAttributes
{
	NSInteger   descriptor;
	NSInteger   access;
	NSInteger   create;
	int64_t     offset;
	int64_t     size;
	char       *pathname;
	BOOL        closed;
};

typedef struct QTMediaSampleFileAttributes   QTMediaSampleFileAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers Definition

//---------------------------------------------------------------------------

typedef ssize_t (*QTMediaSampleFileWriteFuncPtr)(int fileDesc, 
												 const void *buffer, 
												 size_t bufferSize, 
												 off_t fileOffset);

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers Implementations

//---------------------------------------------------------------------------

static ssize_t QTMediaSampleFilePWrite(int fileDesc, 
									   const void *buffer, 
									   size_t bufferSize, 
									   off_t fileOffset)
{
	return( pwrite(fileDesc, buffer, bufferSize, fileOffset) );
} // QTMediaSampleFilePWrite

//---------------------------------------------------------------------------

static ssize_t QTMediaSampleFileWrite(int fileDesc, 
									  const void *buffer, 
									  size_t bufferSize, 
									  off_t fileOffset)
{
	return( write(fileDesc, buffer, bufferSize) );
} // QTMediaSampleFileWrite

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers

//---------------------------------------------------------------------------

static QTMediaSampleFileWriteFuncPtr  mediaSampleFileWriteFuncPtr[QTMediaSampleFileWriteTypes] = 
										{ 
											&QTMediaSampleFilePWrite, 
											&QTMediaSampleFileWrite 
										};

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@implementation QTMediaSampleFile

//---------------------------------------------------------------------------

- (id) init
{
	[self doesNotRecognizeSelector:_cmd];
	
	return nil;
} // init

//---------------------------------------------------------------------------

- (id) initMediaSampleFileWithPathName:(NSString *)thePathname
								access:(const NSInteger)theFileAccess
								create:(const NSInteger)theFileCreate
{
	self = [super init];
	
	if( self )
	{
		mediaSampleFileAttribs = (QTMediaSampleFileAttributesRef)malloc(sizeof(QTMediaSampleFileAttributes));
		
		if( mediaSampleFileAttribs != NULL )
		{
			mediaSampleFileAttribs->access     = theFileAccess;
			mediaSampleFileAttribs->create     = theFileCreate;
			mediaSampleFileAttribs->offset     = 0;
			mediaSampleFileAttribs->size       = 0;
			mediaSampleFileAttribs->descriptor = -1;
			mediaSampleFileAttribs->closed     = NO;
			mediaSampleFileAttribs->pathname   = NULL;
			
			const char *pathname    = (char *)[thePathname cStringUsingEncoding:NSASCIIStringEncoding];
			const int   pathnameLen = strlen(pathname)+1;
			
			mediaSampleFileAttribs->pathname = (char *)malloc(pathnameLen);
			
			if( mediaSampleFileAttribs->pathname != NULL )
			{
				strncpy(mediaSampleFileAttribs->pathname, 
						pathname, 
						pathnameLen);
			} // if
		} // if
		else
		{
			NSLog( @">> ERROR: QT Media File - Failure Allocating Memory For QT Media Sample File Attributes!" );
		} // else
	} // if
	
	return( self );
} // initMediaSampleFileWithPathName

//---------------------------------------------------------------------------

- (void) cleanUpFile
{
	if( !mediaSampleFileAttribs->closed )
	{
		[self close];
	} // if

	if( mediaSampleFileAttribs != NULL )
	{
		if( mediaSampleFileAttribs->pathname != NULL )
		{
			free( mediaSampleFileAttribs->pathname );
		} // if
		
		free( mediaSampleFileAttribs );
		
		mediaSampleFileAttribs = NULL;
	} // if
} // cleanUpFile

//---------------------------------------------------------------------------

- (void) dealloc
{
	[self cleanUpFile];
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------
//
// Get the current file offset.
//
//---------------------------------------------------------------------------

- (int64_t) offset
{
	return( mediaSampleFileAttribs->offset );
} // offset

//---------------------------------------------------------------------------
//
// Move the file offset. Use in conjunction with -pwrite: method.
//
//---------------------------------------------------------------------------

- (void) setOffset:(const int64_t)theFileOffset
{
	mediaSampleFileAttribs->offset = theFileOffset;
} // setOffset

//---------------------------------------------------------------------------
//
// Create a file and release its file descriptor.
//
//---------------------------------------------------------------------------

- (BOOL) open
{
	BOOL opened = NO;
	
	mediaSampleFileAttribs->descriptor = open(mediaSampleFileAttribs->pathname,
											  mediaSampleFileAttribs->create, 
											  mediaSampleFileAttribs->access);
	
	if( mediaSampleFileAttribs->descriptor == -1 )
	{
		NSLog(@">> ERROR[%ld]: Creating a QT media file for write failed!", errno);
		
		opened = YES;
	} // if
	
	return( opened );
} // open

//---------------------------------------------------------------------------
//
// Close a file a release its file descriptor.
//
//---------------------------------------------------------------------------

- (BOOL) close
{
	if( mediaSampleFileAttribs->descriptor )
	{
		int closed = close( mediaSampleFileAttribs->descriptor );
		
		mediaSampleFileAttribs->closed = closed == 0;
	} // if
	
	return( mediaSampleFileAttribs->closed );
} // close

//---------------------------------------------------------------------------
//
// Move the file pointer.  This method can be used with the write method.
//
//---------------------------------------------------------------------------

- (BOOL) seek:(const int64_t)theFileOffset
		 from:(const int)theFileSeekPos
{
	int64_t fileOffset = -1;
	
	if( mediaSampleFileAttribs->descriptor && ( theFileOffset > 0 ) )
	{
		fileOffset = lseek(mediaSampleFileAttribs->descriptor,
						   theFileOffset,
						   theFileSeekPos);
		
		if( fileOffset )
		{
			mediaSampleFileAttribs->offset = fileOffset;
		} // if
		else
		{
			NSLog(@">> ERROR[%ld]: QT media sample file seek failed!", errno );
		} // else
	} // if
	
	return( fileOffset > 0 );
} // seek

//---------------------------------------------------------------------------

- (BOOL) writeMediaSample:(QTMediaSample *)theMediaSample
				writeType:(const QTMediaSampleFileWriteType)theWriteType
			   fileOffset:(int64_t *)theFileOffset
{
	BOOL wrote = NO;
	
	if( theMediaSample && mediaSampleFileAttribs->descriptor )
	{
		GLvoid *mediaSampleBuffer = [theMediaSample buffer];
		
		if( mediaSampleBuffer != NULL )
		{
			GLuint   pixelBufferLen = [theMediaSample size];
			
			ssize_t byteCount = mediaSampleFileWriteFuncPtr[theWriteType](mediaSampleFileAttribs->descriptor, 
																		  mediaSampleBuffer, 
																		  pixelBufferLen, 
																		  *theFileOffset);
			
			if( byteCount == - 1 )
			{
				NSLog(@">> ERROR[%ld]: QT media sample file write failed!", errno );
			} // if
			else if( byteCount != pixelBufferLen )
			{
				NSLog(@">> WARNING[%ld]: Wrote fewer bytes than expected! Expected = %ld, Actual = %ld!", 
					  errno, 
					  pixelBufferLen, 
					  byteCount );
				
				long     offset      = *theFileOffset + byteCount;		// Current file offset
				long     bufferBytes = 0;								// Bytes written per write
				long     bufferCount = 0;								// Bytes written total
				long     bufferSize  = pixelBufferLen - byteCount;		// Remaining bytes that need to be written
				GLvoid  *buffer      = mediaSampleBuffer + byteCount;	// Advance buffer pointer to the new position
				
				while( bufferSize > 0 )
				{
					bufferBytes = mediaSampleFileWriteFuncPtr[theWriteType](mediaSampleFileAttribs->descriptor, 
																			buffer, 
																			bufferSize, 
																			offset);
					
					bufferSize -= bufferBytes;
					
					if( bufferBytes )
					{
						buffer += bufferBytes;
						offset += bufferBytes;
						
						bufferCount += bufferBytes;
					} // if
					else
					{
						NSLog(@">> ERROR[%ld]: Failed to complete the write operation! Bytes remaining = %ld", 
							  errno,
							  bufferSize);
						
						break;
					} // else
				} // while
				
				*theFileOffset = offset;
				
				mediaSampleFileAttribs->size += bufferCount;
				
				wrote = bufferSize == 0;
			} // if
			else
			{
				*theFileOffset += byteCount;
				
				mediaSampleFileAttribs->size += byteCount;
				
				wrote = YES;
			} // if
		} // if
	} // if
	
	return( wrote );
} // writeMediaSample

//---------------------------------------------------------------------------
//
// Write and move the file pointer.
//
//---------------------------------------------------------------------------

- (BOOL) write:(QTMediaSample *)theMediaSample
{
	return( [self writeMediaSample:theMediaSample
						 writeType:kQTMediaSampleFileWrite
						fileOffset:&mediaSampleFileAttribs->offset] );
} // write

//---------------------------------------------------------------------------
//
// Use the pwrite UNIX system call to either write media sample using its 
// current media sample file offset.
//
//---------------------------------------------------------------------------

- (BOOL) writeUsingOffset:(QTMediaSample *)theMediaSample
{
	int64_t mediaSampleFileOffset = mediaSampleFileAttribs->offset;
	
	return( [self writeMediaSample:theMediaSample
						 writeType:kQTMediaSampleFilePWrite
						fileOffset:&mediaSampleFileOffset] );
} // writeUsingOffset

//---------------------------------------------------------------------------
//
// Use the pwrite UNIX system call to either write media sample using its 
// frame index.
//
//---------------------------------------------------------------------------

- (BOOL) writeUsingIndex:(QTMediaSample *)theMediaSample
{
	int64_t mediaSampleFileOffset = [theMediaSample index] * [theMediaSample size];
	
	return( [self writeMediaSample:theMediaSample
						 writeType:kQTMediaSampleFilePWrite
						fileOffset:&mediaSampleFileOffset] );
} // writeUsingIndex

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

