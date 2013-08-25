//
//  GHViewController.h
//  GestureHandling
//
//  Created by test on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"
#import "QuartzCore/QuartzCore.h"
@interface GHViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic,strong)IBOutlet UITapGestureRecognizer *tapRecognizer;

@property (nonatomic,strong)IBOutlet UISwipeGestureRecognizer *swipeRecognizer;

@property (nonatomic,strong)IBOutlet UIPinchGestureRecognizer *pinchRecognizer;

@property (nonatomic,strong)IBOutlet UILabel *myLabelForTap;
@property (nonatomic,strong)IBOutlet UILabel *myLabelForSwipe;
@property (nonatomic,strong)IBOutlet UILabel *myLabelForPinch;

-(IBAction)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer;

-(IBAction)handleSwipeGestureRecognizer:(UISwipeGestureRecognizer *)recognizer;

-(IBAction)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer;

@property int tapCount;
@property float previousX;
@property float previousY;
@property float currentX;
@property float currentY;
@property int swipeCount;
@property (nonatomic,strong) CALayer *myLayer;

@property int pinchCount;

@property (nonatomic,strong) UIImageView *catImage;

@end
