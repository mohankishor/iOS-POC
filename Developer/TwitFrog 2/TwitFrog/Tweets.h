//
//  Tweets.h
//  TwitFrog
//
//  Created by test on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tweets : NSManagedObject

@property (nonatomic, retain) NSString * tweetmessage;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSData * image;

@end
