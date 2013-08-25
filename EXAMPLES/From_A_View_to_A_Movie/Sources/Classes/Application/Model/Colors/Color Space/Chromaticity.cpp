//---------------------------------------------------------------------------
//
//	File: Chromaticity.cpp
//
//  Abstract: Chromaticity initialization utility class
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

#include <cstring>
#include <iostream>

#include "Chromaticity.hpp"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

enum
{
	kxRedPrimary = 0,
	kyRedPrimary,
	kzRedPrimary,
	kxGreenPrimary,
	kyGreenPrimary,
	kzGreenPrimary,
	kxBluePrimary,
	kyBluePrimary,
	kzBluePrimary,
	kxWhitePoint,
	kyWhitePoint,
	kzWhitePoint
};

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Constructors

//---------------------------------------------------------------------------

template <typename Real>
Chromaticity<Real>::Chromaticity()
{
	mnChromaticity = 12 * sizeof(Real);
	
	std::memset( maChromaticity, 0, mnChromaticity );
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
Chromaticity<Real>::Chromaticity( const Real * const pChromaticity )
{
	mnChromaticity = 12 * sizeof(Real);

	std::memset( maChromaticity, 0, mnChromaticity );

	SetChromaticity( pChromaticity );
} // Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Copy Constructor

//---------------------------------------------------------------------------

template <typename Real>
Chromaticity<Real>::Chromaticity(const Chromaticity<Real> &rRGBWorkingSpace)
{
	std::memcpy(maChromaticity,
				rRGBWorkingSpace.maChromaticity,
				mnChromaticity);
} // Copy Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Assignment Operator

//---------------------------------------------------------------------------

template <typename Real>
Chromaticity<Real> &Chromaticity<Real>::operator=(const Chromaticity<Real> &rRGBWorkingSpace)
{
	std::memcpy(maChromaticity,
				rRGBWorkingSpace.maChromaticity,
				mnChromaticity);
	
	return *this;
} // Chromaticity::operator=

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Getters

//---------------------------------------------------------------------------

template <typename Real>
const Real *Chromaticity<Real>::GetChromaticity() const
{
	return maChromaticity;
} // Chromaticity::GetChromaticity

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Setters

//---------------------------------------------------------------------------

template <typename Real>
void Chromaticity<Real>::SetChromaticity( const Real * const pChromaticity )
{
	if( pChromaticity != NULL )
	{
		maChromaticity[kxRedPrimary] = pChromaticity[0];
		maChromaticity[kyRedPrimary] = pChromaticity[1];
		maChromaticity[kzRedPrimary] = 1.0 - maChromaticity[kxRedPrimary] - maChromaticity[kyRedPrimary];

		maChromaticity[kxGreenPrimary] = pChromaticity[2];
		maChromaticity[kyGreenPrimary] = pChromaticity[3];
		maChromaticity[kzGreenPrimary] = 1.0 - maChromaticity[kxGreenPrimary] - maChromaticity[kyGreenPrimary];

		maChromaticity[kxBluePrimary] = pChromaticity[4];
		maChromaticity[kyBluePrimary] = pChromaticity[5];
		maChromaticity[kzBluePrimary] = 1.0 - maChromaticity[kxBluePrimary] - maChromaticity[kyBluePrimary];

		maChromaticity[kxWhitePoint] = pChromaticity[6];
		maChromaticity[kyWhitePoint] = pChromaticity[7];
		maChromaticity[kzWhitePoint] = 1.0 - maChromaticity[kxWhitePoint] - maChromaticity[kyWhitePoint];
	} // if
} // Chromaticity::SetChromaticity

//---------------------------------------------------------------------------

template <typename Real>
Real &Chromaticity<Real>::operator()(const long nColor, const long nCoordinate)
{	
	if( ( nColor < 0 ) || ( nColor > 3 ) )
	{
		std::cerr	<< ">> ERROR: Color " 
					<< nColor 
					<< " is not part of the Chromaticity matrix!" 
					<< std::endl;
		
		return maChromaticity[0];
	} // if
	
	if( ( nCoordinate < 0 ) || ( nCoordinate > 2 ) )
	{
		std::cerr	<< ">> ERROR: The coordinate " 
					<< nCoordinate 
					<< " is not part of the Chromaticity matrix!" 
					<< std::endl;
		
		return maChromaticity[0];
	} // if
	
	const long k = 3 * nColor + nCoordinate;
	
	return  maChromaticity[k];
} // Chromaticity::operator()

//---------------------------------------------------------------------------

template <typename Real>
Real Chromaticity<Real>::operator()(const long nColor, const long nCoordinate) const
{	
	if( ( nColor < 0 ) || ( nColor > 3 ) )
	{
		std::cerr	<< ">> ERROR: Color " 
					<< nColor 
					<< " is not part of the Chromaticity matrix!" 
					<< std::endl;
					
		return maChromaticity[0];
	} // if
	
	if( ( nCoordinate < 0 ) || ( nCoordinate > 2 ) )
	{
		std::cerr	<< ">> ERROR: The coordinate " 
					<< nCoordinate 
					<< " is not part of the Chromaticity matrix!" 
					<< std::endl;
		
		return maChromaticity[0];
	} // if
	
	const long k = 3 * nColor + nCoordinate;
	
	return  maChromaticity[k];
} // Chromaticity::operator()

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - Chromaticity

//---------------------------------------------------------------------------

template class Chromaticity<float>;
template class Chromaticity<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

