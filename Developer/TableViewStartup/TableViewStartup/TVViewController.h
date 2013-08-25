//
//  TVViewController.h
//  TableViewStartup
//
//  Created by test on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
NSMutableArray *listOfItems;
    NSMutableArray *listOfSubtitleItems;
     NSMutableArray *listOfImageItems;
}
@end
