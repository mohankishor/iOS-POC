//
//  ViewController.h
//  UITableViewThreeLevels
//
//  Created by test on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailsViewController.h"

@interface ViewController : UIViewController <DetailsControllerDelegate>

@property (strong, nonatomic) DetailsViewController *detailViewController;

@property (strong, nonatomic) NSArray *countriesArray;

@end
