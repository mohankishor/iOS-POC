//
//  OQAppDelegate.h
//  NSOperationQueueTry
//
//  Created by test on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OQAppDelegate : NSObject {
	NSOperationQueue *queue;
}

+ (id)shared;
@end