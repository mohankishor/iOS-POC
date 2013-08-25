//
//  RDAQIViewController.h
//  RedDeluxe
//
//  Created by Mohan Kishore on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAirQualityAlertsViewController.h"
#import "RDShareViewController.h"
#import "CustomBadge.h"
#import "RDMapKit.h"

@interface RDAQIViewController : RDShareViewController<NSXMLParserDelegate,ZipCodeDelegate>

@property (nonatomic,strong) RDMapKit *mapkitCoordinate;

@property (weak, nonatomic) IBOutlet UIView *mainBackGroundView;

@property (weak, nonatomic) IBOutlet UIView *shareButtonsView;

@property (weak, nonatomic) IBOutlet UIView *shareTheAppBackGroundView;

@property (weak, nonatomic) IBOutlet UIView *changeLocationView;

@property (weak, nonatomic) IBOutlet UIImageView *changeLocationBGImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *faqScrollView;

@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;

- (IBAction)findZipFromGps:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *doneToolBar;

- (IBAction)doneEnteringZipCode:(id)sender;

- (IBAction)shareTheResults:(id)sender;

- (IBAction)closeShareView:(id)sender;

- (IBAction)showFAQ:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *closeModelShareView;

@property BOOL checkAQI;

@property (weak, nonatomic) IBOutlet UIButton *currentParticlePollutionButton;

@property (weak, nonatomic) IBOutlet UIButton *currentOzoneButton;

@property (weak, nonatomic) IBOutlet UIButton *todaysForecastParticlePollutionButton;

@property (weak, nonatomic) IBOutlet UIButton *todaysForecastOzoneButton;

@property (weak, nonatomic) IBOutlet UIButton *tomorrowsForecastParticlePollutionButton;

@property (weak, nonatomic) IBOutlet UIButton *tomorrowsForecastOzoneButton;

@property (weak, nonatomic) IBOutlet UILabel *currentParticlePollutionLabel;

@property BOOL checkForecastOrObserving;

@property (weak, nonatomic) IBOutlet UILabel *currentOzoneLabel;

@property (nonatomic,retain) NSMutableArray *currentOzoneValues;

@property (nonatomic,retain) NSMutableArray *currentParticlePollutionValues;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *currentParticlePollutionActivityIndicator;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *currentOzoneActivityIndicator;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *todaysForecastParticlePollutionActivityIndicator;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *todaysForecastOzoneActivityIndicator;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *tomorrowsForecastParticlePollutionActivityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *tomorrowsForecastOzoneActivityIndicator;

@property (nonatomic,retain) NSMutableArray *forecastOzoneValues;

@property (weak, nonatomic) IBOutlet UILabel *tomorrowsForecastParticlePollutionLabel;

@property (nonatomic,retain) NSMutableArray *forecastParticlePollutionValues;

@property (weak, nonatomic) IBOutlet UILabel *todaysForecastParticlePollutionLabel;

@property (weak, nonatomic) IBOutlet UILabel *tomorrowsForecastOzoneLabel;

@property BOOL checkOzoneOrParticlePollution;

@property (weak, nonatomic) IBOutlet UILabel *todaysOzoneLabel;

@property BOOL checkFormat;

@property int indexForCurrentOzoneValues;

@property int indexForCurrentParticlePollutionValues;

@property int indexForForecastOzoneValues;

@property int indexForForecastParticlePollutionValues;

@property (strong, nonatomic) NSDictionary* airQualityChart;

- (IBAction)displayForecasts:(id)sender;

-(NSString *)colourOfTheAQI:(NSInteger)AQIValue;

- (IBAction)showAirQualityAlerts:(id)sender;

- (void)fetchForecastAndCurrentObservedValues;

@property (weak, nonatomic) IBOutlet UIButton *showAirQualityAlerts;

- (IBAction)sendTweet:(id)sender;

- (IBAction)postOnFacebook:(id)sender;

- (IBAction)sendMail:(id)sender;

- (IBAction)changeLocation:(id)sender;

@property (nonatomic,assign) NSString *colourOfTheAirQualityIndex;

@property (weak, nonatomic) IBOutlet UIView *pollutionDetailsView;

@property (weak, nonatomic) IBOutlet UIImageView *pollutionDetailsBackgroundImage;

@property (weak, nonatomic) IBOutlet UITextView *pollutionDetailsLabel;

- (IBAction)pollutionDetialsButtonPressed:(UIButton*)sender;

@property (strong, nonatomic) NSDictionary* understandAQI;


@end
