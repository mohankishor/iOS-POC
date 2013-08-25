//
//  RDAQIViewController.m
//  RedDeluxe
//
//  Created by Mohan Kishore on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDAQIViewController.h"

@interface RDAQIViewController (){
	NSString* currentPPColor;
	NSString* currentOzoneColor;
	NSString* todayForecastPPColor;
	NSString* todayForecastOzoneColor;
	NSString* tomorrowForecastPPColor;
	NSString* tomorrowForecastOzoneColor;
}
@end

@implementation RDAQIViewController
{
    NSInteger zipCode;
    NSString *locationName;
}
@synthesize showAirQualityAlerts;
@synthesize indexForCurrentOzoneValues;
@synthesize indexForCurrentParticlePollutionValues;
@synthesize indexForForecastParticlePollutionValues;
@synthesize indexForForecastOzoneValues;
@synthesize doneToolBar;
@synthesize currentParticlePollutionActivityIndicator;
@synthesize currentOzoneActivityIndicator;
@synthesize todaysForecastParticlePollutionActivityIndicator;
@synthesize todaysForecastOzoneActivityIndicator;
@synthesize tomorrowsForecastParticlePollutionActivityIndicator;
@synthesize locationNameLabel;
@synthesize tomorrowsForecastOzoneActivityIndicator;
@synthesize mainBackGroundView;
@synthesize shareButtonsView;
@synthesize shareTheAppBackGroundView;
@synthesize changeLocationView;
@synthesize changeLocationBGImageView;
@synthesize faqScrollView;
@synthesize zipCodeField;
@synthesize closeModelShareView;
@synthesize checkAQI;
@synthesize currentParticlePollutionButton;
@synthesize currentOzoneButton;
@synthesize todaysForecastParticlePollutionButton;
@synthesize todaysForecastOzoneButton;
@synthesize tomorrowsForecastParticlePollutionButton;
@synthesize tomorrowsForecastOzoneButton;
@synthesize currentParticlePollutionLabel;
@synthesize currentOzoneLabel;
@synthesize currentOzoneValues;
@synthesize currentParticlePollutionValues;
@synthesize checkForecastOrObserving;
@synthesize forecastOzoneValues;
@synthesize tomorrowsForecastParticlePollutionLabel;
@synthesize forecastParticlePollutionValues;
@synthesize todaysForecastParticlePollutionLabel;
@synthesize tomorrowsForecastOzoneLabel;
@synthesize checkOzoneOrParticlePollution;
@synthesize todaysOzoneLabel;
@synthesize checkFormat;
@synthesize colourOfTheAirQualityIndex;
@synthesize pollutionDetailsView;
@synthesize pollutionDetailsBackgroundImage;
@synthesize pollutionDetailsLabel;
@synthesize mapkitCoordinate;
@synthesize airQualityChart;
@synthesize understandAQI;


#pragma FetchingAddressFromZipCode Using XML

