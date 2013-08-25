//
//  ComposeTweet.h
//  TwitFrog
//
//  Created by test on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Twitter/Twitter.h"
#import "Accounts/ACAccount.h"
#import "Accounts/ACAccountStore.h"
#import "Accounts/ACAccountType.h"
@interface ComposeTweet : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeTweetTextView;
- (IBAction)composeTweet:(UIButton *)sender;
@property (nonatomic,strong) NSString *userName;
@end
