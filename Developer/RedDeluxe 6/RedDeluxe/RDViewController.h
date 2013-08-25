//
//  RDViewController.h
//  RedDeluxe
//
//  Created by Pradeep Rajkumar on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDInfoViewController.h"
#import "RDGetInformedViewController.h"
#import "RDSpeakUpViewController.h"
#import "RDAirQualityAlertsViewController.h"
#import "RDAQIViewController.h"
#import "RDShareViewController.h"

@interface RDViewController : RDShareViewController
{
    RDInfoViewController *infoViewController;
    RDGetInformedViewController *getInformedViewController;
    RDSpeakUpViewController *speakUpViewController;
    RDAirQualityAlertsViewController *airQualityAlertsViewController;
}
@property(nonatomic,strong) RDInfoViewController *infoViewController;
@property(nonatomic,strong)RDGetInformedViewController *getInformedViewController;
@property(nonatomic,strong)RDSpeakUpViewController *speakUpViewController;
@property(nonatomic,strong)RDAirQualityAlertsViewController *airQualityAlertsViewController;

@property (weak, nonatomic) IBOutlet UIView *shareButtonsView;
@property (weak, nonatomic) IBOutlet UIView *shareTheAppBackGroundView;
@property (weak, nonatomic) IBOutlet UIView *mainBackgroundView;

- (IBAction)shareTheAppFromIcon:(id)sender;
- (IBAction)closeShareView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeModelShareView;

- (IBAction)presentInfo:(id)sender;
- (IBAction)todaysAirQuality:(id)sender;
- (IBAction)getInformed:(id)sender;
- (IBAction)speakUp:(id)sender;
- (IBAction)donate:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareTheApp;
- (IBAction)shareTheAppFromIcon:(id)sender;

- (IBAction)sendTweet:(id)sender;
- (IBAction)postOnFacebook:(id)sender;
- (IBAction)sendMail:(id)sender;



@end
