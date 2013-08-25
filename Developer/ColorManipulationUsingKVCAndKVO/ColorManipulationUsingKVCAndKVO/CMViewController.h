//
//  CMViewController.h
//  ColorManipulationUsingKVCAndKVO
//
//  Created by test on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *colorField;

@property (weak, nonatomic) IBOutlet UIImageView *colorDisplay;


@end
