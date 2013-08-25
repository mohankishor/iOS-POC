//
//  TVViewController.h
//  TableViewTry
//
//  Created by test on 03/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface TVViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *countriesArray;

@property (strong,nonatomic) DetailViewController *detailViewController;
@end
