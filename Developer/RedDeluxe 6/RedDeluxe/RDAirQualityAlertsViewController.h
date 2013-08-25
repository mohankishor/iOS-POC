//
//  RDAirQualityAlertsViewController.h
//  RedDeluxe
//
//  Created by Mohan Kishore on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDShareViewController.h"
#import "CustomBadge.h"
#import "RDMapKit.h"

@protocol ZipCodeDelegate <NSObject>

- (void) sendZipCode:(UIViewController *)controller withDataSent:(NSInteger)data;

@end

@interface RDAirQualityAlertsViewController : RDShareViewController <NSXMLParserDelegate>

- (IBAction)findZipFromGps:(id)sender;

- (IBAction)showCurrentForecasts:(id)sender;

- (IBAction)changeLocation:(id)sender;

- (IBAction)showFAQ:(id)sender;

@property (nonatomic,strong) RDMapKit *mapkitCoordinate;

@property (weak, nonatomic) IBOutlet UIView *mainBackGroundView;

@property (weak, nonatomic) IBOutlet UIView *changeLocationView;

@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;

@property (weak, nonatomic) IBOutlet UIScrollView *faqScrollView;

- (IBAction)doneEditingZipCode:(id)sender;

- (IBAction)closeModelShareView:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *mainAQIView;

@property (weak, nonatomic) IBOutlet UIButton *closeModelShareView;

@property (weak, nonatomic) IBOutlet UIToolbar *doneToolBar;

@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;

@property BOOL checkFormat;

@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;

- (IBAction)shareButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *alertContentsTextView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *alertsHeadingLabel;

@property (weak, nonatomic) IBOutlet UILabel *alertHeadingTextLabel;

@property (nonatomic,assign)NSString *colourOfTheAQI;

@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic,assign) NSInteger zipCodeForLocation;

@property (weak, nonatomic) IBOutlet UIView *shareButtonsView;

- (IBAction)sendTweet:(id)sender;

- (IBAction)postOnFacebook:(id)sender;

- (IBAction)sendMail:(id)sender;

@property (retain, nonatomic) id <ZipCodeDelegate> delegate;

@property BOOL checkOzoneOrParticlePollution;

@property (nonatomic,retain) NSMutableArray *currentOzoneValues;

@property (nonatomic,retain) NSMutableArray *currentParticlePollutionValues;

@property BOOL checkForecastOrObserving;

@property int indexForCurrentOzoneValues;

@property int indexForCurrentParticlePollutionValues;

@property BOOL checkAQI;

-(NSString *)colourOfTheAQI:(NSInteger)AQIValue;

- (void)fetchForecastAndCurrentObservedValues;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *airQualityAlertsActivityIndicator;

@end
