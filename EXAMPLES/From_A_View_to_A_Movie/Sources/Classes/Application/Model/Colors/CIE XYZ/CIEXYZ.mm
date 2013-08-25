//---------------------------------------------------------------------------
//
//	File: CIEXYZ.mm
//
//  Abstract: Base utility for getting the CIE XYZ values from ColorSync
//            profile
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

#include "Colors.h"
#include "CIEXYZ.hpp"

#include <ICC.h>

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Definitions

//---------------------------------------------------------------------------

#define kTagRedColorant      CFSTR("rXYZ")
#define kTagGreenColorant    CFSTR("gXYZ")
#define kTagBlueColorant     CFSTR("bXYZ")
#define kTagMediaWhitePoint  CFSTR("wtpt")

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Constants

//---------------------------------------------------------------------------

static const int32_t kFixed  = int32_t(0x00010000L);

static const CFIndex kCapacityCIEDictionary = 4;
static const CFIndex kCapacityCIEArray      = 3;

static const CFStringRef kSignatures[4] = {	kTagRedColorant, 
											kTagGreenColorant, 
											kTagBlueColorant, 
											kTagMediaWhitePoint	};

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Class - CIE XYZ Attributes

//---------------------------------------------------------------------------

template <typename Real> 
class CIEXYZData
{
	public:
		Real  maCIEMatrix[4][3];
		
		CFMutableDictionaryRef maCIEDictionary;
};

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - CIE XYZ Attributes

//---------------------------------------------------------------------------

template class CIEXYZData<float>;
template class CIEXYZData<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - Math

//---------------------------------------------------------------------------

template <typename Real>
static inline Real Fixed2Float( const uint32_t nFixedNum )
{
	return( Real(nFixedNum) / Real(kFixed) );
} // Fixed2Float

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - Color Primaries

//---------------------------------------------------------------------------

template <typename Real>
static CFNumberType CIEXYZGetNumberType()
{
	std::string aTypeId = typeid( Real ).name();
	
	CFNumberType aNumberType;
	
	if( aTypeId == "f" ) 
	{
		aNumberType = kCFNumberFloatType;
	} // if
	else 
	{
		aNumberType = kCFNumberDoubleType;
	} // else
	
	return( aNumberType );
} // CIEXYZGetNumberType

//---------------------------------------------------------------------------

template <typename Real>
void CIEXYZ<Real>::CIEXYZCreateDictionary(const CFStringRef *pSignatures)
{
	mpCIEXYZ->maCIEDictionary = CFDictionaryCreateMutable(kCFAllocatorDefault, 
														  kCapacityCIEDictionary, 
														  &kCFCopyStringDictionaryKeyCallBacks, 
														  &kCFTypeDictionaryValueCallBacks);
	
	if( mpCIEXYZ->maCIEDictionary != NULL )
	{
		CFIndex i;
		CFIndex j;
		
		CFMutableArrayRef pCIEXYZArray = NULL;
		CFNumberRef       pNumber      = NULL;
		CFNumberType      nType        = CIEXYZGetNumberType<Real>();
		Real              nColor       = 0;
		
		for( i = 0; i < 4; i++ )
		{
			pCIEXYZArray = CFArrayCreateMutable(kCFAllocatorDefault, 
												kCapacityCIEArray, 
												&kCFTypeArrayCallBacks);
			
			if( pCIEXYZArray != NULL )
			{
				for( j = 0; j < 3; j++ )
				{
					nColor = mpCIEXYZ->maCIEMatrix[i][j];
					
					pNumber = CFNumberCreate(kCFAllocatorDefault, 
											 nType, 
											 &nColor);
					
					if( pNumber != NULL )
					{
						CFArraySetValueAtIndex(pCIEXYZArray, j, pNumber);
					
						CFRelease(pNumber);
					} // if
				} // for
				
				CFDictionarySetValue(mpCIEXYZ->maCIEDictionary, 
									 pSignatures[i], 
									 pCIEXYZArray);
				
				CFRelease(pCIEXYZArray);
			} // if
		} // for
	} // if
} // CIEXYZCreateDictionary

//---------------------------------------------------------------------------

template <typename Real>
bool CIEXYZ<Real>::CIEXYZGetReferenceColor(const ColorSyncProfileRef pProfile,
										   const uint32_t nColorIndex,
										   CFStringRef pSignature)
{
	bool success = false;
	
	CFDataRef pTagData = ColorSyncProfileCopyTag(pProfile, pSignature);
	
	if( pTagData != NULL )
	{
		const uint8_t *ptr = CFDataGetBytePtr( pTagData );
		
		if( ptr != NULL )
		{
			icXYZType xyzTag = *(icXYZType*)ptr;
			
			FourCharCode tagType = CFSwapInt32BigToHost( xyzTag.base.sig );
			
			if( tagType == icSigXYZType )
			{
				mpCIEXYZ->maCIEMatrix[nColorIndex][kCIEX] = Fixed2Float<Real>(CFSwapInt32BigToHost(xyzTag.data.data[0].X));
				mpCIEXYZ->maCIEMatrix[nColorIndex][kCIEY] = Fixed2Float<Real>(CFSwapInt32BigToHost(xyzTag.data.data[0].Y));
				mpCIEXYZ->maCIEMatrix[nColorIndex][kCIEZ] = Fixed2Float<Real>(CFSwapInt32BigToHost(xyzTag.data.data[0].Z));
				
				success = true;
			} // if
		} // if
		
		CFRelease( pTagData );
	} // if
	
	return( success );
} // ColorProfileGetReferenceColor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - Set Profile Data

//---------------------------------------------------------------------------