- (void)fetchAddressFromZipCode:(int) zipCodeValue
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(!zipCodeValue)
    {
        zipCodeValue = 10001;
    }
    dispatch_queue_t queue = dispatch_queue_create("FetchingObservedXML", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{ 
		
        NSString *urlstring = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?address=%d&sensor=false",zipCodeValue];
        
        NSURL *url = [[NSURL alloc] initWithString:urlstring];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        xmlParser.delegate = self;
        
        BOOL successInParsingTheXMLDocument = [xmlParser parse];
        
        if(successInParsingTheXMLDocument)
        {
            NSLog(@"No Errors for Zip");
        }
        else
        {
			UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Unable to retrieve data.An Internet Connection is required." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Learn More", nil];
			[noInternetConnectionAlert show];
        }
        dispatch_async(main, ^{
	       self.locationNameLabel.text = locationName;
		});
    });
    
    dispatch_release(queue);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    indexForForecastOzoneValues = 0;
    indexForCurrentParticlePollutionValues = 0;
    indexForForecastParticlePollutionValues = 0;
    indexForCurrentOzoneValues = 0;
    self.currentOzoneButton.enabled = NO;
    self.currentParticlePollutionButton.enabled = NO;
    self.todaysForecastOzoneButton.enabled = NO;
    self.todaysForecastParticlePollutionButton.enabled = NO;
    self.tomorrowsForecastOzoneButton.enabled = NO;
    self.tomorrowsForecastParticlePollutionButton.enabled = NO;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,150,25)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,25)];  
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];    
    titleLabel.text = @"Today's Air Quality";
    [titleView addSubview:titleLabel];
    UIBarButtonItem *titleBarItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.rightBarButtonItem = titleBarItem; 
    currentOzoneValues = [[NSMutableArray alloc]init];
    currentParticlePollutionValues = [[NSMutableArray alloc]init];
    forecastOzoneValues = [[NSMutableArray alloc]init];
    forecastParticlePollutionValues = [[NSMutableArray alloc]init];
    [self.currentParticlePollutionActivityIndicator startAnimating];
    [self.currentOzoneActivityIndicator startAnimating];
    [self.todaysForecastOzoneActivityIndicator startAnimating];
    [self.todaysForecastParticlePollutionActivityIndicator startAnimating];
    [self.tomorrowsForecastParticlePollutionActivityIndicator startAnimating];
    [self.tomorrowsForecastOzoneActivityIndicator startAnimating];
    [self fetchAddressFromZipCode:zipCode];
    [self fetchForecastAndCurrentObservedValues];
    zipCodeField.delegate = (id)self;
    zipCodeField.keyboardType = UIKeyboardTypeNumberPad;
    mapkitCoordinate = [[RDMapKit alloc] init];
    self.airQualityChart = [[NSDictionary alloc] initWithObjectsAndKeys:@"GOOD", @"Green",
							@"MODERATE",@"Yellow",
							@"UNHEALTHY FOR SENSITIVE GROUPS",@"Orange",
							@"UNHEALTHY",@"Red",
							@"VERY UNHEALTHY",@"Purple",
							@"HAZARDOUS",@"Maroon",
							nil];
	self.understandAQI = [[NSDictionary alloc] initWithObjectsAndKeys:@"The Air Quality Index(AQI) tells you how clean or polluted your air is. The AQI tells when breathing air pollution might be a concern for you.\n\nAir quality is considered satisfactory, and air pollution poses little or no risk.\n\nTo learn more about air pollution health risks, visit: http://www.stateoftheair.org/health-risks/",@"Green",
						  @"The Air Quality Index(AQI) tells you how clean or polluted your air is. The AQI tells when breathing air pollution might be a concern for you.\n\nAir quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people who are unusually sensitive to air pollution.\n\nTo learn more about air pollution health risks, visit: http://www.stateoftheair.org/health-risks/",@"Yellow",
						  @"The Air Quality Index(AQI) tells you how clean or polluted your air is. The AQI tells when breathing air pollution might be a concern for you.\n\nMembers of sensitive groups may experience health effects. The general public is not likely to be affected.\n\nTo learn more about air pollution health risks, visit: http://www.stateoftheair.org/health-risks/",@"Orange",
						  @"The Air Quality Index(AQI) tells you how clean or polluted your air is. The AQI tells when breathing air pollution might be a concern for you.\n\nEveryone may begin to experience health efects; members of sensitive groups may experience more serioius health effects.\n\nTo learn more about air pollution health risks, visit: http://www.stateoftheair.org/health-risks/",@"Red",
						  @"The Air Quality Index(AQI) tells you how clean or polluted your air is. The AQI tells when breathing air pollution might be a concern for you.\n\nHealth warnings of emergency conditions. The entire population is more likely to be affected.\n\nTo learn more about air pollution health risks, visit: http://www.stateoftheair.org/health-risks/",@"Purple",
						  @"The Air Quality Index(AQI) tells you how clean or polluted your air is. The AQI tells when breathing air pollution might be a concern for you.\n\nHelath warnings of emergency conditions. The entire population is more likely to be affected.\n\nTo learn more about air pollution health risks, visit: http://www.stateoftheair.org/health-risks/",@"Maroon",
						  nil];
	
	[faqScrollView setContentSize:CGSizeMake(faqScrollView.frame.size.width, faqScrollView.frame.size.height + 28)];
	
}
- (void)viewDidUnload
{
    [self setCurrentOzoneButton:nil];
    [self setTodaysForecastParticlePollutionButton:nil];
    [self setTodaysForecastOzoneButton:nil];
    [self setTomorrowsForecastParticlePollutionButton:nil];
    [self setTomorrowsForecastOzoneButton:nil];
    [self setCurrentParticlePollutionButton:nil];
    [self setCurrentParticlePollutionLabel:nil];
    [self setCurrentOzoneLabel:nil];
    [self setCurrentParticlePollutionActivityIndicator:nil];
    [self setCurrentOzoneActivityIndicator:nil];
    [self setTodaysForecastParticlePollutionActivityIndicator:nil];
    [self setTodaysForecastOzoneActivityIndicator:nil];
    [self setTomorrowsForecastParticlePollutionActivityIndicator:nil];
    [self setTomorrowsForecastOzoneActivityIndicator:nil];
    [self setTodaysOzoneLabel:nil];
    [self setTomorrowsForecastOzoneLabel:nil];
    [self setTodaysForecastParticlePollutionLabel:nil];
    [self setTomorrowsForecastParticlePollutionLabel:nil];
    [self setShareTheAppBackGroundView:nil];
    [self setShareButtonsView:nil];
    [self setMainBackGroundView:nil];
    [self setCloseModelShareView:nil];
    [self setChangeLocationView:nil];
    [self setChangeLocationBGImageView:nil];
    [self setZipCodeField:nil];
    [self setDoneToolBar:nil];
    [self setFaqScrollView:nil];
    [self setLocationNameLabel:nil];
    [self setShowAirQualityAlerts:nil];
    [self setPollutionDetailsView:nil];
    [self setPollutionDetailsBackgroundImage:nil];
    [self setPollutionDetailsLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:208/255.0 green:26/255.0 blue:44/255.0 alpha:0.5];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma TextFieldDelegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 5) ? NO : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == zipCodeField)
    {
		[self.view bringSubviewToFront:doneToolBar];
	}
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"formatted_address"]) {
        checkFormat = YES;
    }
    if([elementName isEqualToString:@"ObsByZipList"]) {
        checkForecastOrObserving = YES;
    }
    else if([elementName isEqualToString:@"ForecastByZipList"])
    {
        checkForecastOrObserving = NO;
    }
    if([elementName isEqualToString:@"AQI"]) {
        checkAQI = YES;
    }
    else
    {
        checkAQI = NO;
    }   
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(checkFormat)
    {
        locationName = string;
        locationName = [locationName substringToIndex:[locationName length]-10];
        checkFormat = NO;
    }
    if (checkForecastOrObserving) {
        if ([string isEqualToString:@"OZONE"]) {
            checkOzoneOrParticlePollution = YES;
        }
        else if ([string isEqualToString:@"PM2.5"])
        {
            checkOzoneOrParticlePollution = NO;
        }
        if (checkAQI && checkOzoneOrParticlePollution) {
            [currentOzoneValues insertObject:string atIndex:indexForCurrentOzoneValues];
            indexForCurrentOzoneValues = indexForCurrentOzoneValues + 1;
        }
        else if(checkAQI && !checkOzoneOrParticlePollution)
        {
            [currentParticlePollutionValues insertObject:string atIndex:indexForCurrentParticlePollutionValues];
            indexForCurrentParticlePollutionValues = indexForCurrentParticlePollutionValues + 1;
            NSLog(@"%@",currentParticlePollutionValues);
        }
    }
    else if(!checkForecastOrObserving) {
        if ([string isEqualToString:@"OZONE"]) {
            checkOzoneOrParticlePollution = YES;
        }
        else if ([string isEqualToString:@"PM2.5"])
        {
            checkOzoneOrParticlePollution = NO;
        }
        if (checkAQI && checkOzoneOrParticlePollution) {
            [forecastOzoneValues insertObject:string atIndex:indexForForecastOzoneValues];
            indexForForecastOzoneValues = indexForForecastOzoneValues + 1;
        }
        else if(checkAQI && !checkOzoneOrParticlePollution)
        {
            [forecastParticlePollutionValues insertObject:string atIndex:indexForForecastParticlePollutionValues];
            indexForForecastParticlePollutionValues = indexForForecastParticlePollutionValues + 1;
        }
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"ObsByZipList"])
    {
        indexForCurrentOzoneValues = 0;
        indexForCurrentParticlePollutionValues = 0;
		return;
    }
    else if([elementName isEqualToString:@"ForecastByZipList"])
    {
        indexForForecastOzoneValues = 0;
        indexForForecastParticlePollutionValues = 0;
		return;
    }
    else if([elementName isEqualToString:@"GeocodeResponse"])
		return;
}

