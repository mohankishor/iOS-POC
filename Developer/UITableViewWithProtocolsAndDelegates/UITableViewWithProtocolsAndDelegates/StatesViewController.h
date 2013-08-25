//
//  StatesViewController.h
//  UITableViewWithProtocols
//
//  Created by test on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesViewController.h"
@protocol CitiesControllerDelegate <NSObject>

- (void) sendSelectedItem:(UIViewController *)controller withDataSent:(NSString *)data;

@end
@interface StatesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSString  *selectedState;
@property (strong,nonatomic)NSString *textData;
@property (strong,nonatomic) NSMutableArray *statesArray;
@property int row;
@property (retain, nonatomic) id <CitiesControllerDelegate> delegate;
@property (strong,nonatomic) CitiesViewController *citiesViewController;
@end
