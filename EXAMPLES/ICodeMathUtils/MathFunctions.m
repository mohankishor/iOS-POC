//
//  MathFunctions.m
//  ICodeMathUtils
//
//  Created by Reshma Nayak on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathFunctions.h"


@implementation MathFunctions

- (NSArray *) fibonacci:(NSInteger) n
{
    
	NSMutableArray *fib = [NSMutableArray array];
    
	int a = 0;
	int b = 1;
	int sum;
	int i;
    
	//for (i=0;i&lt; n;i++)
    for (i=0;i<[fib count];i++)

	{
		[fib addObject:[NSNumber numberWithInt:a]];
		sum = a + b;
		a = b;
		b = sum;
	}
    
	return (NSArray *) fib;
}

- (NSInteger) factorial:(NSInteger) n {
	if ( n == 1 )
		return 1;
	else
		return n * [self factorial:( n-1 )];
}
@end