#pragma colour based on AQI value

-(NSString *)colourOfTheAQI:(NSInteger)AQIValue
{
    NSString *colourOfTheAQI;
    if (AQIValue < 51) {
        colourOfTheAQI = @"Green";
    }
    else if((AQIValue > 50)&&(AQIValue < 101))
    {
        colourOfTheAQI = @"Yellow";
    }
    else if((AQIValue > 100)&&(AQIValue < 151))
    {
        colourOfTheAQI = @"Orange";
    }
    else if((AQIValue > 150)&&(AQIValue < 201))
    {
        colourOfTheAQI = @"Red";
    }
    else if((AQIValue > 200)&&(AQIValue < 301))
    {
        colourOfTheAQI = @"Purple";
    }
    else if((AQIValue > 300)&&(AQIValue < 501))
    {
        colourOfTheAQI = @"Maroon";
    }
    return colourOfTheAQI;
}

#pragma Segue to the next view controller

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AirQualityAlerts"]) {
		NSLog(@"%@",self.colourOfTheAirQualityIndex);
        RDAirQualityAlertsViewController *airQualityAlerts = [segue destinationViewController];
        airQualityAlerts.delegate = self;
        airQualityAlerts.colourOfTheAQI = self.colourOfTheAirQualityIndex;
        airQualityAlerts.zipCodeForLocation = zipCode;
        //self.colourOfTheAirQualityIndex = @"Green";
    }
}

