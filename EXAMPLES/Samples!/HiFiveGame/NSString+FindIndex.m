//
//  NSString+FindIndex.m
//  HiFiveGame
//
//  Created by Devika on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+FindIndex.h"


@implementation NSString(FindIndex)
+(int)findIndexOfString:(NSString*)aSubString InString:(NSString*)aMainString
{
	int retVal=200;
	NSRange range=[aMainString rangeOfString:aSubString];
	if (range.length) {
		for(int i=range.location;i<range.location+5;i++)
		{
			NSString *charecter=[[NSString alloc]initWithFormat:@"%C",[aMainString characterAtIndex:i]];
			if ([charecter isEqualToString:@"3"]) {
				//return i;
				retVal=i;
			}
			[charecter release];
		}
	}
				 return retVal;			 
}
@end
