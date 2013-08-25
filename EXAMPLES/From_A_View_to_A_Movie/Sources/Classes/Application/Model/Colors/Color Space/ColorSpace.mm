//---------------------------------------------------------------------------
//
//	File: ColorSpace.cpp
//
//  Abstract: Class for basic color space operations
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
//  Copyright (c) 2008 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#include <cmath>
#include <iostream>

//---------------------------------------------------------------------------

#include "Colors.h"
#include "ColorSpace.hpp"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Class - Color Space Attributes

//---------------------------------------------------------------------------

template <typename Real> 
class ColorSpaceData
{
	public:
	
		//-------------------------------------------------------------------
		//
		// Output device gamma.
		//
		//-------------------------------------------------------------------
		//
		// The recommended transfer function for the output device is used
		// here, not the inverse of the transfer function of the camera.
		//
		// This means we use the model 
		//
		//                    γ
		//		L = ( E' + Δ ) 
		//
		// instead of inverting the equations
		//
		//		E' = α L, for L ≤ δ ;
		//
		//                      β
		//		E' = ( 1 + ε ) L  - ε,  for L > δ .
		//
		// with ε = 0.099, δ = 0.018, α = 4.5, β = 1/γ, and γ = 2.2.  
		// Note that γ is usually intentionally not defined as 1/γ, to 
		// produce an expansion of contrast on the output device which 
		// is generally more pleasing. Also, ∆ is the free parameter and 
		// γ held ﬁxed. The conversion function presented here is an 
		// idealized version with ∆ = 0.
		//
		// We want to use the γ of the output device, since that is what  
		// people will actually see.
		//
		//-------------------------------------------------------------------
		//
		// Rec 709 does not specify a gamma for the output device. Only   
		// the gamma of the input device (0.45) is given. Typical CRTs   
		// have a gamma value of 2.5, which yields an overall gamma of  
		// 1.125 - which is within the 1.1 to 1.2 range, usually used   
		// with the dim viewing environment assumed for television.
		//
		//-------------------------------------------------------------------
	
		Real mnDisplayGamma;
	
		//-------------------------------------------------------------------
		//
		// Scaling factors for multipication with input linear RGB values
		//
		//-------------------------------------------------------------------

		Real maScale[3];
		
		//-------------------------------------------------------------------
		//
		// The RGB to CIE XYZ conversion martix and its inverse.
		//
		// This is derived from the a RGB work space 4x2 matrix.
		//
		//-------------------------------------------------------------------

		Matrix<Real> *mmRGB2XYZ;
		Matrix<Real> *mmRGB2XYZInv;
};

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - Color Space Attributes

//---------------------------------------------------------------------------

template class ColorSpaceData<float>;
template class ColorSpaceData<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Color Space Structure

//---------------------------------------------------------------------------

template <typename Real>
void ColorSpace<Real>::ColorSpaceReleaseData()
{
	if( mpCS != NULL )
	{
		if( mpCS->mmRGB2XYZ != NULL )
		{
			delete mpCS->mmRGB2XYZ;
		} // if
		
		if( mpCS->mmRGB2XYZInv != NULL )
		{
			delete mpCS->mmRGB2XYZInv;
		} // if
		
		delete mpCS;
		
		mpCS = NULL;
	} // if
} // ColorSpace::ColorSpaceReleaseData

//---------------------------------------------------------------------------

template <typename Real>
bool ColorSpace<Real>::ColorSpaceCreateData()
{
	bool bCSAttribsCreated = false;
	
	mpCS = new ColorSpaceData<Real>;
	
	bCSAttribsCreated = mpCS != NULL;
	
	if( bCSAttribsCreated )
	{
		mpCS->mmRGB2XYZ = new Matrix<Real>;
		
		bCSAttribsCreated = bCSAttribsCreated && ( mpCS->mmRGB2XYZ != NULL );
		
		mpCS->mmRGB2XYZInv = new Matrix<Real>;

		bCSAttribsCreated = bCSAttribsCreated && ( mpCS->mmRGB2XYZInv != NULL );

		if( !bCSAttribsCreated )
		{
			ColorSpaceReleaseData();
		} // if
	} // if
	
	return bCSAttribsCreated;
} // ColorSpace::ColorSpaceCreateData

