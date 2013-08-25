//---------------------------------------------------------------------------
//
//	File: ColorProfileBase.hpp
//
//  Abstract: Base utility for getting the ICC profile name
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
//  Copyright (c) 2009 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#include <iostream>
#include <string>

//---------------------------------------------------------------------------

#include "LogError.h"

#include "Colors.h"
#include "ColorProfileBase.hpp"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures - Profile Base

//---------------------------------------------------------------------------

class ColorProfileBaseData
{
public:
	CFStringEncoding     mnEncoding;
	CFStringRef          maProfileDescription;
	CGDirectDisplayID    mnDirectDisplayID;
	ColorSyncProfileRef  maProfileRef;
}; // ColorProfileBaseData

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Set Profile Base Data

//---------------------------------------------------------------------------

static void ColorProfileBaseSetDataForDisplay(ColorProfileBaseData *pProfileBaseData) 
{
	pProfileBaseData->maProfileRef = NULL;
	
	pProfileBaseData->maProfileRef = ColorSyncProfileCreateWithDisplayID( pProfileBaseData->mnDirectDisplayID );
	
	if( pProfileBaseData->maProfileRef != NULL )
	{
		pProfileBaseData->maProfileDescription = ColorSyncProfileCopyDescriptionString( pProfileBaseData->maProfileRef );
	} // if
} // ICCProfileBaseSetDataForDisplay

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Copy Profile Data

//---------------------------------------------------------------------------

static ColorProfileBaseData *ColorProfileBaseCopyData(const ColorProfileBaseData * const pSrcProfilebaseData) 
{
	ColorProfileBaseData *pDstProfileBaseData = new ColorProfileBaseData;
	
	if( pDstProfileBaseData != NULL )
	{
		pDstProfileBaseData->mnEncoding        = pSrcProfilebaseData->mnEncoding;
		pDstProfileBaseData->mnDirectDisplayID = pSrcProfilebaseData->mnDirectDisplayID;
		
		if( pSrcProfilebaseData->maProfileDescription != NULL )
		{
			pDstProfileBaseData->maProfileDescription = CFStringCreateCopy(kCFAllocatorDefault,
																		   pSrcProfilebaseData->maProfileDescription);
		} // if
		
		CFErrorRef  warnings = NULL;
		CFErrorRef  errors   = NULL;
		
		pDstProfileBaseData->maProfileRef = ColorSyncProfileCreateMutableCopy( pSrcProfilebaseData->maProfileRef );
		
		if( !ColorSyncProfileVerify( pDstProfileBaseData->maProfileRef, &errors, &warnings ) )
		{
			LogErrorDescription( errors );
			LogErrorDescription( warnings );
			
			std::cerr << ">> ERROR: Cloning the profile reference during object copy failed!" << std::endl;
		} // if
	} // if
	
	return( pDstProfileBaseData );
} // ColorProfileBaseCopyData

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Constructors

//---------------------------------------------------------------------------

ColorProfileBase::ColorProfileBase()
{
	mpProfileBaseData = new ColorProfileBaseData;
	
	if( mpProfileBaseData != NULL )
	{
		mpProfileBaseData->mnDirectDisplayID = CGMainDisplayID();
		
		ColorProfileBaseSetDataForDisplay(mpProfileBaseData);
	} // if
} // Constructor

//---------------------------------------------------------------------------

ColorProfileBase::ColorProfileBase( const CGDirectDisplayID nDirectDisplayID )
{
	mpProfileBaseData = new ColorProfileBaseData;
	
	if( mpProfileBaseData != NULL )
	{
		mpProfileBaseData->mnDirectDisplayID = nDirectDisplayID;
		
		ColorProfileBaseSetDataForDisplay(mpProfileBaseData);
	} // if
} // Constructor

//---------------------------------------------------------------------------

ColorProfileBase::ColorProfileBase( const ColorSyncProfileRef pDisplayProfile )
{
	if( pDisplayProfile != NULL )
	{
		mpProfileBaseData = new ColorProfileBaseData;
		
		if( mpProfileBaseData != NULL )
		{
			mpProfileBaseData->mnEncoding        = kCFStringEncodingUTF8;
			mpProfileBaseData->mnDirectDisplayID = 0;
			mpProfileBaseData->maProfileRef      = NULL;
			
			mpProfileBaseData->maProfileDescription = ColorSyncProfileCopyDescriptionString( mpProfileBaseData->maProfileRef );
		} // if
	} // if
} // Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Destructor

//---------------------------------------------------------------------------

ColorProfileBase::~ColorProfileBase()
{
	if( mpProfileBaseData != NULL )
	{
		if( mpProfileBaseData->maProfileRef != NULL )
		{
			CFRelease(mpProfileBaseData->maProfileRef);
		} // if
		
		if( mpProfileBaseData->maProfileDescription != NULL )
		{
			CFRelease(mpProfileBaseData->maProfileDescription);
		} // if
		
		delete mpProfileBaseData;
	} // if
} // Destructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Copy Constructor

//---------------------------------------------------------------------------

ColorProfileBase::ColorProfileBase( const ColorProfileBase &rProfileBase )
{
	if( rProfileBase.mpProfileBaseData != NULL )
	{
		mpProfileBaseData = ColorProfileBaseCopyData(rProfileBase.mpProfileBaseData);
	} // if
} // Copy Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Assignment Operator

//---------------------------------------------------------------------------

ColorProfileBase &ColorProfileBase::operator=(const ColorProfileBase &rProfileBase)
{
	if( ( this != &rProfileBase ) && ( rProfileBase.mpProfileBaseData != NULL ) )
	{
		if( mpProfileBaseData != NULL )
		{
			if( mpProfileBaseData->maProfileDescription != NULL )
			{
				CFRelease(mpProfileBaseData->maProfileDescription);
			} // if
			
			delete mpProfileBaseData;
		} // if
		
		mpProfileBaseData = ColorProfileBaseCopyData(rProfileBase.mpProfileBaseData);
	} // if
	
	return *this;
} // ColorProfileBase::operator=

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Accessors

//---------------------------------------------------------------------------

const CGDirectDisplayID  ColorProfileBase::GetDirectDisplayID() const
{
	if( mpProfileBaseData != NULL )
	{
		return( mpProfileBaseData->mnDirectDisplayID );
	} // if
	
	return( 0 );
} // ColorProfileBase::GetDirectDisplayID

//---------------------------------------------------------------------------

const ColorSyncProfileRef ColorProfileBase::GetProfileRef() const
{
	if( mpProfileBaseData != NULL )
	{
		return( mpProfileBaseData->maProfileRef );
	} // if
	
	return( NULL );
} // ColorProfileBase::GetProfileRef

//---------------------------------------------------------------------------

const CFStringEncoding ColorProfileBase::GetProfileDescriptionEncoding() const
{
	if( mpProfileBaseData != NULL )
	{
		return( mpProfileBaseData->mnEncoding );
	} // if
	
	return( kCFStringEncodingUTF8 );
} // ColorProfileBase::GetProfileDescriptionEncoding

//---------------------------------------------------------------------------

const CFStringRef ColorProfileBase::GetProfileDescription() const
{
	if( mpProfileBaseData != NULL )
	{
		return( mpProfileBaseData->maProfileDescription );
	} // if
	
	return( NULL );
} // ColorProfileBase::GetProfileDescription

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
