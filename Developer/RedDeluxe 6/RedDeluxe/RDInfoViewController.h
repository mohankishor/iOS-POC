//
//  RDInfoViewController.h
//  RedDeluxe
//
//  Created by Pradeep Rajkumar on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDShareViewController.h"

@interface RDInfoViewController : RDShareViewController

- (IBAction)shareTheApp:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shareTheAppView;
@property (weak, nonatomic) IBOutlet UIView *shareButtonsView;
@property (weak, nonatomic) IBOutlet UIView *shareTheAppBackGroundView;

- (IBAction)shareTheAppFromIcon:(id)sender;
- (IBAction)closeShareView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeModelShareView;
@property (weak, nonatomic) IBOutlet UIButton *shareAppIcon;
@property (weak, nonatomic) IBOutlet UIImageView *BackgroundImageView;
- (IBAction)sendTweet:(id)sender;
- (IBAction)postOnFacebook:(id)sender;
- (IBAction)sendMail:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mainBGView;

@end
