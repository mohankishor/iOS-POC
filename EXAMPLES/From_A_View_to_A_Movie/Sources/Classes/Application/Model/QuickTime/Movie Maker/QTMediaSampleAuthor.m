//---------------------------------------------------------------------------
//
// File: QTMediaSampleAuthor.m
//
// Abstract: Utility class for write raw media samples to a file
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

#include <libkern/OSAtomic.h>

//---------------------------------------------------------------------------

#import "QTMediaSampleNotifications.h"
#import "QTMediaSampleAuthor.h"
#import "QTMediaSampleAuthorOperation.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#define FILE_PERMS  0666
#define OPEN_PERMS  O_CREAT | O_WRONLY

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structure

//---------------------------------------------------------------------------

struct QTMediaSampleAuthorAttributes
{
	BOOL              mediaSampleFileClosed;
	BOOL              mediaSampleExportSuspended;
	BOOL              mediaSampleExportResumes;
	volatile int32_t  mediaSamplesEnqueued;
	volatile int32_t  mediaSamplesAdded;
}; // QTMediaSampleAuthorAttributes

typedef struct QTMediaSampleAuthorAttributes   QTMediaSampleAuthorAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation QTMediaSampleAuthor

//---------------------------------------------------------------------------

- (void) newOperationQueue
{
	mediaAuthorOperationQueue = [NSOperationQueue new];
	
	[mediaAuthorOperationQueue setMaxConcurrentOperationCount:1];
} // newOperationQueue

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

- (id) initMediaSampleAuthorWithPathName:(NSString *)thePathname
						 mediaSampleSize:(const NSSize *)theMediaSampleSize
{
	self = [super init];
	
	if( self )
	{
		mediaSampleAuthorAttribs = (QTMediaSampleAuthorAttributesRef)malloc(sizeof(QTMediaSampleAuthorAttributes));
		
		if( mediaSampleAuthorAttribs != NULL )
		{
			mediaSampleFile = [[QTMediaSampleFile alloc] initMediaSampleFileWithPathName:thePathname
																				  access:FILE_PERMS
																				  create:OPEN_PERMS];
			
			if( mediaSampleFile )
			{			
				if( [mediaSampleFile open] )
				{
					mediaSampleAuthorAttribs->mediaSampleFileClosed = NO;
				} // if
				
				mediaSampleAuthorAttribs->mediaSampleExportSuspended = YES;
				mediaSampleAuthorAttribs->mediaSampleExportResumes   = NO;
				
				mediaSampleAuthorAttribs->mediaSamplesAdded    = 0;
				mediaSampleAuthorAttribs->mediaSamplesEnqueued = 0;
				
				[self newOperationQueue];
			} // if
			
		} // if
		else
		{
			NSLog( @">> ERROR: QT Media Sample Author - Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return( self );
} // initMediaSampleAuthorWithPathName

//---------------------------------------------------------------------------

- (void) flushOperationQueue
{
	if( !mediaSampleAuthorAttribs->mediaSampleFileClosed )
	{
		[mediaAuthorOperationQueue waitUntilAllOperationsAreFinished];
		
		if( mediaAuthorOperationQueue )
		{
			[mediaAuthorOperationQueue release];
			
			mediaAuthorOperationQueue = nil;
		} // if
	} // if
} // flushOperationQueue

//---------------------------------------------------------------------------

- (void) closeMediaSampleFile
{
	if( !mediaSampleAuthorAttribs->mediaSampleFileClosed )
	{
		[mediaSampleFile close];
	} // if
	
	if( mediaSampleFile )
	{
		[mediaSampleFile release];
		
		mediaSampleFile = nil;
	} // if
} // closeMediaSampleFile

//---------------------------------------------------------------------------

- (void) releaseMediaSampleAuthorDataStore
{
	if( mediaSampleAuthorAttribs != NULL )
	{
		free( mediaSampleAuthorAttribs );
		
		mediaSampleAuthorAttribs = NULL;
	} // if
} // releaseMediaSampleAuthorDataStore

//---------------------------------------------------------------------------

- (void) cleanUpAuthor
{
	[self flushOperationQueue];
	[self closeMediaSampleFile];
	[self releaseMediaSampleAuthorDataStore];
} // cleanUpAuthor

//---------------------------------------------------------------------------

- (void) dealloc
{
	[self cleanUpAuthor];
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------

- (BOOL) isSuspended
{
	register uint32_t  value = (uint32_t)mediaSampleAuthorAttribs->mediaSamplesEnqueued;
	register uint32_t  mask   = 150;
	register uint32_t  result = value ^ mask;

	return( !result );
} // isSuspended

//---------------------------------------------------------------------------

- (int32_t) count
{
	int32_t value = mediaSampleAuthorAttribs->mediaSamplesEnqueued;
	
	return( value );
} // authoring

//---------------------------------------------------------------------------

- (int32_t) samples
{
	int32_t value = mediaSampleAuthorAttribs->mediaSamplesAdded;
	
	return( value );
} // samples

//---------------------------------------------------------------------------

- (void) addMediaSampleToQueue:(QTMediaSample *)theMediaSample
{
	QTMediaSampleAuthorOperation *mediaSampleAuthorOp = [[QTMediaSampleAuthorOperation alloc] initMediaSampleAuthorOperation:theMediaSample 
																														file:mediaSampleFile
																													enqueued:&mediaSampleAuthorAttribs->mediaSamplesEnqueued
																													 samples:&mediaSampleAuthorAttribs->mediaSamplesAdded];
	
	if( mediaSampleAuthorOp )
	{
		[mediaAuthorOperationQueue addOperation:mediaSampleAuthorOp];
		
		OSAtomicIncrement32Barrier( &mediaSampleAuthorAttribs->mediaSamplesEnqueued );
		
		[mediaSampleAuthorOp release];
	} // if
} // addMediaSampleToQueue

//---------------------------------------------------------------------------

- (void) writeMediaSampleAsync:(QTMediaSample *)theMediaSample
{
	if( mediaAuthorOperationQueue == nil )
	{
		[self newOperationQueue];
	} // if
	
	[self addMediaSampleToQueue:theMediaSample];
} // writeAsync

//---------------------------------------------------------------------------

- (void) writeFlushQueue
{
	if( [self isSuspended] )
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:QTMediaSampleAuthorIsSuspended 
															object:self];
		
		[self flushOperationQueue];
		
		mediaSampleAuthorAttribs->mediaSampleExportResumes = YES;
	} // if
} // writeFlushQueue

//---------------------------------------------------------------------------

- (void) writeCanResume
{
	if( mediaSampleAuthorAttribs->mediaSampleExportResumes )
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:QTMediaSampleAuthorIsResumed 
															object:self];
		
		mediaSampleAuthorAttribs->mediaSampleExportResumes = NO;
	} // if
} // writeCanResume

//---------------------------------------------------------------------------

- (void) writeAsync:(QTMediaSample *)theMediaSample
{
	[self writeFlushQueue];
	[self writeMediaSampleAsync:theMediaSample];
	[self writeCanResume];
} // writeAsync

//---------------------------------------------------------------------------

- (BOOL) close
{
	[mediaAuthorOperationQueue waitUntilAllOperationsAreFinished];
	
	mediaSampleAuthorAttribs->mediaSampleFileClosed = [mediaSampleFile close];
	
	return( mediaSampleAuthorAttribs->mediaSampleFileClosed );
} // close

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

