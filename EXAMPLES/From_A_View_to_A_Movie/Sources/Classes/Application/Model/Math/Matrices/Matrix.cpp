//---------------------------------------------------------------------------
//
//	File: Matrix.cpp
//
//  Abstract: Template class for matrix operations, where matrix elements
//            are real numbers
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
//  Copyright (c) 2008-2009 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#include <cmath>
#include <iostream>
#include <new>

//---------------------------------------------------------------------------

#include "Matrix.hpp"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

enum MatrixFlags
{
	kFlagMemAlloced = 0,
	kFlagSquareMatrix,
	kFlagColIsValid,
	kFlagRowIsValid,
	kFlagIsSingular,
	kFlagHaveZeroRows,
	kFlagLUDecomposed
};

typedef MatrixFlags MatrixFlags;

//---------------------------------------------------------------------------

enum MatrixAttribs
{
	kAttribBytes = 0,
	kAttribElemBytes,
	kAttribRowBytes,
	kAttribColBytes,
	kAttribColumns,
	kAttribRows,
	kAttribElements,
	kAttribZeroRowCount
};

typedef MatrixAttribs MatrixAttribs;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Class - Matrix Data

//---------------------------------------------------------------------------

template <typename Real> 
class MatrixData
	{
		public:
			
			bool  maFlag[7];
			
			long  maAttrib[8];
			long *mpRowPerm;
			
			Real  mnTolerance;
			Real  mnSign;
			
			Real *mpColumn;
			Real *mpScale;
			Real *mpDiagonal;
			Real *mpMatrix;
	};

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations - Matrix Data

//---------------------------------------------------------------------------

template class MatrixData<float>;
template class MatrixData<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Memory Utilities

//---------------------------------------------------------------------------

template <typename Real>
static void MatrixDataInitialize(const Real nTolerance,
								 MatrixData<Real> *pData)
{
	
	pData->mnTolerance = nTolerance;
	pData->mnSign      = 0.0;
	
	pData->mpDiagonal = NULL;
	pData->mpMatrix   = NULL;
	pData->mpColumn   = NULL;
	pData->mpScale    = NULL;
	pData->mpRowPerm  = NULL;
	
	pData->maAttrib[kAttribRows]         = 0;
	pData->maAttrib[kAttribColumns]      = 0;
	pData->maAttrib[kAttribElements]     = 0;
	pData->maAttrib[kAttribElemBytes]    = 0;
	pData->maAttrib[kAttribColBytes]     = 0;
	pData->maAttrib[kAttribRowBytes]     = 0;
	pData->maAttrib[kAttribBytes]        = 0;
	pData->maAttrib[kAttribZeroRowCount] = 0;
	
	pData->maFlag[kFlagMemAlloced]   = false;
	pData->maFlag[kFlagSquareMatrix] = false;
	pData->maFlag[kFlagColIsValid]   = false;
	pData->maFlag[kFlagRowIsValid]   = false;
	pData->maFlag[kFlagIsSingular]   = false;
	pData->maFlag[kFlagHaveZeroRows] = false;
	pData->maFlag[kFlagLUDecomposed] = false;
} // MatrixDataInitialize

//---------------------------------------------------------------------------

template <typename Real>
static void MatrixDataRelease(MatrixData<Real> *pData)
{
	if( pData != NULL )
	{
		if( pData->mpRowPerm != NULL )
		{
			delete [] pData->mpRowPerm;
		} // if
		
		if( pData->mpColumn != NULL )
		{
			delete [] pData->mpColumn;
		} // if
		
		if( pData->mpScale != NULL )
		{
			delete [] pData->mpScale;
		} // if
		
		if( pData->mpDiagonal != NULL )
		{
			delete [] pData->mpDiagonal;
		} // if
		
		if( pData->mpMatrix != NULL )
		{
			delete [] pData->mpMatrix;
		} // if

		delete pData;
		
		pData = NULL;
	} // if
} // MatrixDataRelease

//---------------------------------------------------------------------------

template <typename Real>
static void MatrixDataCreate(const long nRows,
							 const long nColumns, 
							 const Real * const pMatrix,
							 MatrixData<Real> *pData)
{
	if( ( nColumns > 1 ) || ( nRows > 1 ) )
	{
		pData->maFlag[kFlagMemAlloced]   = pData != NULL;
		pData->maFlag[kFlagSquareMatrix] = nRows == nColumns;
		pData->maFlag[kFlagColIsValid]   = nColumns > 2;
		pData->maFlag[kFlagRowIsValid]   = nRows > 2;
		
		pData->maAttrib[kAttribRows]      = nRows;
		pData->maAttrib[kAttribColumns]   = nColumns;
		pData->maAttrib[kAttribElements]  = nRows * nColumns;
		pData->maAttrib[kAttribElemBytes] = sizeof(Real);
		pData->maAttrib[kAttribColBytes]  = nColumns * pData->maAttrib[kAttribElemBytes];
		pData->maAttrib[kAttribRowBytes]  = nRows * pData->maAttrib[kAttribElemBytes];
		pData->maAttrib[kAttribBytes]     = pData->maAttrib[kAttribElements] * pData->maAttrib[kAttribElemBytes];
		
		pData->mpMatrix = new Real[pData->maAttrib[kAttribElements]];
		
		pData->maFlag[kFlagMemAlloced] = pData->maFlag[kFlagMemAlloced] && pData->mpMatrix != NULL;
		
		if( pData->maFlag[kFlagMemAlloced] )
		{
			pData->mpColumn = new Real[pData->maAttrib[kAttribColumns]];
			
			pData->maFlag[kFlagMemAlloced] = pData->maFlag[kFlagMemAlloced] && ( pData->mpColumn != NULL );
			
			pData->mpScale = new Real[pData->maAttrib[kAttribColumns]];
			
			pData->maFlag[kFlagMemAlloced] = pData->maFlag[kFlagMemAlloced] && ( pData->mpScale != NULL );
			
			pData->mpDiagonal = new Real[pData->maAttrib[kAttribColumns]];
			
			pData->maFlag[kFlagMemAlloced] = pData->maFlag[kFlagMemAlloced] && ( pData->mpDiagonal != NULL );
			
			pData->mpRowPerm = new long[pData->maAttrib[kAttribColumns]];
			
			pData->maFlag[kFlagMemAlloced] = pData->maFlag[kFlagMemAlloced] && ( pData->mpRowPerm != NULL );
			
			if( !pData->maFlag[kFlagMemAlloced] )
			{
				MatrixDataRelease(pData);
			} // if
			else
			{
				if( pMatrix != NULL )
				{
					std::memcpy( pData->mpMatrix, pMatrix, pData->maAttrib[kAttribBytes] );
				} // if
				else
				{
					std::memset( pData->mpMatrix, 0x0, pData->maAttrib[kAttribBytes] );
				} // else
			} // else
		} // if
	} // if
} // MatrixDataCreate

//---------------------------------------------------------------------------

template <typename Real>
static MatrixData<Real> *MatrixDataCreateDefault()
{
	MatrixData<Real> *pData = new MatrixData<Real>;
	
	if( pData != NULL )
	{
		MatrixDataInitialize<Real>(1E-7,pData);
	} // if
	
	return pData;
} // MatrixDataCreateDefault

//---------------------------------------------------------------------------

