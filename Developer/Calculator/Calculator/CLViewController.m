//
//  CLViewController.m
//  Calculator
//
//  Created by test on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CLViewController.h"
#import "CalculatorBrain.h"
@interface CLViewController()
@property (nonatomic) BOOL isUserInTheMiddleOfANumber;
@property (nonatomic,strong) CalculatorBrain *brain;
@end
@implementation CLViewController

@synthesize display = _display;
@synthesize brain = _brain;
@synthesize isUserInTheMiddleOfANumber = _isUserInTheMiddleOfANumber;
-(CalculatorBrain *)brain
  {
      if(!_brain) _brain = [[CalculatorBrain alloc]init];
      return _brain;
  }
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if(self.isUserInTheMiddleOfANumber)
    {
    NSString *currentText = self.display.text;
    NSString *newText = [currentText stringByAppendingString:digit];
    self.display.text = newText;
    }
    else
    {
        self.display.text = digit;
        self.isUserInTheMiddleOfANumber = YES; 
    }
    }

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.isUserInTheMiddleOfANumber) [self enterPressed];
    double result = [self.brain performOperation:[sender currentTitle]];
    self.display.text = [NSString stringWithFormat:@"%g",result];
}

- (IBAction)enterPressed {
     [self.brain pushOperand:[self.display.text doubleValue]];
    self.isUserInTheMiddleOfANumber = NO;
}

@end
