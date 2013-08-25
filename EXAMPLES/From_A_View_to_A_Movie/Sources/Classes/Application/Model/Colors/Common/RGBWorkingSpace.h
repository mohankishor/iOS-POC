//---------------------------------------------------------------------------
//
//	File: RGBWorkingSpace.h
//
//  Abstract: RGB working space specifications
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

#ifndef _RGB_WORKING_SPACE_H_
#define _RGB_WORKING_SPACE_H_

#ifdef __cplusplus
extern "C" {
#endif
	
	//---------------------------------------------------------------------------
	
	//---------------------------------------------------------------------------
	//
	// Generic Apple coordinates for red, green, and blue primaries, as well
	// D65 reference white point.
	//
	//---------------------------------------------------------------------------
	
	static const float AppleWorkingSpace[4][2] = 
	{
		{	0.625,		0.34		},
		{	0.28,		0.595		},
		{	0.155,		0.07		},
		{	0.312713,	0.329016	} 
	};	
	
	//---------------------------------------------------------------------------
	//
	// CCIR/ITU-R BT/CIE Rec 709-5 (HDTV).
	//
	//---------------------------------------------------------------------------
	//
	// Rec 709 does not specify a gamma for the output device. Only the gamma 
	// of the input device (0.45) is given. Typical CRTs have a gamma value 
	// of 2.5, which yields an overall gamma of 1.125, within the 1.1 to 1.2 
	// range usually used with the dim viewing environment assumed for 
	// television.
	//
	//---------------------------------------------------------------------------
	
	//---------------------------------------------------------------------------
	//
	// Rec 709 coordinates for red, green, and blue primaries, as well D65
	// reference white point.
	//
	//---------------------------------------------------------------------------
	
	static const float Rec709WorkingSpace[4][2] = 
	{
		{	0.64,		0.33		},
		{	0.30,		0.60		},
		{	0.15,		0.06		},
		{	0.312713,	0.329016	}
	};	
	
	//---------------------------------------------------------------------------
	//
	// SMPTE-C is the current colour standard for broadcasting in America, 
	// the old NTSC standard for primaries is no longer in wide use because 
	// the primaries of the system have gradually shifted towards those of 
	// the EBU (see section 6.2). In all other respects, SMPTE-C is the 
	// same as NTSC.
	//
	// SMPTE-C coordinates for red, green, and blue primaries, as well D65
	// reference white point.
	//
	//---------------------------------------------------------------------------
	
	static const float SMPTECWorkingSpace[4][2] = 
	{
		{	0.63,		0.34		},
		{	0.31,		0.595		},
		{	0.155,		0.07		},
		{	0.312713,	0.329016	}
	};	
	
	//---------------------------------------------------------------------------
	//
	// sRGB coordinates for red, green, and blue primaries, as well D65
	// reference white point.
	//
	//---------------------------------------------------------------------------
	
	static const float sRGBWorkingSpace[4][2] = 
	{
		{	0.64,		0.33		},
		{	0.30,		0.60		},
		{	0.15,		0.06		},
		{	0.312713,	0.329016	}
	};	
	
	//---------------------------------------------------------------------------
	
	//---------------------------------------------------------------------------
	
#ifdef __cplusplus
}
#endif

#endif