template <typename Real>
static MatrixData<Real> *MatrixDataCreateWithMatrixCopy(const long nRows,
														const long nColumns, 
														const Real * const pMatrix)
{
	MatrixData<Real> *pData = MatrixDataCreateDefault<Real>();
	
	if( pData != NULL )
	{
		MatrixDataCreate<Real>(nRows,nColumns,pMatrix,pData);
	} // if
	
	return pData;
} // MatrixDataCreateWithMatrixCopy

//---------------------------------------------------------------------------

template <typename Real>
static MatrixData<Real> *MatrixDataCreateWithCopy(const MatrixData<Real> * const pDataSrc)
{
	MatrixData<Real> *pDataDst = NULL;
	
	if( ( pDataSrc != NULL ) && ( pDataSrc->mpMatrix != NULL ) )
	{
		pDataDst = MatrixDataCreateDefault<Real>();
		
		if( pDataDst != NULL )
		{
			pDataDst->mnSign      = pDataSrc->mnSign;
			pDataDst->mnTolerance = pDataSrc->mnTolerance;
			
			pDataDst->maAttrib[kAttribZeroRowCount] = pDataSrc->maAttrib[kAttribZeroRowCount];
			
			pDataDst->maFlag[kFlagLUDecomposed] = pDataSrc->maFlag[kFlagLUDecomposed];
			pDataDst->maFlag[kFlagIsSingular]   = pDataSrc->maFlag[kFlagIsSingular];
			pDataDst->maFlag[kFlagHaveZeroRows] = pDataSrc->maFlag[kFlagHaveZeroRows];
			
			MatrixDataCreate<Real>(pDataSrc->maAttrib[kAttribRows], 
								   pDataSrc->maAttrib[kAttribColumns], 
								   pDataSrc->mpMatrix,
								   pDataDst);
			
			if( pDataDst->maFlag[kFlagMemAlloced] )
			{
				std::memcpy( pDataDst->mpDiagonal, pDataSrc->mpDiagonal, pDataDst->maAttrib[kAttribColBytes]);
				std::memcpy(   pDataDst->mpColumn,   pDataSrc->mpColumn, pDataDst->maAttrib[kAttribColBytes]);
				std::memcpy(    pDataDst->mpScale,    pDataSrc->mpScale, pDataDst->maAttrib[kAttribColBytes]);
				std::memcpy(  pDataDst->mpRowPerm,  pDataSrc->mpRowPerm, pDataDst->maAttrib[kAttribColumns] * sizeof(long));
			} // if
		} // if
	} // if
	
	return pDataDst;
} // MatrixDataCreateWithCopy

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Basic Math Methods

//---------------------------------------------------------------------------

template <typename Real>
static void MatrixAddMxN(const MatrixData<Real> * const pDataA,
						 const MatrixData<Real> * const pDataB, 
						 MatrixData<Real> *pDataC)
{
	const Real * const pMatrixA = pDataA->mpMatrix;
	const Real * const pMatrixB = pDataB->mpMatrix;
	
	Real *pMatrixC = pDataC->mpMatrix;
	
	long iRow;
	long iColumn;
	long iRowOffset;
	long iColOffset;
	
	const long iRowCount = pDataA->maAttrib[kAttribRows];
	const long iColCount = pDataA->maAttrib[kAttribColumns];
	
	for( iRow = 0; iRow < iRowCount; iRow++ ) 
	{
		iRowOffset = iRow * iColCount;
		
		for( iColumn = 0; iColumn < iColCount; iColumn++ ) 
		{
			iColOffset = iRowOffset + iColumn;
			
			pMatrixC[iColOffset] = pMatrixA[iColOffset] + pMatrixB[iColOffset];
		} // for
	} // for
} // MatrixAddMxN

//---------------------------------------------------------------------------

template <typename Real>
static void MatrixAddMxN(const Real nValue,
						 const MatrixData<Real> * const pDataA, 
						 MatrixData<Real> *pDataB)
{
	const Real * const pMatrixA = pDataA->mpMatrix;
	
	Real *pMatrixB = pDataB->mpMatrix;
	
	long iRow;
	long iColumn;
	long iRowOffset;
	long iColOffset;
	
	const long iColCount = pDataA->maAttrib[kAttribColumns];
	const long iRowCount = pDataA->maAttrib[kAttribRows];
	
	for( iRow = 0; iRow < iRowCount; iRow++ ) 
	{
		iRowOffset = iRow * iColCount;
		
		for( iColumn = 0; iColumn < iColCount; iColumn++ ) 
		{
			iColOffset = iRowOffset + iColumn;
			
			pMatrixB[iColOffset] = pMatrixA[iColOffset] + nValue;
		} // for
	} // for
} // MatrixAddMxN

//---------------------------------------------------------------------------

template <typename Real>
static void MatrixSubMxN(const MatrixData<Real> * const pDataA,
						 const MatrixData<Real> * const pDataB, 
						 MatrixData<Real> *pDataC)
{
	const Real * const pMatrixA = pDataA->mpMatrix;
	const Real * const pMatrixB = pDataB->mpMatrix;
	
	Real *pMatrixC = pDataC->mpMatrix;
	
	long iRow;
	long iColumn;
	long iRowOffset;
	long iColOffset;
	
	const long iRowCount = pDataA->maAttrib[kAttribRows];
	const long iColCount = pDataA->maAttrib[kAttribColumns];
	
	for( iRow = 0; iRow < iRowCount; iRow++ ) 
	{
		iRowOffset = iRow * iColCount;
		
		for( iColumn = 0; iColumn < iColCount; iColumn++ ) 
		{
			iColOffset = iRowOffset + iColumn;
			
			pMatrixC[iColOffset] = pMatrixA[iColOffset] - pMatrixB[iColOffset];
		} // for
	} // for
} // MatrixSubMxN

//---------------------------------------------------------------------------

template <typename Real>
static void MatrixSubMxN(const Real nValue,
						 const MatrixData<Real> * const pDataA, 
						 MatrixData<Real> *pDataB)
{
	const Real * const pMatrixA = pDataA->mpMatrix;
	
	Real *pMatrixB = pDataB->mpMatrix;
	
	long iRow;
	long iColumn;
	long iRowOffset;
	long iColOffset;
	
	const long iColCount = pDataA->maAttrib[kAttribColumns];
	const long iRowCount = pDataA->maAttrib[kAttribRows];
	
	for( iRow = 0; iRow < iRowCount; iRow++ ) 
	{
		iRowOffset = iRow * iColCount;
		
		for( iColumn = 0; iColumn < iColCount; iColumn++ ) 
		{
			iColOffset = iRowOffset + iColumn;
			
			pMatrixB[iColOffset] = pMatrixA[iColOffset] - nValue;
		} // for
	} // for
} // MatrixSubMxN

//---------------------------------------------------------------------------
//
// Elementary routine to calculate matrix multiplication: C = A x B, where 
// A is [ l x m ] matrix and B is [ m x n ] matrix, so that, matrix C will 
// be [ l x n ].
//
//---------------------------------------------------------------------------

