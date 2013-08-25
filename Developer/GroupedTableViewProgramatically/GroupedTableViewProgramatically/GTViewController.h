//
//  GTViewController.h
//  GroupedTableViewProgramatically
//
//  Created by test on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *listOfItems;
}
@end
