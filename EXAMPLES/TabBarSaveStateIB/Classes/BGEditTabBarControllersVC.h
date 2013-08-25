//
//  BGEditTabBarControllersVC.h
//  TabBarSaveStateIB
//
//  Created by Sambasivarao D on 29/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BGEditTabBarControllersVC : UIViewController<UIScrollViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIView *mainView;
	IBOutlet UIButton *button1;
	
	IBOutlet UITabBar *tabBar;
	
	float previousX;
	float previousY;
	
	float currentX;
	float currentY;
	
}
-(void) addControllersImagesOnView;
@end