template<class Real>
static void MatrixMultMxN(const MatrixData<Real> * const pDataA,
						  const MatrixData<Real> * const pDataB, 
						  MatrixData<Real> *pDataC)
{
	if( pDataC->maFlag[kFlagMemAlloced] )
	{	
		Real *pMatrixC   = pDataC->mpMatrix;
		Real  nMatrixCij = 0;
		
		const Real *pColVecB;
		const Real *pRowVecA;
		const Real *pRowVecA0 = pDataA->mpMatrix;	// Pointer to  A[i,0];
		
		while( pRowVecA0 < pDataA->mpMatrix+pDataA->maAttrib[kAttribElements] ) 
		{
			// Pointer to the j-th column of B, Start pColVecB = B[0,0]
			
			for(pColVecB = pDataB->mpMatrix; 
				pColVecB < pDataB->mpMatrix+pDataB->maAttrib[kAttribColumns]; ) 
			{
				// Pointer to the i-th row of A, reset to A[i,0]
				
				pRowVecA   = pRowVecA0;
				nMatrixCij = 0;
				
				// Scan the i-th row of A and
				
				while( pColVecB < pDataB->mpMatrix+pDataB->maAttrib[kAttribElements] ) 
				{
					// the j-th column of B
					
					nMatrixCij += *pRowVecA++ * *pColVecB;
					pColVecB   += pDataB->maAttrib[kAttribColumns];
				} // while
				
				*pMatrixC++ = nMatrixCij;
				
				// Set pColVecB to the (j+1)-th column
				
				pColVecB -= pDataB->maAttrib[kAttribElements]-1;
			} // for
			
			// Set pMatrix to the (i+1)-th row
			
			pRowVecA0 += pDataA->maAttrib[kAttribColumns];
		} // while
	} // if
} // MatrixMultMxN

//---------------------------------------------------------------------------

template<class Real>
static void MatrixMultMxN(const Real nValue,
						  const MatrixData<Real> * const pDataA,
						  MatrixData<Real> *pDataB)
{
	const Real * const pMatrixA = pDataA->mpMatrix;
	
	Real *pMatrixB = pDataB->mpMatrix;
	
	long iRow;
	long iColumn;
	long iRowOffset;
	long iColOffset;
	
	const long iRowCount = pDataA->maAttrib[kAttribRows];
	const long iColCount = pDataA->maAttrib[kAttribColumns];
	
	for( iRow = 0; iRow < iRowCount; iRow++ ) 
	{
		iRowOffset = iRow * iColCount;
		
		for( iColumn = 0; iColumn < iColCount; iColumn++ ) 
		{
			iColOffset = iRowOffset + iColumn;
			
			pMatrixB[iColOffset] = nValue * pMatrixA[iColOffset];
		} // for
	} // for
} // MatrixMultMxN

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - LU Recomposition

//---------------------------------------------------------------------------
//
// Reconstruct the original matrix using the LU decomposition parts
//
//---------------------------------------------------------------------------

template <typename Real>
static void MatrixRecompose( MatrixData<Real> *pData )
{
	if( pData->maFlag[kFlagLUDecomposed] )
	{
		MatrixData<Real> *pDataL = MatrixDataCreateWithCopy<Real>(pData);
		
		if( pDataL->maFlag[kFlagMemAlloced] )
		{
			MatrixData<Real> *pDataU = MatrixDataCreateWithCopy<Real>(pData);
			
			if( pDataU->maFlag[kFlagMemAlloced] )
			{
				
				Real * const pMatrixL = pDataL->mpMatrix;
				Real * const pMatrixU = pDataU->mpMatrix;
				
				const long nColumns = pData->maAttrib[kAttribColumns];
				
				long * const pRowPerm = pData->mpRowPerm;
				
				long iRow;
				long iColumn;
				long rowOffset;
				
				for( iRow = 0; iRow < nColumns; iRow++ ) 
				{
					rowOffset = iRow*nColumns;
					
					for( iColumn = 0; iColumn < nColumns; iColumn++ ) 
					{
						if( iColumn > iRow )
						{
							pMatrixL[rowOffset+iColumn] = 0.0;
						} // else
						else if( iColumn < iRow ) 
						{
							pMatrixU[rowOffset+iColumn] = 0.0;
						} // else if
						else
						{
							pMatrixL[rowOffset+iColumn] = 1.0;
						} // else
					} // for
				} // for
				
				MatrixMultMxN( pDataL, pDataU, pData );
				
				// swap rows
				
				long i;
				long j;
				long k;
				
				long iOffset;
				long jOffset;
				
				Real tmp;
				
				Real * const pMatrix = pData->mpMatrix;
				
				for( i = nColumns-1; i >= 0; i-- ) 
				{
					j = pRowPerm[i];
					
					if( j != i )
					{
						jOffset = j*nColumns;
						iOffset = i*nColumns;
						
						for( k = 0; k < nColumns; k++ ) 
						{
							tmp = pMatrix[jOffset+k];
							
							pMatrix[jOffset+k] = pMatrix[iOffset+k];
							pMatrix[iOffset+k] = tmp;
						} // for
					} // if
				} // for
				
				pData->maFlag[kFlagLUDecomposed] = false;
				
				MatrixDataRelease(pDataU);
			} // if
			
			MatrixDataRelease(pDataL);
		} // if
	} // if
} // MatrixRecompose

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - LU Decomposition

//---------------------------------------------------------------------------
//
// Crout/Doolittle algorithm of LU decomposing a square matrix, with 
// implicit partial pivoting.  
//
// The decomposition is stored in mpData->mpMatrix: U is the upper triangular 
// form and L is in multiplier form in the sub-diagionals.
//
// Row permutations are stored in mpData->mpRowPerm vector. 
//
// mpData->mnSign, is used for calculating the determinant, where +/- 1 denotes
// even/odd row permutations.
//
//---------------------------------------------------------------------------

