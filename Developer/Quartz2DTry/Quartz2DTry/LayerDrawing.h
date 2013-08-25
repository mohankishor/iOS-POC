//
//  LayerDrawing.h
//  Quartz2DTry
//
//  Created by test on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawFlag.h"
@interface LayerDrawing : UIViewController{
    DrawFlag *drawFlag;
}
@property(nonatomic,strong) DrawFlag *drawFlag;


@end
