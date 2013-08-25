//---------------------------------------------------------------------------
//
//	File: ConeResponseDomain.mm
//
//  Abstract: Utility class for mapping CIE XYZ white point coordinates into 
//            cone response domain space
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

#include <cmath>
#include <iostream>

//---------------------------------------------------------------------------

#include "Colors.h"
#include "CIEXYZ.hpp"
#include "ConeResponseDomain.hpp"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Enumerated Types - Coordinates

//---------------------------------------------------------------------------

enum
{
	kRho = 0,
	kGamma,
	kBeta
};

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Data Structures - Cone Response Domain

//---------------------------------------------------------------------------

template <typename Real>
class ConeResponseDomainData
{
	public:
		Real maSrcWhitePoint[3];
		Real maDstWhitePoint[3];
		Real maScale[3];
		bool mbD65WhitePoints;
}; // ConeResponseDomainData

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Template Implementations - Color Space

//---------------------------------------------------------------------------

template class ConeResponseDomainData<float>;
template class ConeResponseDomainData<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities - White Point Transformation

//---------------------------------------------------------------------------

template <typename Real>
void ConeResponseDomain<Real>::GetSrcWhitePointFromProfile(const ColorSyncProfileRef pProfile)
{
	CIEXYZ<Real> aColor(pProfile);
	
	const Real *pWhitePoint = aColor.GetMediaWhitePoint();
	
	mpCRDData->maSrcWhitePoint[kCIEX] = pWhitePoint[kCIEX];
	mpCRDData->maSrcWhitePoint[kCIEY] = pWhitePoint[kCIEY];
	mpCRDData->maSrcWhitePoint[kCIEZ] = pWhitePoint[kCIEZ];
	
	Real delta[3];
	
	delta[kCIEX] = std::fabs(mpCRDData->maDstWhitePoint[kCIEX] - mpCRDData->maSrcWhitePoint[kCIEX]);
	delta[kCIEY] = std::fabs(mpCRDData->maDstWhitePoint[kCIEY] - mpCRDData->maSrcWhitePoint[kCIEY]);
	delta[kCIEZ] = std::fabs(mpCRDData->maDstWhitePoint[kCIEZ] - mpCRDData->maSrcWhitePoint[kCIEZ]);
	
	mpCRDData->mbD65WhitePoints = ( delta[kCIEX] <= 1.0E-4 ) 
									&& ( delta[kCIEY] <= 1.0E-4 )
									&& ( delta[kCIEZ] <= 1.0E-4 );
} // ConeResponseDomain::GetSrcWhitePointFromProfile

//---------------------------------------------------------------------------

template <typename Real>
void ConeResponseDomain<Real>::GetSrcWhitePoint(const CGDirectDisplayID nDisplayID) 
{
	ColorSyncProfileRef  pProfile = ColorSyncProfileCreateWithDisplayID( nDisplayID );
	
	if( pProfile != NULL )
	{
		GetSrcWhitePointFromProfile(pProfile);
		
		CFRelease(pProfile);
	} // if
} // ConeResponseDomain::GetSrcWhitePoint

//---------------------------------------------------------------------------

template <typename Real>
void ConeResponseDomain<Real>::GetScaleVector()
{
	if( !mpCRDData->mbD65WhitePoints )
	{
		Real src[3];
		Real dst[3];
		
		src[kRho]   = this->maBAMatrix[0][0] * mpCRDData->maSrcWhitePoint[kCIEX] 
							+ this->maBAMatrix[1][0] * mpCRDData->maSrcWhitePoint[kCIEY] 
							+ this->maBAMatrix[2][0] * mpCRDData->maSrcWhitePoint[kCIEZ];
		
		src[kGamma] =  this->maBAMatrix[0][1] * mpCRDData->maSrcWhitePoint[kCIEX] 
							+ this->maBAMatrix[1][1] * mpCRDData->maSrcWhitePoint[kCIEY] 
							+ this->maBAMatrix[2][1] * mpCRDData->maSrcWhitePoint[kCIEZ];
		
		src[kBeta]  = this->maBAMatrix[0][2] * mpCRDData->maSrcWhitePoint[kCIEX]
							+ this->maBAMatrix[1][2] * mpCRDData->maSrcWhitePoint[kCIEY] 
							+ this->maBAMatrix[2][2] * mpCRDData->maSrcWhitePoint[kCIEZ];

		dst[kRho]   = this->maBAMatrix[0][0] * mpCRDData->maDstWhitePoint[kCIEX] 
							+ this->maBAMatrix[1][0] * mpCRDData->maDstWhitePoint[kCIEY] 
							+ this->maBAMatrix[2][0] * mpCRDData->maDstWhitePoint[kCIEZ];
		
		dst[kGamma] =  this->maBAMatrix[0][1] * mpCRDData->maDstWhitePoint[kCIEX] 
							+ this->maBAMatrix[1][1] * mpCRDData->maDstWhitePoint[kCIEY] 
							+ this->maBAMatrix[2][1] * mpCRDData->maDstWhitePoint[kCIEZ];
		
		dst[kBeta]  = this->maBAMatrix[0][2] * mpCRDData->maDstWhitePoint[kCIEX]
							+ this->maBAMatrix[1][2] * mpCRDData->maDstWhitePoint[kCIEY] 
							+ this->maBAMatrix[2][2] * mpCRDData->maDstWhitePoint[kCIEZ];
		
		mpCRDData->maScale[kRho]   = dst[kRho]   / src[kRho];
		mpCRDData->maScale[kGamma] = dst[kGamma] / src[kGamma];
		mpCRDData->maScale[kBeta]  = dst[kBeta]  / src[kBeta];
	} // if
	else
	{
		mpCRDData->maScale[kRho]   = 1.0;
		mpCRDData->maScale[kGamma] = 1.0;
		mpCRDData->maScale[kBeta]  = 1.0;
	} // else
} // ConeResponseDomain::GetScaleVector

