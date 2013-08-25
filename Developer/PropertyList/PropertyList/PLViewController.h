//
//  PLViewController.h
//  PropertyList
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface PLViewController : UIViewController

@property (strong,nonatomic) NSMutableArray *graphicObjects;

@property (strong,nonatomic) DetailViewController *detailViewController;

@end
