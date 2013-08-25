//
//  FLProduct.m
//  Fossil
//
//  Created by Sanath on 13/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "FLProduct.h"


@implementation FLProduct

@synthesize productTitle = mTitle,productPrice = mPrice, productURL = mURL, productSKU = mSKU, productImagePath = mImagePath;

- (id) initWithTitle:(NSString *) prodTitle url:(NSString *) prodURL price:(NSNumber *) prodPrice sku:(NSString *) prodSKU imagepath:(NSString *) prodImagePath
{
	self.productTitle = prodTitle;
	self.productPrice = prodPrice;
	self.productURL = prodURL;
	self.productSKU = prodSKU;
	self.productImagePath = prodImagePath;
	return self;
}

- (void) dealloc
{
	[super dealloc];
	self.productPrice = nil;
	self.productTitle = nil;
	self.productURL = nil;
	self.productSKU = nil;
	self.productImagePath = nil;	
}

@end
