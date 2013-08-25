//---------------------------------------------------------------------------
//
//	File: ChromaticAdaptation.hpp
//
//  Abstract: Utility class for chromatic adaptation computation
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

#include "Colors.h"
#include "ChromaticAdaptation.hpp"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

template <typename Real>
void ChromaticAdaptation<Real>::GetMatrix()
{
	const Real *pCRDScale = this->GetScale();
	
	if( ( pCRDScale[kCIEX] == 1.0 ) && ( pCRDScale[kCIEY] == 1.0 ) && ( pCRDScale[kCIEZ] == 1.0 ) )
	{
		const Real  pCAIdentityMatrix[9] = { 1.0, 0.0, 0.0, 
											 0.0, 1.0, 0.0,
											 0.0, 0.0, 1.0 };
		
		mpCAMatrix->create(3,3);
		mpCAMatrix->setMatrix(pCAIdentityMatrix);
	} // if
	else
	{
		Real aSVector[9];
		
		aSVector[0] = pCRDScale[0] * this->maBAMatrixInv[0][0];
		aSVector[1] = pCRDScale[0] * this->maBAMatrixInv[0][1];
		aSVector[2] = pCRDScale[0] * this->maBAMatrixInv[0][2];
		
		aSVector[3] = pCRDScale[1] * this->maBAMatrixInv[1][0];
		aSVector[4] = pCRDScale[1] * this->maBAMatrixInv[1][1];
		aSVector[5] = pCRDScale[1] * this->maBAMatrixInv[1][2];

		aSVector[6] = pCRDScale[2] * this->maBAMatrixInv[2][0];
		aSVector[7] = pCRDScale[2] * this->maBAMatrixInv[2][1];
		aSVector[8] = pCRDScale[2] * this->maBAMatrixInv[2][2];
		
		const Real *pBAVector = &this->maBAMatrix[0][0];

		Matrix<Real> aSMatrix(3, 3, 1.0E-7, aSVector);
		Matrix<Real> aBMatrix(3, 3, 1.0E-7, pBAVector);
		
		*mpCAMatrix = aBMatrix * aSMatrix;
	} // else
} // ChromaticAdaptation::GetMatrix

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Constructors

//---------------------------------------------------------------------------

template <typename Real>
ChromaticAdaptation<Real>::ChromaticAdaptation()
: ConeResponseDomain<Real>::ConeResponseDomain()
{
	mpCAMatrix = new Matrix<Real>;
	
	if( mpCAMatrix != NULL )
	{
		GetMatrix();
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ChromaticAdaptation<Real>::ChromaticAdaptation( const CGDirectDisplayID nDisplayID )
: ConeResponseDomain<Real>::ConeResponseDomain(nDisplayID)
{
	mpCAMatrix = new Matrix<Real>;
	
	if( mpCAMatrix != NULL )
	{
		GetMatrix();
	} // if
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
ChromaticAdaptation<Real>::ChromaticAdaptation( const ColorSyncProfileRef pDisplayProfile )
: ConeResponseDomain<Real>::ConeResponseDomain(pDisplayProfile)
{
	mpCAMatrix = new Matrix<Real>;
	
	if( mpCAMatrix != NULL )
	{
		GetMatrix();
	} // if
} // Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Destructor

//---------------------------------------------------------------------------

template <typename Real>
ChromaticAdaptation<Real>::~ChromaticAdaptation()
{
	if( mpCAMatrix != NULL )
	{
		delete mpCAMatrix;
	} // if
} // Destructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Copy Constructor

//---------------------------------------------------------------------------

template <typename Real>
ChromaticAdaptation<Real>::ChromaticAdaptation( const ChromaticAdaptation<Real> &rCA )
: ConeResponseDomain<Real>::ConeResponseDomain(rCA)
{
	if( rCA.mpCAMatrix != NULL )
	{
		mpCAMatrix = new Matrix<Real>;
		
		if( mpCAMatrix != NULL )
		{
			*mpCAMatrix = *rCA.mpCAMatrix;
		} // if
	} // if
} // Copy Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Assignment Operator

//---------------------------------------------------------------------------

template <typename Real>
ChromaticAdaptation<Real> &ChromaticAdaptation<Real>::operator=(const ChromaticAdaptation<Real> &rCA)
{
	if( ( this != &rCA ) && ( rCA.mpCAMatrix != NULL ) )
	{
		if( mpCAMatrix != NULL )
		{
			delete mpCAMatrix;
		} // if
		
		this->ConeResponseDomain<Real>::operator=(rCA);

		mpCAMatrix = new Matrix<Real>;
		
		if( mpCAMatrix != NULL )
		{
			*mpCAMatrix = *rCA.mpCAMatrix;
		} // if
	} // if
	
	return *this;
} // ChromaticAdaptation::operator=

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Accessors

//---------------------------------------------------------------------------

template <typename Real>
const Matrix<Real> *ChromaticAdaptation<Real>::CAMatrix() const
{
	if( mpCAMatrix != NULL )
	{
		return( mpCAMatrix );
	} // if
	
	return( NULL );
} // ChromaticAdaptation::CAMatrix

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - Chromatic Adaptation

//---------------------------------------------------------------------------

template class ChromaticAdaptation<float>;
template class ChromaticAdaptation<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
