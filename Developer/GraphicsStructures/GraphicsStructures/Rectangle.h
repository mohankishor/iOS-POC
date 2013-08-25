//
//  Rectangle.h
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawRectangle.h"
@interface Rectangle : UIViewController
@property CGFloat length;
@property CGFloat width;
@property (nonatomic,strong) DrawRectangle *drawRectangle;
@property CGFloat rectanglex;
@property CGFloat rectangley;
@property (nonatomic,strong) UIButton *button;
@end
