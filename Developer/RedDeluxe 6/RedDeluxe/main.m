
//
//  main.m
//  RedDeluxe
//
//  Created by Test on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RDAppDelegate.h"

int main(int argc, char *argv[])
{
        @autoreleasepool {
            @try {
                return UIApplicationMain(argc, argv, nil, NSStringFromClass([RDAppDelegate class]));
            }
            @catch (NSException *exception) {
                NSLog(@"Exception: %@",exception);
            }
            @finally {
                
            }

        return 0;
    }
}
