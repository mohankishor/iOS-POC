//
//  Rectangle.h
//  GraphicStructures
//
//  Created by test on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rectangle : UIView
-(id) initWithLength:(CGFloat)length width:(CGFloat)width;
@property CGFloat length;
@property CGFloat width;
@end