//---------------------------------------------------------------------------

template <typename Real>
void ColorSpace<Real>::ColorSpaceSetData()
{
	Real  xWhite = 0.0;
	Real  zWhite = 0.0;
	
	long i;
	
	Matrix<Real> CIEXYZ(3, 3, 1E-7);
	
	for( i = kColorRed; i < kColorWhitePoint; i++ )
	{
		CIEXYZ(kCIEX,i) = (*this)(i,kCIEx) / (*this)(i,kCIEy);
		CIEXYZ(kCIEY,i) = 1.0f;
		CIEXYZ(kCIEZ,i) = (*this)(i,kCIEz) / (*this)(i,kCIEy);
	} // for
	
	Matrix<Real> CIEXYZInv( CIEXYZ );
	
	CIEXYZInv.inv();
	
	mpCS->mmRGB2XYZ->create(3, 3);
	
	xWhite = (*this)(kColorWhitePoint,kCIEx) / (*this)(kColorWhitePoint,kCIEy);
	zWhite = (*this)(kColorWhitePoint,kCIEz) / (*this)(kColorWhitePoint,kCIEy);
	
	for( i = kColorRed; i < kColorWhitePoint; i++ )
	{
		mpCS->maScale[i] = CIEXYZInv(i,kColorRed) * xWhite 
								+ CIEXYZInv(i,kColorGreen) 
								+ CIEXYZInv(i,kColorBlue) * zWhite;
		
		(*mpCS->mmRGB2XYZ)(kCIEX,i) = CIEXYZ(kCIEX,i) * mpCS->maScale[i];
		(*mpCS->mmRGB2XYZ)(kCIEY,i) = CIEXYZ(kCIEY,i) * mpCS->maScale[i];
		(*mpCS->mmRGB2XYZ)(kCIEZ,i) = CIEXYZ(kCIEZ,i) * mpCS->maScale[i];
	} // for

	(*mpCS->mmRGB2XYZ).transpose();
	
	*mpCS->mmRGB2XYZInv = *mpCS->mmRGB2XYZ;
	
	mpCS->mmRGB2XYZInv->inv();
} // ColorSpace::ColorSpaceSetData

//---------------------------------------------------------------------------

template <typename Real>
void ColorSpace<Real>::ColorSpaceSetChromaticity( const Real * const pChromaticity )
{
	if( pChromaticity != NULL )
	{
		this->SetChromaticity(pChromaticity);
	} // if
	else
	{
		static const Real TRec709WorkingSpace[4][2] = 
								{
									{	0.64,		0.33		},
									{	0.30,		0.60		},
									{	0.15,		0.06		},
									{	0.312713,	0.329016	}
								};
		
		this->SetChromaticity(&TRec709WorkingSpace[0][0]);
	} // else
} // ColorSpace::ColorSpaceSetChromaticity

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Constructors

//---------------------------------------------------------------------------

