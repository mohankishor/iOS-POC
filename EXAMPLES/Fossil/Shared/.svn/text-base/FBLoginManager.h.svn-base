//
//  FBLoginManager.h
//  fbtest
//
//  Created by Akhilesh Mishra on 01/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FLProduct.h"


@interface FBLoginManager : NSObject<FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
	
	Facebook*                    mFacebook;
	NSArray*                     mPermissions;
	NSString*                    mNameofApplication;
	NSString*                    mApplicationWebsite;
	NSString*                    mImageWebsite;
	NSString*                    mImageSrc;
	NSString*                    mProductTitle;
	NSString*                    mProductPrice;
	UIView						 *mTransparentView;

}

-(id) initWithProduct:(FLProduct*) product;
-(void) LoginAndPublish;
-(void) logout;

@end