template <typename Real>
static void MatrixLUDecompose(MatrixData<Real> *pData)
{
	long i;
	long j;
	long k;
	
	long iMax;
	
	long iOffset;
	long jOffset;
	long kOffset;
	
	long iMaxOffset;
	
	Real max      = 0.0;
	Real tmp      = 0.0;
	Real residual = 0.0;
	
	pData->mnSign = 1.0;
	
	pData->maAttrib[kAttribZeroRowCount] = 0;

	// Find implicit scaling factors for each row
	
	for( i = 0; i < pData->maAttrib[kAttribColumns] ; i++ ) 
	{
		iOffset = i * pData->maAttrib[kAttribColumns];
		max = 0.0;
		
		for( j = 0; j < pData->maAttrib[kAttribColumns]; j++ ) 
		{
			tmp = ::fabs(pData->mpMatrix[iOffset+j]);
			
			if (tmp > max)
			{
				max = tmp;
			} // if
		} // for
		
		pData->mpScale[i] = (max == 0.0 ? 0.0 : 1.0/max);
	} // for
	
	for( j = 0; j < pData->maAttrib[kAttribColumns]; j++ ) 
	{
		jOffset = j * pData->maAttrib[kAttribColumns];
		
		// Run down jth column from top to diagonals, to form the elements of U.
		
		for( i = 0; i < j; i++) 
		{
			iOffset = i * pData->maAttrib[kAttribColumns];
			
			residual = pData->mpMatrix[iOffset+j];
			
			for( k = 0; k < i; k++) 
			{
				kOffset = k * pData->maAttrib[kAttribColumns];
				residual -= pData->mpMatrix[iOffset+k]*pData->mpMatrix[kOffset+j];
			} // for
			
			pData->mpMatrix[iOffset+j] = residual;
		} // for
		
		// Run down jth sub-diagonal to form the residuals after the elimination of
		// the first j-1 sub-diagonals.  These residuals divided by the appropriate
		// diagonal term will become the multipliers in the elimination of the jth
		// sub-diagonal. Find row permutation of largest scaled term in iMax.
		
		max  = 0.0;
		iMax = 0;
		
		for( i = j; i < pData->maAttrib[kAttribColumns]; i++) 
		{
			iOffset = i * pData->maAttrib[kAttribColumns];
			residual = pData->mpMatrix[iOffset+j];
			
			for( k = 0; k < j; k++) 
			{
				kOffset = k * pData->maAttrib[kAttribColumns];
				residual -= pData->mpMatrix[iOffset+k]*pData->mpMatrix[kOffset+j];
			} // for
			
			pData->mpMatrix[iOffset+j] = residual;

			tmp = pData->mpScale[i]* ::fabs(residual);
			
			if (tmp >= max) 
			{
				max = tmp;
				iMax = i;
			} // if
		} // for
		
		// Permute current row with iMax
		
		if( j != iMax ) 
		{
			iMaxOffset = iMax*pData->maAttrib[kAttribColumns];
			
			for( k = 0; k < pData->maAttrib[kAttribColumns]; k++ ) 
			{
				tmp = pData->mpMatrix[iMaxOffset+k];
				pData->mpMatrix[iMaxOffset+k] = pData->mpMatrix[jOffset+k];
				pData->mpMatrix[jOffset+k]    = tmp;
			} // for
			
			pData->mnSign = -pData->mnSign;

			pData->mpScale[iMax] = pData->mpScale[j];
		} // if
		
		pData->mpRowPerm[j] = iMax;
		
		// If diagonals term is not zero divide sub-diagonal to form multipliers.
		
		if( pData->mpMatrix[jOffset+j] != 0.0 ) 
		{
			if ( ::fabs(pData->mpMatrix[jOffset+j]) < pData->mnTolerance)
			{
				pData->maAttrib[kAttribZeroRowCount]++;
			} // if

			if( j != pData->maAttrib[kAttribColumns]-1 ) 
			{
				tmp = 1.0/pData->mpMatrix[jOffset+j];
				
				for( i = j+1; i < pData->maAttrib[kAttribColumns]; i++) 
				{
					iOffset = i * pData->maAttrib[kAttribColumns];
					pData->mpMatrix[iOffset+j] *= tmp;
				} // for
			} // if
		}  // if
		else 
		{
			std::cerr << "ERROR: Matrix is singular!" << std::endl;
			
			pData->maFlag[kFlagIsSingular]   = true;
			pData->maFlag[kFlagLUDecomposed] = false;
		} // else
	} // for
	
	pData->maFlag[kFlagLUDecomposed] = true;
} // MatrixLUDecompose

//______________________________________________________________________________

template <typename Real>
static bool MatrixDecompose(MatrixData<Real> *pData)
{
	bool isLUDecomposed = pData->maFlag[kFlagLUDecomposed];
	
	if( !isLUDecomposed )
	{
		// The matrix was not previously LU decomposed, so check
		// the matrix parameters
		
		isLUDecomposed = pData->maFlag[kFlagMemAlloced] 
							&& pData->maFlag[kFlagSquareMatrix] 
							&& pData->maFlag[kFlagColIsValid] 
							&& pData->maFlag[kFlagRowIsValid];
		
		if( isLUDecomposed )
		{
			// The matrix parameters are valid, and the matrix was not
			// previously LU decomposed
			
			MatrixLUDecompose(pData);
			
			pData->maFlag[kFlagHaveZeroRows] = pData->maAttrib[kAttribZeroRowCount] > 0;
			
			if( !pData->maFlag[kFlagLUDecomposed] || pData->maFlag[kFlagHaveZeroRows] ) 
			{
				std::cerr	<< "ERROR: Matrix is singular, " 
							<< pData->maAttrib[kAttribZeroRowCount] 
							<< " elements are of tolerance = " 
							<< pData->mnTolerance 
							<< std::endl;
			} // if
			
			isLUDecomposed = isLUDecomposed 
								&& pData->maFlag[kFlagLUDecomposed] 
								&& !pData->maFlag[kFlagHaveZeroRows];
		} // if
	} // if
	
	return isLUDecomposed;
} // MatrixDecompose

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Solution of Linear Systems

//______________________________________________________________________________
//
// MatrixSolve Ax=b assuming the LU form of A is stored in mpData->mpMatrix, but 
// assume b has *not* been transformed.  Solution returned in x.
//
//______________________________________________________________________________

template <typename Real>
static Real *MatrixSolve(const Real * const pColVecB,
						 MatrixData<Real> *pData)
{
	Real *pColVecX = NULL;
	
	if( pColVecB != NULL )
	{
		if( MatrixDecompose(pData) ) 
		{
			pColVecX = new Real[pData->maAttrib[kAttribColumns]];
			
			if( pColVecX != NULL )
			{
				const long   nRows   = pData->maAttrib[kAttribRows];
				const Real  *pMatrix = pData->mpMatrix;
				
				long i;
				long j;
				
				long nonzero = -1;
				
				long iOffset;
				long iRowPermOffset;
				
				Real residual;
				
				std::memcpy( pColVecX, pColVecB, pData->maAttrib[kAttribColBytes] );
				
				// Check for zero diagonals
				
				for( i = 0; i < nRows; i++ ) 
				{
					iOffset = i*nRows;
					
					if ( ::fabs(pMatrix[iOffset+i]) < pData->mnTolerance ) 
					{
						std::cerr	<< "ERROR: Matrix element (" 
									<< i 
									<< "," 
									<< i 
									<< ") = " 
									<< pMatrix[iOffset+i]
									<< " < "
									<< pData->mnTolerance
									<< std::endl;
						
						delete [] pColVecX;
						
						pColVecX = NULL;
						
						return pColVecX;
					} // if
				} // for
				
				// Transform b allowing for leading zeros
				
				for( i = 0; i < nRows; i++ ) 
				{
					iOffset = i*nRows;
					iRowPermOffset = pData->mpRowPerm[i];
					
					residual = pColVecX[iRowPermOffset];
					
					pColVecX[iRowPermOffset] = pColVecX[i];
					
					if( nonzero >= 0 )
					{
						for( j = nonzero; j <= i-1; j++ )
						{
							residual -= pMatrix[iOffset+j]*pColVecX[j];
						} // for
					} // if
					else if( residual != 0.0 )
					{
						nonzero = i;
					} // else if
					
					pColVecX[i] = residual;
				} // for
				
				// Backward substitution
				
				for( i = nRows-1; i >= 0; i-- ) 
				{
					iOffset  = i*nRows;
					residual = pColVecX[i];
					
					for( j = i+1; j < nRows; j++ )
					{
						residual -= pMatrix[iOffset+j]*pColVecX[j];
					} // for
					
					pColVecX[i] = residual/pMatrix[iOffset+i];
				} // for
			} // if
		} // if
	} // if	
	
	return pColVecX;
} // MatrixSolve

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Matrix Determinant

//---------------------------------------------------------------------------

template <typename Real>
static void MatrixDiagonals(MatrixData<Real> *pData)
{
	if( pData->maFlag[kFlagMemAlloced] )
	{
		const long k = pData->maAttrib[kAttribColumns] + 1;

		long i;
		
		for( i = 0; i < pData->maAttrib[kAttribColumns]; i++ )
		{
			pData->mpDiagonal[i] = pData->mpMatrix[k*i];
		} // for
	} // if
} // MatrixDiagonals

