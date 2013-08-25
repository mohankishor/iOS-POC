//
//  IODOrder.h
//  iOSDiner
//
//  Created by test on 03/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IODItem;
@interface IODOrder : NSObject
@property (nonatomic,strong) NSMutableDictionary* orderItems;

- (IODItem*)findKeyForOrderItem:(IODItem*)searchItem;
- (NSMutableDictionary *)orderItems;
- (NSString*)orderDescription;
- (void)addItemToOrder:(IODItem*)inItem;
- (void)removeItemFromOrder:(IODItem*)inItem;
- (float)totalOrder;

@end
