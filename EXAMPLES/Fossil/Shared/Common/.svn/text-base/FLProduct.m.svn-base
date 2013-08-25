//
//  FLProduct.m
//  Fossil
//
//  Created by Sanath on 13/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "FLProduct.h"


@implementation FLProduct

@synthesize productTitle = mTitle,productPrice = mPrice, productURL = mURL, productSKU = mSKU, productImagePath = mImagePath, productIsWatch = mIsWatch;

- (id) initWithTitle:(NSString *) prodTitle url:(NSString *) prodURL price:(NSNumber *) prodPrice sku:(NSString *) prodSKU imagepath:(NSString *) prodImagePath iswatch:(BOOL) prodIsWatch
{
	self.productTitle = prodTitle;
	self.productPrice = prodPrice;
	self.productURL = prodURL;
	self.productSKU = prodSKU;
	self.productImagePath = prodImagePath;
	self.productIsWatch = prodIsWatch;
	return self;
}

- (void) dealloc
{
	self.productPrice = nil;
	self.productTitle = nil;
	self.productURL = nil;
	self.productSKU = nil;
	self.productImagePath = nil;	
	[super dealloc];
}

@end