template <typename Real>
bool CIEXYZ<Real>::CIEXYZSetDataForDisplay(const ColorSyncProfileRef pProfile) 
{
	bool bSuccess = false;

	if( pProfile != NULL )
	{
		uint32_t nColorIndex = 0;
		
		bSuccess = true;
		
		while( ( bSuccess ) && ( nColorIndex < 4 ) )
		{
			bSuccess = CIEXYZGetReferenceColor(pProfile, 
											   nColorIndex, 
											   kSignatures[nColorIndex]);
			
			nColorIndex++;
		} // if
		
		if( bSuccess )
		{
			CIEXYZCreateDictionary(kSignatures);
		} // if
	} // if

	return( bSuccess );
} // CIEXYZSetDataForDisplay

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - Memory Management

//---------------------------------------------------------------------------

template <typename Real>
void CIEXYZ<Real>::CIEXYZCopyData( const CIEXYZ<Real> &rCIEXYZ ) 
{
	mpCIEXYZ = new CIEXYZData<Real>;
	
	if( mpCIEXYZ != NULL )
	{
		uint32_t i;
		uint32_t j;
		
		for( i = 0; i < 4; i++ )
		{
			for( j = 0; j < 3; j++ )
			{
				mpCIEXYZ->maCIEMatrix[i][j] = rCIEXYZ.mpCIEXYZ->maCIEMatrix[i][j];
			} // for
		} // for
		
		CIEXYZCreateDictionary(kSignatures);
	} // if
} // CIEXYZCopyData

//---------------------------------------------------------------------------

template <typename Real>
void CIEXYZ<Real>::CIEXYZReleaseData() 
{
	if( mpCIEXYZ != NULL )
	{
		if( mpCIEXYZ->maCIEDictionary != NULL )
		{
			CFRelease( mpCIEXYZ->maCIEDictionary );
		} // if
		
		delete mpCIEXYZ;
	} // if
} // CIEXYZReleaseData

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Constructors

//---------------------------------------------------------------------------

template <typename Real>
CIEXYZ<Real>::CIEXYZ()
{
	mpCIEXYZ = new CIEXYZData<Real>;
	
	if( mpCIEXYZ != NULL )
	{
		CGDirectDisplayID   nDirectDisplayID = CGMainDisplayID();
		ColorSyncProfileRef aProfileRef      = ColorSyncProfileCreateWithDisplayID( nDirectDisplayID );
		
		if( aProfileRef != NULL )
		{
			CIEXYZSetDataForDisplay(aProfileRef);
			
			CFRelease(aProfileRef);
		} // if
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
CIEXYZ<Real>::CIEXYZ( const CGDirectDisplayID nDisplayID )
{
	mpCIEXYZ = new CIEXYZData<Real>;
	
	if( mpCIEXYZ != NULL )
	{
		ColorSyncProfileRef aProfileRef = ColorSyncProfileCreateWithDisplayID( nDisplayID );
	
		if( aProfileRef != NULL )
		{
			CIEXYZSetDataForDisplay(aProfileRef);

			CFRelease(aProfileRef);
		} // if
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
CIEXYZ<Real>::CIEXYZ( const ColorSyncProfileRef pDisplayProfile )
{
	if( pDisplayProfile != NULL )
	{
		mpCIEXYZ = new CIEXYZData<Real>;
		
		if( mpCIEXYZ != NULL )
		{
			CIEXYZSetDataForDisplay(pDisplayProfile);
		} // if
	} // if
} // Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Destructor

//---------------------------------------------------------------------------

template <typename Real>
CIEXYZ<Real>::~CIEXYZ()
{
	CIEXYZReleaseData();
} // Destructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Copy Constructor

//---------------------------------------------------------------------------

template <typename Real>
CIEXYZ<Real>::CIEXYZ( const CIEXYZ<Real> &rCIEXYZ )
{
	if( rCIEXYZ.mpCIEXYZ != NULL )
	{
		CIEXYZCopyData(rCIEXYZ);
	} // if
} // Copy Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Assignment Operator

//---------------------------------------------------------------------------

template <typename Real>
CIEXYZ<Real> &CIEXYZ<Real>::operator=(const CIEXYZ<Real> &rCIEXYZ)
{
	if( ( this != &rCIEXYZ ) && ( rCIEXYZ.mpCIEXYZ != NULL ) )
	{
		CIEXYZReleaseData();
		CIEXYZCopyData(rCIEXYZ);
	} // if

	return *this;
} // CIEXYZ::operator=

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Accessors


//---------------------------------------------------------------------------

template <typename Real>
const CFMutableDictionaryRef CIEXYZ<Real>::GetDictionary() const
{
	return( mpCIEXYZ->maCIEDictionary );
} // CIEXYZ::GetDictionary

//---------------------------------------------------------------------------

template <typename Real>
const Real *CIEXYZ<Real>::GetRedColorant() const
{
	return( mpCIEXYZ->maCIEMatrix[kColorRed] );
} // CIEXYZ::GetRedColorant

//---------------------------------------------------------------------------

template <typename Real>
const Real *CIEXYZ<Real>::GetGreenColorant() const
{
	return( mpCIEXYZ->maCIEMatrix[kColorGreen] );
} // CIEXYZ::GetGreenColorant

//---------------------------------------------------------------------------

template <typename Real>
const Real *CIEXYZ<Real>::GetBlueColorant() const
{
	return( mpCIEXYZ->maCIEMatrix[kColorBlue] );
} // CIEXYZ::GetBlueColorant

//---------------------------------------------------------------------------

template <typename Real>
const Real *CIEXYZ<Real>::GetMediaWhitePoint() const
{
	return( mpCIEXYZ->maCIEMatrix[kColorWhitePoint] );
} // CIEXYZ::GetMediaWhitePoint

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - CIE XYZ

//---------------------------------------------------------------------------

template class CIEXYZ<float>;
template class CIEXYZ<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