//---------------------------------------------------------------------------
//
// For D65 standard observer and starting with CIE xy: { 0.312727, 0.329023 }
//
//---------------------------------------------------------------------------

template <typename Real>
void ConeResponseDomain<Real>::GetDstWhitePoint() 
{
	static const Real D65[2] = { 0.312727, 0.329023 };
	
	mpCRDData->maDstWhitePoint[kCIEX] = D65[kCIEx] / D65[kCIEy];
	mpCRDData->maDstWhitePoint[kCIEY] = 1.0;
	mpCRDData->maDstWhitePoint[kCIEZ] = (1.0 - D65[kCIEx] - D65[kCIEy]) / D65[kCIEy];
} // ConeResponseDomain::GetDstWhitePoint

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Constructors

//---------------------------------------------------------------------------

template <typename Real>
ConeResponseDomain<Real>::ConeResponseDomain()
: BradfordAdaptation<Real>::BradfordAdaptation()
{
	mpCRDData = new ConeResponseDomainData<Real>;
	
	if( mpCRDData != NULL )
	{
		CGDirectDisplayID  nDisplayID = CGMainDisplayID();
		
		GetDstWhitePoint();
		GetSrcWhitePoint(nDisplayID);
		GetScaleVector();
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ConeResponseDomain<Real>::ConeResponseDomain( const CGDirectDisplayID nDisplayID )
: BradfordAdaptation<Real>::BradfordAdaptation()
{
	mpCRDData = new ConeResponseDomainData<Real>;
	
	if( mpCRDData != NULL )
	{
		GetDstWhitePoint();
		GetSrcWhitePoint(nDisplayID);
		GetScaleVector();
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ConeResponseDomain<Real>::ConeResponseDomain( const ColorSyncProfileRef pDisplayProfile )
: BradfordAdaptation<Real>::BradfordAdaptation()
{
	if( pDisplayProfile != NULL )
	{
		mpCRDData = new ConeResponseDomainData<Real>;
		
		if( mpCRDData != NULL )
		{
			GetDstWhitePoint();
			GetSrcWhitePointFromProfile(pDisplayProfile);
			GetScaleVector();
		} // if
	} // if
} // Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Destructor

//---------------------------------------------------------------------------

template <typename Real>
ConeResponseDomain<Real>::~ConeResponseDomain()
{
	if( mpCRDData != NULL )
	{
		delete mpCRDData;
	} // if
} // Destructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Copy Constructor

//---------------------------------------------------------------------------

template <typename Real>
ConeResponseDomain<Real>::ConeResponseDomain( const ConeResponseDomain<Real> &rCRD )
{
	if( rCRD.mpCRDData != NULL )
	{
		mpCRDData = new ConeResponseDomainData<Real>;
		
		if( mpCRDData != NULL )
		{
			long i;
			
			for( i = 0; i < 3; i++ )
			{
				mpCRDData->maSrcWhitePoint[i] = mpCRDData->maSrcWhitePoint[i];
				mpCRDData->maDstWhitePoint[i] = mpCRDData->maDstWhitePoint[i];
				
				mpCRDData->maScale[i] = mpCRDData->maScale[i];
			} // for
		} // if
	} // if
} // Copy Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Assignment Operator

//---------------------------------------------------------------------------

template <typename Real>
ConeResponseDomain<Real> &ConeResponseDomain<Real>::operator=(const ConeResponseDomain<Real> &rCRD)
{
	if( ( this != &rCRD ) && ( rCRD.mpCRDData != NULL ) )
	{
		if( mpCRDData != NULL )
		{
			delete mpCRDData;
		} // if
		
		mpCRDData = new ConeResponseDomainData<Real>;
		
		if( mpCRDData != NULL )
		{
			long i;
			
			for( i = 0; i < 3; i++ )
			{
				mpCRDData->maSrcWhitePoint[i] = mpCRDData->maSrcWhitePoint[i];
				mpCRDData->maDstWhitePoint[i] = mpCRDData->maDstWhitePoint[i];
				
				mpCRDData->maScale[i] = mpCRDData->maScale[i];
			} // for
		} // if
	} // if
	
	return *this;
} // ConeResponseDomain::operator=

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Accessors

//---------------------------------------------------------------------------

template <typename Real>
const Real *ConeResponseDomain<Real>::GetScale() const
{
	if( mpCRDData != NULL )
	{
		return( mpCRDData->maScale );
	} // if
	
	return( NULL );
} // ConeResponseDomain::GetScale

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - Cone Response Domain

//---------------------------------------------------------------------------

template class ConeResponseDomain<float>;
template class ConeResponseDomain<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
