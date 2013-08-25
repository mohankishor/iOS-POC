//
//  RDGetInformedViewController.h
//  RedDeluxe
//
//  Created by Pradeep Rajkumar on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDGetInformedViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *signUpView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *webLoadingActivityIndicator;

@property (nonatomic,strong) NSURLRequest *requestObj;

@end
