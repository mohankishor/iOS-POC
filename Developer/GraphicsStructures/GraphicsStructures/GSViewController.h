//
//  GSViewController.h
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rectangle.h"
#import "Square.h"
#import "Circle.h"
#import "Triangle.h"
@interface GSViewController : UIViewController

- (IBAction)rectangleButtonPressed:(UIButton *)sender;

@property CGFloat length;

@property CGFloat width;

@property (strong, nonatomic) Rectangle *drawRectangle;
@property (strong, nonatomic) Square *drawSquare;
@property (strong, nonatomic) Circle *drawCircle;
@property (strong, nonatomic) Triangle *drawTriangle;
- (IBAction)squareButtonPressed:(UIButton *)sender;
- (IBAction)circleButtonPressed:(UIButton *)sender;
- (IBAction)triangleButtonPressed:(UIButton *)sender;

@end
