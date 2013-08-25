//
//  NTViewController.h
//  NavControlWithTableViewandStoryBoard
//
//  Created by test on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface NTViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *countriesArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) DetailViewController *detailViewController;

@end
