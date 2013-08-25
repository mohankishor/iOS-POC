//
//  CitiesViewController.h
//  NavControlWithTableViewandStoryBoard
//
//  Created by test on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitiesViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *citiesArray;
@property (weak, nonatomic) IBOutlet UIView *citiesViewController;
@property (nonatomic,strong)NSString *selectedState;
@end
