//
//  TTViewController.m
//  TicTacToe
//
//  Created by test on 20/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTViewController.h"
@interface TTViewController()
@property (nonatomic) BOOL moverTrace;
@end
@implementation TTViewController
@synthesize moverTrace = _moverTrace;
- (IBAction)buttonPressed:(UIButton *)sender {
    if (!self.moverTrace) {
        [sender setTitle:@"X" forState:UIControlStateNormal];
        self.moverTrace = YES;
      //  self.myButton.enabled = NO;
    }
    else if (self.moverTrace) {
        [sender setTitle:@"O" forState:UIControlStateNormal];
        self.moverTrace = NO;
     //   self.myButton.enabled = NO;
    }
}
@end
