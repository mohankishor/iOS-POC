//
//  BAViewController.h
//  BallAnimation
//
//  Created by test on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAViewController : UIViewController
@property int ballx;
@property int bally;
-(void)moveTheball;
@property (weak, nonatomic) IBOutlet UIImageView *ballImage;
@end
