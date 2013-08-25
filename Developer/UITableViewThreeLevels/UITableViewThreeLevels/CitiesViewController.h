//
//  CitiesViewController.h
//  UITableViewThreeLevels
//
//  Created by test on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StatesControllerDelegate <NSObject>

- (void) sendSelectedItem:(UIViewController *)controller withDataSent:(NSString *)data;

@end
@interface CitiesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) NSString *textData;

@property (strong, nonatomic) NSArray *citiesArray;

@property (retain, nonatomic) id <StatesControllerDelegate> delegate;


@end
