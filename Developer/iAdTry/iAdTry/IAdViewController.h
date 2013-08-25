//
//  IAdViewController.h
//  iAdTry
//
//  Created by test on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/iAd.h"
@interface IAdViewController : UIViewController<ADBannerViewDelegate>{
    ADBannerView *adView;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;

@end
