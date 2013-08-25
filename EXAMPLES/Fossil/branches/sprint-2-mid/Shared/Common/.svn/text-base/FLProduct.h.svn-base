//
//  FLProduct.h
//  Fossil
//
//  Created by Sanath on 13/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FLProduct : NSObject 
{
	NSString     *mTitle;
	NSNumber     *mPrice;
	NSString       *mURL;
	NSString       *mSKU;
	NSString *mImagePath;
	BOOL mIsWatch;
}

@property (nonatomic,retain) NSString *productURL;
@property (nonatomic,retain) NSString *productSKU;
@property (nonatomic,retain) NSString *productTitle;
@property (nonatomic,retain) NSNumber *productPrice;
@property (nonatomic,retain) NSString *productImagePath;
@property (nonatomic,assign) BOOL productIsWatch;


- (id) initWithTitle:(NSString *) prodTitle url:(NSString *) prodURL price:(NSNumber *) prodPrice sku:(NSString *) prodSKU imagepath:(NSString *) prodImagePath iswatch:(BOOL) prodIsWatch;

@end