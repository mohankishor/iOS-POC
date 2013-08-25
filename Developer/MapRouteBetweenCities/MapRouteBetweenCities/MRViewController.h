//
//  MRViewController.h
//  MapRouteBetweenCities
//
//  Created by test on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapDirectionsViewController.h"
@interface MRViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *startField;
@property (retain, nonatomic) IBOutlet UITextField *endField;
- (IBAction)searchRoute:(id)sender;
@end