- (IBAction)showAirQualityAlerts:(id)sender {
    [self performSegueWithIdentifier:@"AirQualityAlerts" sender:self];
}

#pragma FetchForecastResults

- (void)fetchForecastAndCurrentObservedValues
{
    if (!zipCode) {
        zipCode = 10001;
    }
    __block BOOL successInParsingTheXMLDocument;
    __block BOOL alertToBeShown = NO;
    self.currentOzoneLabel.text = @"";
    self.currentParticlePollutionLabel.text = @"";
    self.tomorrowsForecastOzoneLabel.text = @"";
    self.tomorrowsForecastParticlePollutionLabel.text = @"";
    self.todaysOzoneLabel.text = @"";
    self.todaysForecastParticlePollutionLabel.text = @"";
    [self.currentParticlePollutionActivityIndicator startAnimating];
    [self.currentOzoneActivityIndicator startAnimating];
    [self.todaysForecastOzoneActivityIndicator startAnimating];
    [self.todaysForecastParticlePollutionActivityIndicator startAnimating];
    [self.tomorrowsForecastParticlePollutionActivityIndicator startAnimating];
    [self.tomorrowsForecastOzoneActivityIndicator startAnimating];
    self.currentOzoneActivityIndicator.hidden = NO;
    self.currentParticlePollutionActivityIndicator.hidden = NO;
    self.todaysForecastOzoneActivityIndicator.hidden = NO;
    self.todaysForecastParticlePollutionActivityIndicator.hidden = NO;
    self.tomorrowsForecastOzoneActivityIndicator.hidden = NO;
    self.tomorrowsForecastParticlePollutionActivityIndicator.hidden = NO;
    dispatch_queue_t queue = dispatch_queue_create("FetchingObservedXML", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{ 
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://ws1.airnowgateway.org/GatewayWebServiceREST/Gateway.svc/observedbyzipcode?zipcode=%d&format=xml&key=5D38E681-0393-4FF5-8639-A31E46167B46",zipCode]];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        xmlParser.delegate = self;
        
        successInParsingTheXMLDocument = [xmlParser parse];
        
        if(successInParsingTheXMLDocument)
        {
            NSLog(@"No Errors");
            alertToBeShown = NO;
        }
        else
        {
            if (!alertToBeShown) {
                UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Unable to retrieve data.An Internet Connection is required." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Learn More", nil];
                [noInternetConnectionAlert show];
                alertToBeShown = YES;
                NSLog(@"%d",alertToBeShown);
            }
        }
        dispatch_async(main, ^{
            [self.currentParticlePollutionActivityIndicator stopAnimating];
            self.currentParticlePollutionActivityIndicator.hidden = YES;
            if ([currentParticlePollutionValues count] != 0) {
                if ([[currentParticlePollutionValues objectAtIndex:0]integerValue] < 0) {
                    [currentParticlePollutionValues replaceObjectAtIndex:0 withObject:@"0"];
                }
                self.currentParticlePollutionLabel.text = [currentParticlePollutionValues objectAtIndex:0];
			    NSString *colourOfTheAQI = [self colourOfTheAQI:[[currentParticlePollutionValues objectAtIndex:0]integerValue]];
				currentPPColor = colourOfTheAQI;
                CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:@"1"];
                if ([colourOfTheAQI isEqualToString:@"Orange"]||[colourOfTheAQI isEqualToString:@"Red"]||[colourOfTheAQI isEqualToString:@"Purple"]||[colourOfTheAQI isEqualToString:@"Maroon"]||[colourOfTheAQI isEqualToString:@"Yellow"]) {
                    [customBadge1 setFrame:CGRectMake(self.view.frame.size.width/2+self.showAirQualityAlerts.frame.size.width/2+10, 360, customBadge1.frame.size.width, customBadge1.frame.size.height)];
                    [self.view addSubview:customBadge1];    
				}
                self.colourOfTheAirQualityIndex = colourOfTheAQI;
                NSLog(@"%@",self.colourOfTheAirQualityIndex);
                [self.currentParticlePollutionButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Air_Quality_Current_Box_%@",colourOfTheAQI] ofType:@"png"]] forState:UIControlStateNormal];
                self.currentParticlePollutionButton.enabled = YES;
            }
            else
            {
                self.currentParticlePollutionLabel.text = @"--";
                self.currentParticlePollutionButton.enabled = NO;
            }
            [self.currentOzoneActivityIndicator stopAnimating];
            self.currentOzoneActivityIndicator.hidden = YES;
            if ([currentOzoneValues count] != 0) {
                if ([[currentOzoneValues objectAtIndex:0]integerValue] < 0) {
                    [currentOzoneValues replaceObjectAtIndex:0 withObject:@"0"];
                }
                self.currentOzoneLabel.text = [currentOzoneValues objectAtIndex:0];
                NSString *colourOfTheAQI = [self colourOfTheAQI:[[currentOzoneValues objectAtIndex:0]integerValue]];
				currentOzoneColor = colourOfTheAQI;
                CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:@"1"];
                if ([colourOfTheAQI isEqualToString:@"Orange"]||[colourOfTheAQI isEqualToString:@"Red"]||[colourOfTheAQI isEqualToString:@"Purple"]||[colourOfTheAQI isEqualToString:@"Maroon"]||[colourOfTheAQI isEqualToString:@"Yellow"]) {
                    [customBadge1 setFrame:CGRectMake(self.view.frame.size.width/2+self.showAirQualityAlerts.frame.size.width/2+10, 360, customBadge1.frame.size.width, customBadge1.frame.size.height)];
                    [self.view addSubview:customBadge1];  
                }
                if ([self.colourOfTheAirQualityIndex isEqualToString:@"Green"]) {
					self.colourOfTheAirQualityIndex = colourOfTheAQI;   
                }
                [self.currentOzoneButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Air_Quality_Current_Box_%@",colourOfTheAQI] ofType:@"png"]] forState:UIControlStateNormal];
                self.currentOzoneButton.enabled = YES;
            }
            else
            {
                self.currentOzoneLabel.text = @"--";   
                self.currentOzoneButton.enabled = NO;
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
    
    dispatch_release(queue);
    dispatch_queue_t queueforForecast = dispatch_queue_create("FetchingForecastXML", NULL);
    dispatch_queue_t mainQueueForForecast = dispatch_get_main_queue();
    
    dispatch_async(queueforForecast, ^{ 
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://ws1.airnowgateway.org/GatewayWebServiceREST/Gateway.svc/forecastbyzipcode?zipcode=%d&format=xml&key=5D38E681-0393-4FF5-8639-A31E46167B46",zipCode]];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        xmlParser.delegate = self;
        
        [xmlParser parse];
        dispatch_async(mainQueueForForecast, ^{
            [self.todaysForecastParticlePollutionActivityIndicator stopAnimating];
            self.todaysForecastParticlePollutionActivityIndicator.hidden = YES;
            if ([forecastParticlePollutionValues count] != 0) {
                if ([[forecastParticlePollutionValues objectAtIndex:0]integerValue] < 0) {
                    [forecastParticlePollutionValues replaceObjectAtIndex:0 withObject:@"0"];
                }
                self.todaysForecastParticlePollutionLabel.text = [forecastParticlePollutionValues objectAtIndex:0];
				NSString *colourOfTheAQI = [self colourOfTheAQI:[[forecastParticlePollutionValues objectAtIndex:0]integerValue]];
                todayForecastPPColor = colourOfTheAQI;
				[self.todaysForecastParticlePollutionButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Air_Quality_Current_Box_%@",colourOfTheAQI] ofType:@"png"]] forState:UIControlStateNormal];
                self.todaysForecastParticlePollutionButton.enabled = YES;
            }
            else
            {
                self.todaysForecastParticlePollutionLabel.text = @"--";
                self.todaysForecastParticlePollutionButton.enabled = NO;
            }
            [self.todaysForecastOzoneActivityIndicator stopAnimating];
            self.todaysForecastOzoneActivityIndicator.hidden = YES;
            if ([forecastOzoneValues count] != 0) {
                if ([[forecastOzoneValues objectAtIndex:0]integerValue] < 0) {
                    [forecastOzoneValues replaceObjectAtIndex:0 withObject:@"0"];
                }
                self.todaysOzoneLabel.text = [forecastOzoneValues objectAtIndex:0];
				NSString *colourOfTheAQI = [self colourOfTheAQI:[[forecastOzoneValues objectAtIndex:0]integerValue]];
                todayForecastOzoneColor = colourOfTheAQI;
				[self.todaysForecastOzoneButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Air_Quality_Current_Box_%@",colourOfTheAQI] ofType:@"png"]] forState:UIControlStateNormal];
                self.todaysForecastOzoneButton.enabled = YES;
            }
            else
            {
                self.todaysOzoneLabel.text = @"--";
                self.todaysForecastOzoneButton.enabled = NO;
            }
            [self.tomorrowsForecastParticlePollutionActivityIndicator stopAnimating];
            self.tomorrowsForecastParticlePollutionActivityIndicator.hidden = YES;
            if ([forecastParticlePollutionValues count] > 1) {
                if ([[forecastParticlePollutionValues objectAtIndex:1]integerValue] < 0) {
                    [forecastParticlePollutionValues replaceObjectAtIndex:1 withObject:@"0"];
                }
                self.tomorrowsForecastParticlePollutionLabel.text = [forecastParticlePollutionValues objectAtIndex:1];
				NSString *colourOfTheAQI = [self colourOfTheAQI:[[forecastParticlePollutionValues objectAtIndex:1]integerValue]];
                tomorrowForecastPPColor = colourOfTheAQI;
				[self.tomorrowsForecastParticlePollutionButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Air_Quality_Current_Box_%@",colourOfTheAQI] ofType:@"png"]] forState:UIControlStateNormal];
                self.tomorrowsForecastParticlePollutionButton.enabled = YES;
            }
            else
            {
                self.tomorrowsForecastParticlePollutionLabel.text = @"--";
                self.tomorrowsForecastParticlePollutionButton.enabled = NO;
            }
            [self.tomorrowsForecastOzoneActivityIndicator stopAnimating];
            self.tomorrowsForecastOzoneActivityIndicator.hidden = YES;
            if ([forecastOzoneValues count] > 1) {
                if ([[forecastOzoneValues objectAtIndex:1]integerValue] < 0) {
                    [forecastOzoneValues replaceObjectAtIndex:1 withObject:@"0"];
                }
                self.tomorrowsForecastOzoneLabel.text = [forecastOzoneValues objectAtIndex:1];
				NSString *colourOfTheAQI = [self colourOfTheAQI:[[forecastOzoneValues objectAtIndex:1]integerValue]];
                tomorrowForecastOzoneColor = colourOfTheAQI;
				[self.tomorrowsForecastOzoneButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Air_Quality_Current_Box_%@",colourOfTheAQI] ofType:@"png"]] forState:UIControlStateNormal];
                self.tomorrowsForecastOzoneButton.enabled = YES;
            }
            else
            {
                self.tomorrowsForecastOzoneLabel.text = @"--";
                self.tomorrowsForecastOzoneButton.enabled = NO;
            }
        });
    });
    
    dispatch_release(queueforForecast);
}

- (IBAction)sendTweet:(id)sender {
    if ([currentParticlePollutionValues count] != 0) {
        if ([[currentParticlePollutionValues objectAtIndex:0]integerValue] < 0) {
            [currentParticlePollutionValues replaceObjectAtIndex:0 withObject:@"0"];
        }
       	super.initialTweetText = [[NSString alloc] initWithFormat:@"The air quality in %@ is %@ today! To get air and health updates, go to APP_URL",locationName,[self colourOfTheAQI:[[currentParticlePollutionValues objectAtIndex:0]integerValue]]];
    }
	
    [super sendTweet:nil];
}

- (IBAction)postOnFacebook:(id)sender {
    [super postOnFacebook:nil];
}

- (IBAction)sendMail:(id)sender {
    super.initialMailSubject = [[NSString alloc] initWithFormat:@"How's the air you're breathing?"];
    if ([currentParticlePollutionValues count] != 0) {
        if ([[currentParticlePollutionValues objectAtIndex:0]integerValue] < 0) {
            [currentParticlePollutionValues replaceObjectAtIndex:0 withObject:@"0"];
        }
       	super.initialMailBody = [[NSString alloc] initWithFormat:@"<html><body>The air quality in %@ is <font color = '%@'><b>%@</b></font></body></html> today! See what tomorrow will be like with the American Lung Association's free Red Deluxe App to get air and health updates right to your phone. Get it here APP_URL</body></html>",locationName,[self colourOfTheAQI:[[currentParticlePollutionValues objectAtIndex:0]integerValue]] ,[airQualityChart objectForKey:[self colourOfTheAQI:[[currentParticlePollutionValues objectAtIndex:0]integerValue]]]];
    }
    [super sendMail:nil];
}

- (IBAction)changeLocation:(id)sender {
    self.shareTheAppBackGroundView.alpha = 0.65;
    self.shareTheAppBackGroundView.opaque = NO;
    self.shareTheAppBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:shareTheAppBackGroundView];
    [self.view bringSubviewToFront:changeLocationBGImageView];
    [self.view bringSubviewToFront:changeLocationView];
    [closeModelShareView setFrame:CGRectMake(255.0, 25.0, 32.0, 32.0)];
    [self.view bringSubviewToFront:closeModelShareView];
}

- (IBAction)displayForecasts:(id)sender {
    [self fetchForecastAndCurrentObservedValues];
}
- (IBAction)findZipFromGps:(id)sender {
    zipCode = [mapkitCoordinate findCurrentZip];
    if(zipCode == 0)
    {
        
    }
    else
    {  
        zipCodeField.text = [NSString stringWithFormat:@"%@",zipCode];
    }
    
	
    
}

- (IBAction)doneEnteringZipCode:(id)sender 
{
	if ([zipCodeField.text length] < 5) {
		UIAlertView *alertForFiveDigitZipCode = [[UIAlertView alloc]initWithTitle:@"Invalid Zip Code" message:@"Please enter a valid 5 digit zip code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertForFiveDigitZipCode show];
	}
	else
	{
    [zipCodeField resignFirstResponder];
    zipCode = [zipCodeField.text intValue];
    [self fetchAddressFromZipCode:zipCode];
    [self.view bringSubviewToFront:mainBackGroundView];
    [self fetchForecastAndCurrentObservedValues];
    }
}

- (IBAction)showFAQ:(id)sender
{
    self.shareTheAppBackGroundView.alpha = 0.705;
    self.shareTheAppBackGroundView.opaque = NO;
    self.shareTheAppBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:shareTheAppBackGroundView];
    [self.view bringSubviewToFront:faqScrollView];
    [closeModelShareView setFrame:CGRectMake(290.0, 10.0, 30.0, 30.0)];
    [self.view bringSubviewToFront:closeModelShareView];
}

- (IBAction)shareTheResults:(id)sender {
    self.shareTheAppBackGroundView.alpha = 0.705;
    self.shareTheAppBackGroundView.opaque = NO;
    self.shareTheAppBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:shareTheAppBackGroundView];
    [self.view bringSubviewToFront:shareButtonsView];
    [closeModelShareView setFrame:CGRectMake(265.0,105.0, 32.0, 32.0)];
    [self.view bringSubviewToFront:closeModelShareView];
}

- (IBAction)closeShareView:(id)sender {
    [zipCodeField resignFirstResponder];
    [self.view bringSubviewToFront:mainBackGroundView];
}

- (void) sendZipCode:(UIViewController *)controller withDataSent:(NSInteger)data;
{
	if (zipCode != data) {
        zipCode = data;
        [self.currentParticlePollutionActivityIndicator startAnimating];
        [self.currentOzoneActivityIndicator startAnimating];
        [self.todaysForecastOzoneActivityIndicator startAnimating];
        [self.todaysForecastParticlePollutionActivityIndicator startAnimating];
        [self.tomorrowsForecastParticlePollutionActivityIndicator startAnimating];
        [self.tomorrowsForecastOzoneActivityIndicator startAnimating];
        [self fetchAddressFromZipCode:zipCode];
        [self fetchForecastAndCurrentObservedValues];
    }
}

- (IBAction)pollutionDetialsButtonPressed:(UIButton*)sender {
	
	NSInteger tagValue = sender.tag;
	NSString* BGColor;
	switch (tagValue) {
			
		case 1:
			BGColor = currentPPColor;
			break;
			
		case 2:
			BGColor = currentOzoneColor;
			break;
			
		case 3:
			BGColor = todayForecastPPColor;
			break;
			
		case 4:
			BGColor = todayForecastOzoneColor;	
			break;
		case 5:
			BGColor = tomorrowForecastPPColor;
			break;
			
		case 6:
			BGColor = tomorrowForecastOzoneColor;
			break;
			
		default:
			break;
	};
	
	self.pollutionDetailsBackgroundImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Air_Quality_Current_Box_%@",BGColor] ofType:@"png"]];
	self.pollutionDetailsLabel.text =[understandAQI objectForKey:BGColor];
	self.shareTheAppBackGroundView.alpha = 0.705;
    self.shareTheAppBackGroundView.opaque = NO;
    self.shareTheAppBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:shareTheAppBackGroundView];
    [self.view bringSubviewToFront:pollutionDetailsView];
    [closeModelShareView setFrame:CGRectMake(270.0,102.0, 32.0, 32.0)];
    [self.view bringSubviewToFront:closeModelShareView];
	
}
@end