//---------------------------------------------------------------------------
//
// Returns product of matrix diagonal elements in r[0] and r[1]. r[0] is 
// a mantissa and r[2] an exponent for powers of 2. Since the  matrix 
// is in diagonal or triangular-matrix form, this operation yields the 
// the determinant of our matrix. The algorithm is based on Bowler, 
// Martin, Peters and Wilkinson.  For the details on the reference, 
// read the header for MatrixDetNxN() private method.
//
//---------------------------------------------------------------------------

template <typename Real>
static void MatrixDiagonalProduct(MatrixData<Real> *pData, Real *r)
{
	long i;
	
	Real s[2] = { 1.0, 0.0 };
	
	for( i = 0; (i < pData->maAttrib[kAttribColumns]) && (s[0] != 0.0); i++ ) 
	{
		if( ::fabs(pData->mpDiagonal[i]) > pData->mnTolerance ) 
		{
			s[0] *= pData->mpDiagonal[i];
			
			while( ::fabs(s[0]) > 1.0 ) 
			{
				s[0] *= 0.0625;
				s[1] += 4.0;
			} // while
			
			while( ::fabs(s[0]) < 0.0625 ) 
			{
				s[0] *= 16.0;
				s[1] -= 4.0;
			} // while
		} // if
		else 
		{
			s[0] = 0.0;
			s[1] = 0.0;
		} // else
	} // for
	
	r[0] = s[0];
	r[1] = s[1];
} // MatrixDiagonalProduct

//---------------------------------------------------------------------------
//
// If matrix is in diagonal or triangular-matrix form this will result 
// in the determinant of our matrix. The algorithm is based on Bowler, 
// Martin, Peters and Wilkinson:
//
// authors = H. J. Bowler and R. S. Martin and G. Peters & J. H. Wilkinson,
// title   = "Solution of Real and Complex Systems of Linear Equations",
// journal = "Numerische Mathematik",
// volume  = 8,
// pages   = 217-234,
// year    = 1966,
// ISSN    = 0029-599X (print), 0945-3245 (electronic).
//
//---------------------------------------------------------------------------

template <typename Real>
static Real MatrixDetNxN(MatrixData<Real> *pData)
{
	Real d = 0.0;
	
	if( MatrixDecompose(pData) ) 
	{
		Real r[2] = { 0.0, 0.0 };
		
		MatrixDiagonals(pData);
		MatrixDiagonalProduct(pData,r);
		
		r[0] *= pData->mnSign;
		
		d = r[0] * ::pow( 2.0, r[1] );
	} // if
	
	return d;
} // MatrixDetNxN

//---------------------------------------------------------------------------

template <typename Real>
static Real MatrixDet2x2(const MatrixData<Real> * const pData)
{
	Real det = pData->mpMatrix[0] * pData->mpMatrix[3] - pData->mpMatrix[1] * pData->mpMatrix[2];
	
	return det;
} // MatrixDet2x2

//---------------------------------------------------------------------------

template <typename Real>
static Real MatrixDet3x3(const MatrixData<Real> * const pData)
{
	Real N[3] = { 0.0, 0.0, 0.0 };
	
	Real det = 0.0;
	
	// Compute the minors to form a matrix of cofactors
	
	N[0] = pData->mpMatrix[4] * pData->mpMatrix[8] - pData->mpMatrix[5] * pData->mpMatrix[7];
	N[1] = pData->mpMatrix[5] * pData->mpMatrix[6] - pData->mpMatrix[3] * pData->mpMatrix[8];
	N[2] = pData->mpMatrix[3] * pData->mpMatrix[7] - pData->mpMatrix[4] * pData->mpMatrix[6];
	
	// Compute the determinant from the cofactors
	
	det = pData->mpMatrix[0] * N[0] + pData->mpMatrix[1] * N[1] + pData->mpMatrix[2] * N[2];
	
	return det;
} // MatrixDet3x3

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Matrix Inverse

//---------------------------------------------------------------------------

template <typename Real>
static bool MatrixInverse2x2(MatrixData<Real> *pData)
{
	Real det = pData->mpMatrix[0] * pData->mpMatrix[3] - pData->mpMatrix[1] * pData->mpMatrix[2];

	// If the matrix is singular do not continue
	
	if( det < pData->mnTolerance )
	{
		std::cerr << "ERROR: 2x2 matrix is singular!" << std::endl;
		
		return false;
	} // if

	Real Det = 1.0 / det;
	
	pData->mpMatrix[0] =  Det * pData->mpMatrix[3];
	pData->mpMatrix[1] = -Det * pData->mpMatrix[1];
	pData->mpMatrix[2] = -Det * pData->mpMatrix[2];
	pData->mpMatrix[3] =  Det * pData->mpMatrix[0];
	
	return true;
} // MatrixInverse2x2

//---------------------------------------------------------------------------

template <typename Real>
static bool MatrixInverse3x3(MatrixData<Real> *pData)
{
	Real N[9] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
	
	Real det = 0.0;
	Real Det = 0.0;
	
	// Compute the minors in order to compute the determinant
	
	N[0] = pData->mpMatrix[4] * pData->mpMatrix[8] - pData->mpMatrix[5] * pData->mpMatrix[7];
	N[1] = pData->mpMatrix[5] * pData->mpMatrix[6] - pData->mpMatrix[3] * pData->mpMatrix[8];
	N[2] = pData->mpMatrix[3] * pData->mpMatrix[7] - pData->mpMatrix[4] * pData->mpMatrix[6];
	
	// Compute the determinant using the minors
	
	det = pData->mpMatrix[0] * N[0] + pData->mpMatrix[1] * N[1] + pData->mpMatrix[2] * N[2];
	
	// If the matrix is singular do not continue
	
	if( det < pData->mnTolerance )
	{
		std::cerr << "ERROR: 3x3 matrix is singular!" << std::endl;
		
		return false;
	} // if
	
	Det = 1.0 / det;

	// Compute the rest of the minors to form a matrix of cofactors
	
	N[3] = pData->mpMatrix[7] * pData->mpMatrix[2] - pData->mpMatrix[8] * pData->mpMatrix[1];
	N[4] = pData->mpMatrix[8] * pData->mpMatrix[0] - pData->mpMatrix[6] * pData->mpMatrix[2];
	N[5] = pData->mpMatrix[6] * pData->mpMatrix[1] - pData->mpMatrix[7] * pData->mpMatrix[0];
	N[6] = pData->mpMatrix[1] * pData->mpMatrix[5] - pData->mpMatrix[2] * pData->mpMatrix[4];
	N[7] = pData->mpMatrix[2] * pData->mpMatrix[3] - pData->mpMatrix[0] * pData->mpMatrix[5];
	N[8] = pData->mpMatrix[0] * pData->mpMatrix[4] - pData->mpMatrix[1] * pData->mpMatrix[3];
	
	// The inverse of the matrix is the inverse of the determinant
	// times the transpose of the matrix of cofactors
	
	pData->mpMatrix[0] = Det * N[0];
	pData->mpMatrix[1] = Det * N[3];
	pData->mpMatrix[2] = Det * N[6];
	pData->mpMatrix[3] = Det * N[1];
	pData->mpMatrix[4] = Det * N[4];
	pData->mpMatrix[5] = Det * N[7];
	pData->mpMatrix[6] = Det * N[2];
	pData->mpMatrix[7] = Det * N[5];
	pData->mpMatrix[8] = Det * N[8];
	
	return true;
} // MatrixInverse3x3

