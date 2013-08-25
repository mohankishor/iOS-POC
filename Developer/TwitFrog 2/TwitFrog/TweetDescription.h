//
//  TweetDescription.h
//  TwitFrog
//
//  Created by test on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeTweet.h"
@interface TweetDescription : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *screenImageView;
@property (strong,nonatomic) NSString *tweetMessage;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
- (IBAction)composeTweet:(UIButton *)sender;
@property(nonatomic,strong) NSData *imageContents;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong,nonatomic) NSString *userName;
@end
