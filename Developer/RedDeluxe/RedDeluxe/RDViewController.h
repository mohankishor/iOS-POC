//
//  RDViewController.h
//  RedDeluxe
//
//  Created by test on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirQualityAlertsViewController.h"
@interface RDViewController : UIViewController<NSXMLParserDelegate>
- (IBAction)showAirQualityAlerts:(id)sender;
@property BOOL checkAQI;
@property (weak, nonatomic) IBOutlet UIButton *currentParticlePollutionButton;
@property (weak, nonatomic) IBOutlet UIButton *currentOzoneButton;
@property (weak, nonatomic) IBOutlet UIButton *todaysForecastParticlePollutionButton;
@property (weak, nonatomic) IBOutlet UIButton *todaysForecastOzoneButton;
@property (weak, nonatomic) IBOutlet UIButton *tomorrowsForecastParticlePollutionButton;
@property (weak, nonatomic) IBOutlet UIButton *tomorrowsForecastOzoneButton;
@end
