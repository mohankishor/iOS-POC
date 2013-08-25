//
//  FLUtility.m
//  Fossil
//
//  Created by Sanath on 07/10/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "FLCheckInternetConnection.h"


@implementation FLCheckInternetConnection

-(BOOL) checkInternetConnectionAvailable
{
	if([[FLReachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
	{
		NSLog(@"not available");
		return NO;
	}
	else
	{
		NSLog(@"available");
		return YES;
	}
}

@end
