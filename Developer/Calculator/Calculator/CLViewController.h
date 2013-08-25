//
//  CLViewController.h
//  Calculator
//
//  Created by test on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(id)sender;
- (IBAction)enterPressed;

@end
