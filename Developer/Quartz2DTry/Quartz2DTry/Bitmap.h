//
//  Bitmap.h
//  Quartz2DTry
//
//  Created by test on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonFill.h"
@interface Bitmap : UIViewController
{
    PolygonFill *polygonFill;
}
@property(nonatomic,strong) PolygonFill *polygonFill;

@end
