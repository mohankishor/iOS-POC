//
//  main.m
//  UITableViewWithProtocolsAndDelegates
//
//  Created by test on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPAppDelegate.h"

int main(int argc, char *argv[])
{
    @try {
        UIApplicationMain(argc, argv, nil, NSStringFromClass([TPAppDelegate class]));
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception); 
    }
    @finally {
        
    }
    @autoreleasepool {
        return 0;
    }
}
