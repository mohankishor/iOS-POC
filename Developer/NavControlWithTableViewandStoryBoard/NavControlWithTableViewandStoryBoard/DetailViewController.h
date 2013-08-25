//
//  DetailViewController.h
//  NavControlWithTableViewandStoryBoard
//
//  Created by test on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesViewController.h"
@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *detailViewController;
@property (strong,nonatomic) NSMutableArray *statesArray;
@property (strong,nonatomic) CitiesViewController *citiesViewController;
@property int selectedCountry;
@end
