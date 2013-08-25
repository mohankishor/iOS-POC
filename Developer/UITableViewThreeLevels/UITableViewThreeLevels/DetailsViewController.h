//
//  DetailsViewController.h
//  UITableViewThreeLevels
//
//  Created by test on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesViewController.h"
@protocol DetailsControllerDelegate <NSObject>

- (void) sendSelectedItem:(UIViewController *)controller withDataSent:(NSString *)data;

@end

@interface DetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) CitiesViewController *citiesViewController;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) NSString *textData;

@property (strong, nonatomic) NSArray *statesArray;

@property (retain, nonatomic) id <DetailsControllerDelegate> delegate;

@property int row;

@end
