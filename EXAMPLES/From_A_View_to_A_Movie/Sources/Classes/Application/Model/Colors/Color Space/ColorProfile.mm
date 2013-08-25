//---------------------------------------------------------------------------
//
//	File: ColorProfile.mm
//
//  Abstract: Utility class for getting the screen gamma, primary colors,
//            and media white point form the display's ICC profile
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
#include "CIEXYZ.hpp"
#include "ColorProfile.hpp"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Data Structures

//---------------------------------------------------------------------------

template <typename Real>
class ColorProfileData
{
	public:
		Real  maChromaticity[4][2];
		Real  mnDisplayGamma;
}; // ColorProfileData

//---------------------------------------------------------------------------

template class ColorProfileData<float>;
template class ColorProfileData<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - Color Primaries

//---------------------------------------------------------------------------

template <typename Real>
void ColorProfile<Real>::SetDisplayPrimaries(const Real * const pXYZColor,
													 const uint32_t nColorIndex)
{
	Real nXYZColorSum = pXYZColor[kCIEX] + pXYZColor[kCIEY] + pXYZColor[kCIEZ];
	
	mpProfileData->maChromaticity[nColorIndex][kCIEx] = pXYZColor[kCIEX] / nXYZColorSum;
	mpProfileData->maChromaticity[nColorIndex][kCIEy] = pXYZColor[kCIEY] / nXYZColorSum;
} // SetDisplayPrimaries

//---------------------------------------------------------------------------

template <typename Real>
void ColorProfile<Real>::GetDisplayPrimaries(const ColorSyncProfileRef pProfile)
{
	const Real *pRed        = this->GetRedColorant();
	const Real *pGreen      = this->GetGreenColorant();
	const Real *pBlue       = this->GetBlueColorant();
	const Real *pWhitePoint = this->GetMediaWhitePoint();

	SetDisplayPrimaries(pRed, kColorRed);
	SetDisplayPrimaries(pGreen, kColorGreen);
	SetDisplayPrimaries(pBlue, kColorBlue);
	SetDisplayPrimaries(pWhitePoint, kColorWhitePoint);
} // GetDisplayPrimaries

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - Screen Gamma

//---------------------------------------------------------------------------

template <typename Real>
void ColorProfile<Real>::GetDisplayGammaFromProfile(const ColorSyncProfileRef pProfile) 
{
	CFErrorRef pError = NULL;
	
	if( pProfile == NULL ) 
	{
		CGDirectDisplayID nDisplayID = CGMainDisplayID();
		
		mpProfileData->mnDisplayGamma = ColorSyncProfileEstimateGammaWithDisplayID( nDisplayID, &pError );
		
		std::cerr << ">> ERROR: ColorSync profile reference is NULL!" << std::endl;
		std::cerr << ">> WARNING: Returning gamma for the main display!" << std::endl;
	} // if
	else 
	{
		mpProfileData->mnDisplayGamma = ColorSyncProfileEstimateGamma( pProfile, &pError );
	} // else

	LogErrorDescription( pError );
} // GetDisplayGammaFromProfile

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - Set Profile Data

//---------------------------------------------------------------------------

template <typename Real>
void ColorProfile<Real>::SetDisplayData(const ColorSyncProfileRef aProfileRef) 
{
	if( aProfileRef != NULL )
	{
		GetDisplayGammaFromProfile(aProfileRef);
		GetDisplayPrimaries(aProfileRef);
	} // if
} // SetDisplayData

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - Copy Profile Data

//---------------------------------------------------------------------------

template <typename Real>
static ColorProfileData<Real> *ColorProfileCopyData(const ColorProfileData<Real> * const pSrcProfileData) 
{
	ColorProfileData<Real> *pDstProfileData = new ColorProfileData<Real>;
	
	if( pDstProfileData != NULL )
	{
		std::memcpy(pDstProfileData->maChromaticity,
					pSrcProfileData->maChromaticity,
					8 * sizeof(Real) );
		
		pDstProfileData->mnDisplayGamma = pSrcProfileData->mnDisplayGamma;
	} // if
	
	return( pDstProfileData );
} // ColorProfileCopyData

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Constructors

//---------------------------------------------------------------------------

template <typename Real>
ColorProfile<Real>::ColorProfile()
: ColorProfileBase::ColorProfileBase(), CIEXYZ<Real>::CIEXYZ()
{
	mpProfileData = new ColorProfileData<Real>;
	
	if( mpProfileData != NULL )
	{
		ColorSyncProfileRef  aProfileRef = this->GetProfileRef();
		
		SetDisplayData(aProfileRef);
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ColorProfile<Real>::ColorProfile( const CGDirectDisplayID nDisplayID )
: ColorProfileBase::ColorProfileBase(nDisplayID), CIEXYZ<Real>::CIEXYZ(nDisplayID)
{
	mpProfileData = new ColorProfileData<Real>;
	
	if( mpProfileData != NULL )
	{
		ColorSyncProfileRef  aProfileRef = this->GetProfileRef();

		SetDisplayData(aProfileRef);
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ColorProfile<Real>::ColorProfile( const ColorSyncProfileRef pDisplayProfile )
: ColorProfileBase::ColorProfileBase(pDisplayProfile), CIEXYZ<Real>::CIEXYZ(pDisplayProfile)
{
	mpProfileData = new ColorProfileData<Real>;
	
	if( mpProfileData != NULL )
	{
		SetDisplayData(pDisplayProfile);
	} // if
} // Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Destructor

//---------------------------------------------------------------------------

template <typename Real>
ColorProfile<Real>::~ColorProfile()
{
	if( mpProfileData != NULL )
	{
		delete mpProfileData;
	} // if
} // Destructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Copy Constructor

//---------------------------------------------------------------------------

template <typename Real>
ColorProfile<Real>::ColorProfile( const ColorProfile<Real> &rProfile )
: ColorProfileBase::ColorProfileBase(rProfile), CIEXYZ<Real>::CIEXYZ(rProfile)
{
	if( rProfile.mpProfileData != NULL )
	{
		mpProfileData = ColorProfileCopyData<Real>(rProfile.mpProfileData);
	} // if
} // Copy Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Assignment Operator

//---------------------------------------------------------------------------

template <typename Real>
ColorProfile<Real> &ColorProfile<Real>::operator=(const ColorProfile<Real> &rProfile)
{
	if( ( this != &rProfile ) && ( rProfile.mpProfileData != NULL ) )
	{
		if( mpProfileData != NULL )
		{
			delete mpProfileData;
		} // if
		
		this->ColorProfileBase::operator=(rProfile);
		this->CIEXYZ<Real>::operator=(rProfile);
		
		mpProfileData = ColorProfileCopyData<Real>(rProfile.mpProfileData);
	} // if

	return *this;
} // ColorProfile::operator=

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Accessors

//---------------------------------------------------------------------------

template <typename Real>
const Real ColorProfile<Real>::GetDisplayGamma() const
{
	if( mpProfileData != NULL )
	{
		return( mpProfileData->mnDisplayGamma );
	} // if
	
	return( 0.0 );
} // ColorProfile::GetDisplayGamma

//---------------------------------------------------------------------------

template <typename Real>
const Real *ColorProfile<Real>::GetDisplayChromaticity() const
{
	if( mpProfileData != NULL )
	{
		return( &mpProfileData->maChromaticity[0][0] );
	} // if
	
	return( NULL );
} // ColorProfile::GetDisplayChromaticity

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - ICC Profile

//---------------------------------------------------------------------------

template class ColorProfile<float>;
template class ColorProfile<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
