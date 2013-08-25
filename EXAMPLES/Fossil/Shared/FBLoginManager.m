//
//  FBLoginManager.m
//  fbtest
//
//  Created by Akhilesh Mishra on 01/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//   \"media\":[{\"type\":\"image\",\"src\":\"http://img40.yfrog.com/img40/5914/iphoneconnectbtn.jpg\",\"href\":\"http://developers.facebook.com/connect.php?tab=iphone/\"}]
//

#import "FBLoginManager.h"
#import "FBConnect.h"


#define RESET(obj) (if(obj != nil)[obj release];obj = nil;)

@interface FBLoginManager()

-(void) InitializeValues;
-(bool) checkApplicationPars;
-(bool) checkPublishPars;
-(void) DestroyData;
-(void) publishStream;

@end




@implementation FBLoginManager


static NSString* kAppId = @"159615424067874";

	
///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

-(id) initWithProduct:(FLProduct*) product;
{
	[super init];
	if (FL_IS_IPAD)
	{
		mTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FL_IPAD_HEIGHT, FL_IPAD_WIDTH)];
	}
	else
	{
		mTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FL_IPHONE_HEIGHT, FL_IPHONE_WIDTH)];
	}

	
	mTransparentView.backgroundColor = [UIColor clearColor];
	[[UIApplication sharedApplication].keyWindow addSubview:mTransparentView];
	//NSLog(@"superclass %@",[self ]);
	mPermissions        =       [[NSArray arrayWithObjects: 
					                              @"publish_stream", 
							    nil]retain];
	mFacebook           =       [[Facebook alloc] init];
	NSString* mys       =       [NSString stringWithFormat:@"$%d",[product.productPrice intValue]];
	mProductPrice       =       [[NSString alloc]initWithString:mys];
	mProductTitle       =       [[NSString alloc]initWithString:product.productTitle];
	mNameofApplication  =       [[NSString alloc]initWithString:@"Fossils"];
	mApplicationWebsite =       [[NSString alloc]initWithString:product.productURL];
	mImageSrc           =       [[NSString alloc]initWithString:product.productImagePath];
	mImageWebsite       =       [[NSString alloc]initWithString:product.productURL]; 
	
	return self;
}

-(void) InitializeValues
{
	mNameofApplication   =  nil;
	mApplicationWebsite  =  nil;
	mProductPrice        =  nil;
	mProductTitle        =  nil;
	mImageSrc            =  nil;
	mImageWebsite        =  nil;
}

-(void) logout 
{
	[mFacebook logout:self]; 
}


-(void) Login
{
	[mFacebook authorize:kAppId permissions:mPermissions delegate:self];
}
-(void) LoginAndPublish
{
	[self Login];
}

- (void) publishStream
{
	if([self checkPublishPars] == false || [self checkApplicationPars] == false)
		return;
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
														   mNameofApplication ,   @"text",
														   mApplicationWebsite,   @"href", 
														   nil], 
								 nil];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
		//Note: 
		//(1) The NSArray and NSDictionary are released inside the function stringWithObjects:Object. So
		//    we are not releasing it here.
		//(2) Since a deallocated object is incapable of recieving a message a message should not be sent
		//    to such an object. A nil message cane be sent to a non-nil object on the other hand.
	NSArray* mediaArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
													 mImageSrc,           @"src",
													 @"image",            @"type",
													 mImageWebsite,       @"href",
													 nil],            
						   nil];
	
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								mNameofApplication,           @"name",
								mProductTitle,                @"caption",
								mProductPrice,                @"description",
								mApplicationWebsite,          @"href", 
								mediaArray,                   @"media",
								nil];
	
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   kAppId,                   @"api_key",
								   @"Share on Facebook",     @"user_message_prompt",
								   actionLinksStr,           @"action_links",
								   attachmentStr,            @"attachment",
								   nil];

	[mFacebook dialog:  @"stream.publish"
			andParams:  params
		  andDelegate:  self];
	
}

-(bool) checkApplicationPars
{
	return ((mNameofApplication != nil) && (mApplicationWebsite != nil));
}
-(bool) checkPublishPars
{
	return ((mImageSrc != nil) && (mImageWebsite != nil) && (mProductPrice != nil)
			&& (mProductTitle != nil));
}


-(void)dealloc
{
	[mTransparentView release];
	[mFacebook logout:self];
	[mFacebook release];
	[mPermissions release];
	[self DestroyData];
	[super dealloc];
	 
}
-(void) DestroyData
{
	
	if(mApplicationWebsite != nil)
		[mApplicationWebsite release];
	
	if(mNameofApplication != nil)
		[mNameofApplication release];
	
	if(mProductPrice != nil)
		[mProductPrice release];
	
	if(mProductTitle != nil)
		[mProductTitle release];
	
	if(mImageSrc != nil)
		[mImageSrc release];
	
	if(mImageWebsite != nil)
		[mImageWebsite release];
	[self InitializeValues];
	
};
/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	NSLog(@"received response - log in");
};

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSLog(@"No Response. May be you dont have permission to open this site");
};

/*
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0]; 
	}
	if ([result objectForKey:@"owner"]) 
	{
		NSLog(@"Photo Upload Successful");
	} else
	{
		NSLog(@"Some error occured");
	}
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

-(void) dialogDidNotComplete:(FBDialog*)dialog
{
	NSLog(@"Dialog did not complete");
		//[self DestroyData ];
	[mTransparentView removeFromSuperview];

}
/* 
 * Called when a UIServer Dialog successfully return
 */
- (void)dialogDidComplete:(FBDialog*)dialog
{
	NSLog(@"Published Successfully");
	[mTransparentView removeFromSuperview];

}

/*
 * Callback for facebook login
 */ 
-(void) fbDidLogin 
{
	[self publishStream];
}



- (void)fbDidNotLogin:(BOOL)cancelled 
{
	NSLog(@"Login Was not Successful");
	[mTransparentView removeFromSuperview];
		//[self DestroyData];
}



@end