//---------------------------------------------------------------------------
//
// Calculate matrix inverse, by using LU decomposition, and then
// forward/backward substitution.
//
//---------------------------------------------------------------------------

template <typename Real>
static bool MatrixInverseNxN(MatrixData<Real> *pData)
{
	bool bDoInvert = MatrixDecompose(pData);
	
	if( bDoInvert ) 
	{
		long i;
		long j;
		long k;	
		
		long iOffset;
		long jOffset;
		long kOffset;
		
		long rowIndex;
		long colIndex;
		
		long jPerm = 0;
		
		Real nDiagElem = 0.0;
		Real tmp       = 0.0;
		Real sum       = 0.0;
		
		Real *pVecSrc = NULL;
		Real *pVecDst = NULL;
		Real *pMatCol = NULL;
		Real *pMatRow = NULL;
		
		//  Form inv(U).
		
		for( j = 0; j < pData->maAttrib[kAttribColumns]; j++ ) 
		{
			jOffset = j * pData->maAttrib[kAttribColumns];
			
			pData->mpMatrix[jOffset+j] = 1.0/pData->mpMatrix[jOffset+j];
			
			nDiagElem = -pData->mpMatrix[jOffset+j];
			
			// Compute elements 0:j-1 of j-th column.
			
			pMatCol = pData->mpMatrix+j;
			
			for( k = 0; k <= j-1; k++ )
			{
				kOffset = k * pData->maAttrib[kAttribColumns];
				
				if ( pMatCol[kOffset] != 0.0 ) 
				{
					tmp = pMatCol[kOffset];
					
					for( i = 0; i <= k-1; i++) 
					{
						iOffset = i * pData->maAttrib[kAttribColumns];
						pMatCol[iOffset] += tmp*pData->mpMatrix[iOffset+k];
					} // for
					
					pMatCol[kOffset] *= pData->mpMatrix[kOffset+k];
				} // if
			} // for
			
			for (k = 0; k <= j-1; k++) 
			{
				kOffset = k * pData->maAttrib[kAttribColumns];
				pMatCol[kOffset] *= nDiagElem;
			} // for
		} // for
		
		// MatrixSolve the equation inv(A)*L = inv(U) for inv(A).
		
		for( j = pData->maAttrib[kAttribColumns]-1; j >= 0; j-- ) 
		{
			// Copy current column j of L to the column vector and
			// replace the matrix column with zeros.
			
			for( i = j+1; i < pData->maAttrib[kAttribColumns]; i++) 
			{
				iOffset = i * pData->maAttrib[kAttribColumns];
				pData->mpColumn[i] = pData->mpMatrix[iOffset+j];
				pData->mpMatrix[iOffset+j] = 0.0;
			} // for
			
			// Compute current column of inv(A).
			
			if( j < pData->maAttrib[kAttribColumns]-1 )
			{
				pMatRow = pData->mpMatrix+j+1;	// Matrix source row
				pVecDst = pData->mpMatrix+j;		// Matrix destination vector
				
				for( rowIndex = 0; rowIndex < pData->maAttrib[kAttribColumns]; rowIndex++) 
				{
					sum = 0.0;
					pVecSrc = pData->mpColumn+j+1; // Matrix source vector
					
					for( colIndex = 0; colIndex < pData->maAttrib[kAttribColumns]-1-j ; colIndex++)
					{
						sum += *pMatRow++ * *pVecSrc++;
					} // for
					
					*pVecDst = -sum + *pVecDst;
					
					pMatRow += j+1;
					pVecDst += pData->maAttrib[kAttribColumns];
				} // for
			} // if
		} // for
		
		// Interchange columns.
		
		for( j = pData->maAttrib[kAttribColumns]-1; j >= 0; j-- ) 
		{
			jPerm = pData->mpRowPerm[j];
			
			if( jPerm != j ) 
			{
				for( i = 0; i < pData->maAttrib[kAttribColumns]; i++) 
				{
					iOffset = i * pData->maAttrib[kAttribColumns];
					
					tmp = pData->mpMatrix[iOffset+jPerm];
					
					pData->mpMatrix[iOffset+jPerm] = pData->mpMatrix[iOffset+j];
					pData->mpMatrix[iOffset+j]     = tmp;
				} // for
			} // for
		} // for
	} // if
	
	return bDoInvert;
} // MatrixInverseNxN

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Matrix Transpose

//---------------------------------------------------------------------------