template <typename Real>
ColorSpace<Real>::ColorSpace()
: Chromaticity<Real>::Chromaticity(), ColorProfile<Real>::ColorProfile()
{
	if( ColorSpaceCreateData() )
	{
		const Real *pChromaticity = this->GetDisplayChromaticity();
		
		mpCS->mnDisplayGamma = this->GetDisplayGamma();
		
		ColorSpaceSetChromaticity(pChromaticity);		
		ColorSpaceSetData();
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ColorSpace<Real>::ColorSpace( const Real * const pChromaticity ) 
: Chromaticity<Real>::Chromaticity(pChromaticity), ColorProfile<Real>::ColorProfile()
{
	if( ColorSpaceCreateData() )
	{
		mpCS->mnDisplayGamma = this->GetDisplayGamma();
		
		ColorSpaceSetChromaticity(pChromaticity);		
		ColorSpaceSetData();
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ColorSpace<Real>::ColorSpace( const CGDirectDisplayID nDisplayID ) 
: Chromaticity<Real>::Chromaticity(), ColorProfile<Real>::ColorProfile(nDisplayID)
{
	if( ColorSpaceCreateData() )
	{
		const Real *pChromaticity = this->GetDisplayChromaticity();

		mpCS->mnDisplayGamma = this->GetDisplayGamma();
		
		ColorSpaceSetChromaticity(pChromaticity);		
		ColorSpaceSetData();
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ColorSpace<Real>::ColorSpace( const ColorSyncProfileRef pDisplayProfile ) 
: Chromaticity<Real>::Chromaticity(), ColorProfile<Real>::ColorProfile(pDisplayProfile)
{
	if( ColorSpaceCreateData() )
	{
		const Real *pChromaticity = this->GetDisplayChromaticity();
		
		mpCS->mnDisplayGamma = this->GetDisplayGamma();
		
		ColorSpaceSetChromaticity(pChromaticity);		
		ColorSpaceSetData();
	} // if
} // Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Destructor

//---------------------------------------------------------------------------

template <typename Real>
ColorSpace<Real>::~ColorSpace()
{
	ColorSpaceReleaseData();
} // Destructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Copy Constructor

//---------------------------------------------------------------------------

template <typename Real>
ColorSpace<Real>::ColorSpace( const ColorSpace<Real> &rColorSpace )
: ColorProfile<Real>::ColorProfile(rColorSpace), Chromaticity<Real>::Chromaticity(rColorSpace)
{
	if( rColorSpace.mpCS != NULL )
	{
		mpCS = new ColorSpaceData<Real>;
		
		if( mpCS != NULL )
		{
			long i;
			
			for( i = 0; i < 3; i ++ )
			{
				mpCS->maScale[i] = rColorSpace.mpCS->maScale[i];
			} // for
			
			*mpCS->mmRGB2XYZ    = *rColorSpace.mpCS->mmRGB2XYZ;
			*mpCS->mmRGB2XYZInv = *rColorSpace.mpCS->mmRGB2XYZInv;
		} // if
	} // if
} // Copy Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Assignment Operator

//---------------------------------------------------------------------------

template <typename Real>
ColorSpace<Real> &ColorSpace<Real>::operator=(const ColorSpace<Real> &rColorSpace)
{
	if( ( this != &rColorSpace ) && ( rColorSpace.mpCS != NULL ) )
	{
		ColorSpaceReleaseData();
		
		mpCS = new ColorSpaceData<Real>;
		
		if( mpCS != NULL )
		{
			long i;
			
			for( i = 0; i < 3; i ++ )
			{
				mpCS->maScale[i] = rColorSpace.mpCS->maScale[i];
			} // for
			
			*mpCS->mmRGB2XYZ    = *rColorSpace.mpCS->mmRGB2XYZ;
			*mpCS->mmRGB2XYZInv = *rColorSpace.mpCS->mmRGB2XYZInv;
			
			this->ColorProfile<Real>::operator=(rColorSpace);
			
			this->Chromaticity<Real>::operator=(rColorSpace);
		} // if
	} // if
	
	return *this;
} // ColorProfile::operator=

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Accessors

//---------------------------------------------------------------------------

template <typename Real>
const Matrix<Real> *ColorSpace<Real>::CIEMatrix() const
{
	if( ( mpCS != NULL ) && ( mpCS->mmRGB2XYZ != NULL ) )
	{
		return( mpCS->mmRGB2XYZ );
	} // if

	return( NULL );
} // ColorSpace::CIEMatrix

//---------------------------------------------------------------------------

template <typename Real>
const Matrix<Real> *ColorSpace<Real>::CIEMatrixInv() const
{
	if( ( mpCS != NULL ) && ( mpCS->mmRGB2XYZInv != NULL ) )
	{
		return( mpCS->mmRGB2XYZInv );
	} // if
	
	return( NULL );
} // ColorSpace::CIEMatrix

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - Color Space

//---------------------------------------------------------------------------

template class ColorSpace<float>;
template class ColorSpace<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

