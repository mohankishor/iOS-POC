//---------------------------------------------------------------------------
//
//	File: BradfordAdaptation.cpp
//
//  Abstract: Utility class for Bradford adaptation matrix representation
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

#import "BradfordAdaptation.hpp"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

template <typename Real>
BradfordAdaptation<Real>::BradfordAdaptation()
{
	maBAMatrix[0][0] =  0.8951;
	maBAMatrix[0][1] = -0.7502;
	maBAMatrix[0][2] =  0.0389;
	maBAMatrix[1][0] =  0.2664;
	maBAMatrix[1][1] =  1.7135;
	maBAMatrix[1][2] = -0.0685;
	maBAMatrix[2][0] = -0.1614;
	maBAMatrix[2][1] =  0.0367;
	maBAMatrix[2][2] =  1.0296;
	
	maBAMatrixInv[0][0] =  0.986993;
	maBAMatrixInv[0][1] =  0.432305;
	maBAMatrixInv[0][2] = -0.008529;
	maBAMatrixInv[1][0] = -0.147054;
	maBAMatrixInv[1][1] =  0.518360;
	maBAMatrixInv[1][2] =  0.040043;
	maBAMatrixInv[2][0] =  0.159963;
	maBAMatrixInv[2][1] =  0.049291;
	maBAMatrixInv[2][2] =  0.968487;
} // BradfordAdaptation

//---------------------------------------------------------------------------

template class BradfordAdaptation<float>;
template class BradfordAdaptation<double>;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
