//
//  FLDataManagerProtocol.h
//  Fossil
//
//  Created by Sanath on 10/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

@class FLProduct;

@protocol FLDataManagerProtocol

@optional

- (NSInteger) noOfPages;
- (NSString *) pageImagePath:(NSInteger) pageNumber;
- (NSInteger) noOfProductsInPage:(NSInteger) pageNumber;
- (FLProduct *) productInPage:(NSInteger) pageNumber withIndex:(NSInteger) index;
- (NSInteger) pageImageId:(NSInteger) pageNumber;
- (NSInteger) noOfWatches;
- (NSString *)watchImagePath:(NSInteger) index;
- (FLProduct *)watchAtIndex:(NSInteger) index;

@end