template<typename Real>
static void MatrixTransposeMxN(const MatrixData<Real> * const pDataSrc,
							   MatrixData<Real> *pDataDst)
{
	if( pDataDst->maFlag[kFlagMemAlloced] )
	{
		MatrixRecompose(pDataDst);
		
		if( pDataDst->maAttrib[kAttribRows] == pDataDst->maAttrib[kAttribColumns] ) 
		{
			long i;
			long j;
			
			long iOffset;
			long jOffset;
			
			Real tmp;
			
			Real *pMatrix = pDataDst->mpMatrix;
			
			for( i = 0; i < pDataDst->maAttrib[kAttribRows]; i++ ) 
			{
				iOffset = i*pDataDst->maAttrib[kAttribRows];
				
				for( j = i+1; j < pDataDst->maAttrib[kAttribColumns]; j++ ) 
				{
					jOffset = j*pDataDst->maAttrib[kAttribColumns];
					
					tmp = pMatrix[iOffset+j];
					
					pMatrix[iOffset+j] = pMatrix[jOffset+i];
					pMatrix[jOffset+i] = tmp;
				} // for
			} // for
		} // if 
		else 
		{
			Real *pMatrixNew = new Real[pDataSrc->maAttrib[kAttribElements]];
			
			if( pMatrixNew != NULL )
			{				
				const long nRowsOld    = pDataDst->maAttrib[kAttribRows];
				const long nColumnsOld = pDataDst->maAttrib[kAttribColumns];
				
				long iRow;
				long iRowOffset;
				long iColumn;
				
				pDataDst->maAttrib[kAttribRows]    = nColumnsOld;  
				pDataDst->maAttrib[kAttribColumns] = nRowsOld;
				
				std::memcpy(pMatrixNew,
							pDataSrc->mpMatrix,
							pDataSrc->maAttrib[kAttribBytes]);
				
				for( iRow = 0; iRow < pDataDst->maAttrib[kAttribRows]; iRow++ ) 
				{
					iRowOffset = iRow*pDataDst->maAttrib[kAttribColumns];
					
					for( iColumn = 0; iColumn < pDataDst->maAttrib[kAttribColumns]; iColumn++ ) 
					{
						pDataDst->mpMatrix[iRowOffset+iColumn] = pMatrixNew[iColumn*nColumnsOld+iRow];
					} // for
				} // for
				
				delete [] pMatrixNew;
			} // if
		} // else
	} // if
} // MatrixTransposeMxN

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Constructors

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real>::Matrix()
{
	mpData = MatrixDataCreateDefault<Real>();
} // Default Constructor

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real>::Matrix(const long nRows, 
					 const long nColumns)
{
	mpData = MatrixDataCreateWithMatrixCopy<Real>(nRows,nColumns,NULL);
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real>::Matrix(const long nRows, 
					 const long nColumns, 
					 const Real nTolerance)
{
	mpData = MatrixDataCreateWithMatrixCopy<Real>(nRows,nColumns,NULL);
} // Constructor

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real>::Matrix(const long nRows, 
					 const long nColumns, 
					 const Real nTolerance, 
					 const Real * const pMatrix)
{
	mpData = MatrixDataCreateWithMatrixCopy<Real>(nRows,nColumns,pMatrix);
} // Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Copy Constructor

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real>::Matrix(const Matrix<Real> &rMatrix)
{
	mpData = MatrixDataCreateWithCopy<Real>(rMatrix.mpData);
} // Copy Constructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Destructor

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real>::~Matrix()
{
	MatrixDataRelease<Real>(mpData);
} // Destructor

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Assignment Operator

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> &Matrix<Real>::operator=(const Matrix<Real> &rMatrix)
{
	if( this != &rMatrix )
	{
		MatrixDataRelease<Real>(mpData);
		
		mpData = MatrixDataCreateWithCopy<Real>(rMatrix.mpData);
	} // if
	
	return *this;
} // Matrix::operator=

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Operators

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator+(const Matrix<Real> &rMatrix)
{
	Matrix<Real> matrixC;
	
	if( rMatrix.mpData->maFlag[kFlagMemAlloced] && mpData->maFlag[kFlagMemAlloced] )
	{
		matrixC.create(mpData->maAttrib[kAttribColumns],
					   mpData->maAttrib[kAttribRows]);
		
		if( matrixC.mpData->maFlag[kFlagMemAlloced] )
		{
			MatrixAddMxN<Real>(mpData, 
							   rMatrix.mpData, 
							   matrixC.mpData);
		} // if
	} // if
	
	return matrixC;
} // Matrix::operator+

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator+(const Real k)
{
	Matrix<Real> matrixB;
	
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		matrixB.create(mpData->maAttrib[kAttribColumns],
					   mpData->maAttrib[kAttribRows]);
		
		if( matrixB.mpData->maFlag[kFlagMemAlloced] )
		{
			MatrixAddMxN<Real>( k, mpData, matrixB.mpData );
		} // if
	} // if
	
	return matrixB;
} // Matrix::operator+

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator-(const Matrix<Real> &rMatrix)
{
	Matrix<Real> matrixC;
	
	if( rMatrix.mpData->maFlag[kFlagMemAlloced] && mpData->maFlag[kFlagMemAlloced] )
	{
		matrixC.create(mpData->maAttrib[kAttribColumns],
					   mpData->maAttrib[kAttribRows]);
		
		if( matrixC.mpData->maFlag[kFlagMemAlloced] )
		{
			MatrixSubMxN<Real>( mpData, rMatrix.mpData, matrixC.mpData );
		} // if
	} // if
	
	return matrixC;
} // Matrix::operator-

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator-(const Real k )
{
	Matrix<Real> matrixB;
	
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		matrixB.create(mpData->maAttrib[kAttribColumns],
					   mpData->maAttrib[kAttribRows]);
		
		if( matrixB.mpData->maFlag[kFlagMemAlloced] )
		{
			MatrixSubMxN<Real>( k, mpData, matrixB.mpData );
		} // if
	} // if
	
	return matrixB;
} // Matrix::operator-

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator*(const Matrix<Real> &rMatrix)
{
	Matrix<Real> matrixC;
	
	if( mpData->maAttrib[kAttribColumns] == rMatrix.mpData->maAttrib[kAttribRows] )
	{
		matrixC.create(mpData->maAttrib[kAttribRows], 
					   rMatrix.mpData->maAttrib[kAttribColumns]);
		
		MatrixMultMxN<Real>(mpData, rMatrix.mpData, matrixC.mpData);
	} // if
	
	return matrixC;
} // Matrix::operator*

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator*(const Real k )
{
	Matrix<Real> matrixB;
	
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		matrixB.create(mpData->maAttrib[kAttribColumns],
					   mpData->maAttrib[kAttribRows]);
		
		if( matrixB.mpData->maFlag[kFlagMemAlloced] )
		{
			MatrixMultMxN<Real>( k, mpData, matrixB.mpData );
		} // if
	} // if
	
	return matrixB;
} // Matrix::operator*

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator/(const Real k )
{
	Matrix<Real> matrixB;
	
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		matrixB.create(mpData->maAttrib[kAttribColumns],
					   mpData->maAttrib[kAttribRows]);
		
		if( matrixB.mpData->maFlag[kFlagMemAlloced] )
		{
			const Real K = 1.0 / k;
			
			MatrixMultMxN<Real>( K, mpData, matrixB.mpData );
		} // if
	} // if
	
	return matrixB;
} // Matrix::operator/

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator+=(const Matrix<Real> &rMatrix)
{
	if( rMatrix.mpData->maFlag[kFlagMemAlloced] && mpData->maFlag[kFlagMemAlloced] )
	{
		MatrixAddMxN<Real>( mpData, rMatrix.mpData, mpData );
	} // if
	
	return *this;
} // Matrix::operator+=

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator+=(const Real k)
{
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		MatrixAddMxN<Real>( k, mpData, mpData );
	} // if
	
	return *this;
} // Matrix::operator+=

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator-=(const Matrix<Real> &rMatrix)
{
	if( rMatrix.mpData->maFlag[kFlagMemAlloced] && mpData->maFlag[kFlagMemAlloced] )
	{
		MatrixSubMxN<Real>( mpData, rMatrix.mpData, mpData );
	} // if
	
	return *this;
} // Matrix::operator-=

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator-=(const Real k)
{
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		MatrixSubMxN<Real>( k, mpData, mpData );
	} // if

	return *this;
} // Matrix::operator-=

//------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator*=(const Matrix<Real> &rMatrix)
{
	Matrix<Real> matrixA( *this );
	
	if( matrixA.mpData->maAttrib[kAttribColumns] == rMatrix.mpData->maAttrib[kAttribRows] )
	{
		MatrixDataRelease(mpData);
		
		mpData = MatrixDataCreateWithMatrixCopy<Real>(matrixA.mpData->maAttrib[kAttribRows],
											rMatrix.mpData->maAttrib[kAttribColumns],
											NULL);
		
		MatrixMultMxN<Real>(matrixA.mpData,
							rMatrix.mpData,
							mpData);
	} // if
	
	return *this;
} // Matrix::operator*=

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator*=(const Real k)
{
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		MatrixMultMxN<Real>( k, mpData, mpData);
	} // if
	
	return *this;
} // Matrix::operator*=

//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> Matrix<Real>::operator/=(const Real k)
{
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		const Real K = 1.0 / k;
		
		MatrixMultMxN<Real>( K, mpData, mpData );
	} // if
	
	return *this;
} // Matrix::operator*=

//---------------------------------------------------------------------------

template <typename Real>
Real &Matrix<Real>::operator()(const long nRow, const long nColumn)
{	
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		if( ( nRow < 0 ) || ( nRow > mpData->maAttrib[kAttribRows] ) )
		{
			std::cerr	<< "ERROR: Row index " 
			<< nRow 
			<< " is outside the row bounds of this matrix!" 
			<< std::endl;
			
			return mpData->mpMatrix[0];
		} // if
		
		if( ( nColumn < 0 ) || ( nColumn > mpData->maAttrib[kAttribColumns] ) )
		{
			std::cerr	<< "ERROR: Column index " 
			<< nColumn 
			<< " is outside the column bounds of this matrix!" 
			<< std::endl;
			
			return mpData->mpMatrix[0];
		} // if
		
		const long k = nRow * mpData->maAttrib[kAttribColumns] + nColumn;
		
		return  mpData->mpMatrix[k];
	} // if
	
	return mpData->mpMatrix[0];
} // Matrix::operator()

