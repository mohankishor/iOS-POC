//
//  TPViewController.h
//  UITableViewWithProtocols
//
//  Created by test on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatesViewController.h"

@interface TPViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StatesControllerDelegate>
{
    NSMutableArray *listOfItems;
}
@property (strong, nonatomic) StatesViewController *statesViewController;
@end
