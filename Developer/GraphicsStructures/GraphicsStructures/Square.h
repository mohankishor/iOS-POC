//
//  Square.h
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawSquare.h"
@interface Square : UIViewController
@property CGFloat length;
@property (nonatomic,strong) DrawSquare *drawSquare;
@property CGFloat squarex;
@property CGFloat squarey;
@property (nonatomic,strong) UIButton *button;

@end
