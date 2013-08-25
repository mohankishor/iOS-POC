//
//  XMl_parser_exampleAppDelegate.h
//  XMl parser example
//
//  Created by Neelam Verma on 07/09/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XMl_parser_exampleViewController;

@interface XMl_parser_exampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    XMl_parser_exampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet XMl_parser_exampleViewController *viewController;

@end