//---------------------------------------------------------------------------

template <typename Real>
Real Matrix<Real>::operator()(const long nRow, const long nColumn) const
{	
	if( mpData->maFlag[kFlagMemAlloced] )
	{
		if( ( nRow < 0 ) || ( nRow > mpData->maAttrib[kAttribRows] ) )
		{
			std::cerr	<< "ERROR: Row index " 
			<< nRow 
			<< " is outside the row bounds of this matrix!" 
			<< std::endl;
			
			return mpData->mpMatrix[0];
		} // if
		
		if( ( nColumn < 0 ) || ( nColumn > mpData->maAttrib[kAttribColumns] ) )
		{
			std::cerr	<< "ERROR: Column index " 
			<< nColumn 
			<< " is outside the column bounds of this matrix!" 
			<< std::endl;
			
			return mpData->mpMatrix[0];
		} // if
		
		const long k = nRow * mpData->maAttrib[kAttribColumns] + nColumn;
		
		return mpData->mpMatrix[k];
	} // if
	
	return 0.0;
} // Matrix::operator()

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Initializer

//---------------------------------------------------------------------------

template <typename Real>
void  Matrix<Real>::create(const long nRows, const long nColumns)
{
	if( !mpData->maFlag[kFlagMemAlloced] )
	{
		MatrixDataCreate<Real>(nRows,nColumns,NULL,mpData);
	} // if
} // Matrix::create

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Getters

//---------------------------------------------------------------------------

template <typename Real>
const Real *Matrix<Real>::getMatrix() const
{
	return( mpData->mpMatrix );
} // Matrix::getMatrix

//---------------------------------------------------------------------------

template <typename Real>
Real *Matrix<Real>::copyMatrix() const
{
	Real *pMatrix = NULL;

	if( mpData->mpMatrix != NULL )
	{
		pMatrix = new Real[mpData->maAttrib[kAttribElements]];

		if( pMatrix != NULL )
		{
			std::memcpy(pMatrix, 
						mpData->mpMatrix, 
						mpData->maAttrib[kAttribBytes]);
		} // if
	} // if
	
	return( pMatrix );
} // Matrix::copyMatrix

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Setters

//---------------------------------------------------------------------------

template <typename Real>
void  Matrix<Real>::setMatrix(const Real * const pMatrix)
{
	if( ( pMatrix != NULL ) && ( mpData->maFlag[kFlagMemAlloced] ) )
	{
		std::memcpy(mpData->mpMatrix, 
					pMatrix, 
					mpData->maAttrib[kAttribBytes]);
	} // if
} // Matrix::setMatrix

//---------------------------------------------------------------------------

template <typename Real>
void  Matrix<Real>::setTolerance(const Real nTolerance)
{
	mpData->mnTolerance = nTolerance;
} // Matrix::setTolerance

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Public - Matrix Operations

//---------------------------------------------------------------------------

template <typename Real>
Real Matrix<Real>::det()
{
	Real d = 0.0;
	
	if( mpData->maFlag[kFlagMemAlloced] 
	   && ( mpData->maAttrib[kAttribColumns] == mpData->maAttrib[kAttribRows] ) )
	{
		switch( mpData->maAttrib[kAttribColumns] )
		{
			case 2:
				d = MatrixDet2x2<Real>(mpData);
				break;
			case 3:
				d = MatrixDet3x3<Real>(mpData);
				break;
			default:
				d = MatrixDetNxN<Real>(mpData);
				break;
		} // switch
	} // if
	
	return d;
} // Matrix::det

//---------------------------------------------------------------------------
//
// Calculate matrix inverse, by using LU decomposition, and then
// forward/backward substitution.
//
//---------------------------------------------------------------------------

template <typename Real>
Matrix<Real> &Matrix<Real>::inv()
{
	bool isInverted = false;

	if( mpData->maFlag[kFlagMemAlloced] 
	   && ( mpData->maAttrib[kAttribColumns] == mpData->maAttrib[kAttribRows] ) )
	{
		switch( mpData->maAttrib[kAttribColumns] )
		{
			case 2:
				isInverted = MatrixInverse2x2<Real>(mpData);
				break;
			case 3:
				isInverted = MatrixInverse3x3<Real>(mpData);
				break;
			default:
				isInverted = MatrixInverseNxN<Real>(mpData);
				break;
		} // switch
	} // if
	
	return *this;
} // Matrix::inv

//---------------------------------------------------------------------------

template<typename Real>
Real *Matrix<Real>::solve(const Real * const pColVecB)
{		
	return MatrixSolve<Real>( pColVecB, mpData );
} // Matrix::solve

//---------------------------------------------------------------------------
//
// Transpose the source matrix.
//
//---------------------------------------------------------------------------

template<typename Real>
Matrix<Real> &Matrix<Real>::transpose()
{
	MatrixTransposeMxN<Real>( mpData, mpData );
	
	return *this;
} // Matrix::transpose

//---------------------------------------------------------------------------

template<typename Real>
Matrix<Real> &Matrix<Real>::transpose(const Matrix<Real> &rMarixSrc)
{	
	if( mpData->mpMatrix == rMarixSrc.mpData->mpMatrix )
	{
		MatrixTransposeMxN<Real>( mpData, mpData );
	} // if
	else 
	{
		if(		( mpData->maAttrib[kAttribRows] != rMarixSrc.mpData->maAttrib[kAttribColumns] ) 
			||	( mpData->maAttrib[kAttribColumns] != rMarixSrc.mpData->maAttrib[kAttribRows] ) )
		{
			std::cerr << "ERROR: Matrix has wrong row column size for the transpose operation!" << std::endl;
			return *this;
		} // if
		
		const Real *pMatrixSrc1 = rMarixSrc.mpData->mpMatrix;
		const Real *pMatrixSrc2;
		
		const Real *pRowVecSrc = pMatrixSrc1;
		
		const Real * const pMatrixLast = mpData->mpMatrix + mpData->maAttrib[kAttribElements];
		
		Real *pMatrix = mpData->mpMatrix;
		
		// (This: target) matrix is traversed row-wise way,
		// whilst the source matrix is scanned column-wise
		
		while( pMatrix < pMatrixLast ) 
		{
			pMatrixSrc2 = pRowVecSrc++;
			
			// Move pMatrix to the next element in the row 
			// and the source pointer to the next element
			// in the current coloumn
			
			while( pMatrixSrc2 < pMatrixSrc1 + mpData->maAttrib[kAttribElements] ) 
			{
				*pMatrix++ = *pMatrixSrc2;
				pMatrixSrc2 += mpData->maAttrib[kAttribRows];
			} // while
		} // while
		
		if(		( pMatrix != pMatrixLast ) 
			||	( pRowVecSrc != pMatrixSrc1 + mpData->maAttrib[kAttribRows] ) )
		{
			std::cerr << "ERROR: Transpose operation is invalid!" << std::endl;
		} // if
	} // else
	
	return *this;
} // Matrix::transpose

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Template Implementations

//---------------------------------------------------------------------------

template class Matrix<float>;
template class Matrix<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

