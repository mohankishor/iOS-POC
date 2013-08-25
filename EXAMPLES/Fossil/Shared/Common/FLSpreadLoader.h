//
//  FLSpreadLoader.h
//  Fossil
//
//  Created by Darshan on 28/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FLSpreadLoader : NSOperation {
	int mPage;
	UIImageView *mView;
}

@property (nonatomic,readwrite, assign) int page;

-(id) initWithSpread:(int) spreadPage andView:(UIImageView*) image;

-(void) main;

@end
