//
//  RDAirQualityAlertsViewController.m
//  RedDeluxe
//
//  Created by Mohan Kishore on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDAirQualityAlertsViewController.h"

@implementation RDAirQualityAlertsViewController
{
    NSInteger zipCode;
    NSString *locationName;
}
@synthesize airQualityAlertsActivityIndicator;
@synthesize colourOfTheAQI;
@synthesize alertView;
@synthesize shareButton;
@synthesize alertContentsTextView;
@synthesize dateLabel;
@synthesize alertsHeadingLabel;
@synthesize alertHeadingTextLabel;
@synthesize mainAQIView;
@synthesize closeModelShareView;
@synthesize doneToolBar;
@synthesize locationNameLabel;
@synthesize mainBackGroundView;
@synthesize changeLocationView;
@synthesize zipCodeField;
@synthesize faqScrollView;
@synthesize checkFormat;
@synthesize alertImageView;
@synthesize zipCodeForLocation;
@synthesize shareButtonsView;
@synthesize delegate;
@synthesize checkForecastOrObserving;
@synthesize checkOzoneOrParticlePollution;
@synthesize currentOzoneValues;
@synthesize currentParticlePollutionValues;
@synthesize checkAQI;
@synthesize indexForCurrentOzoneValues;
@synthesize indexForCurrentParticlePollutionValues;
@synthesize mapkitCoordinate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma FetchingAddressFromZipCode Using XML

- (void)fetchAddressFromZipCode:(int) zipCodeValue
{
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view bringSubviewToFront:mainAQIView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	 mapkitCoordinate = [[RDMapKit alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self.airQualityAlertsActivityIndicator startAnimating];
    indexForCurrentParticlePollutionValues = 0;
    indexForCurrentOzoneValues = 0;
    currentOzoneValues = [[NSMutableArray alloc]init];
    currentParticlePollutionValues = [[NSMutableArray alloc]init];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,150,25)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,25)];  
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];    
    titleLabel.text = @"Air Quality Alerts";
    [titleView addSubview:titleLabel];
    UIBarButtonItem *titleBarItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.rightBarButtonItem = titleBarItem; 
    zipCodeField.delegate = (id)self;
    zipCodeField.keyboardType = UIKeyboardTypeNumberPad;
    if ([self.colourOfTheAQI isEqualToString:@"Green"]) {
        self.dateLabel.hidden = YES;
        self.alertsHeadingLabel.hidden = YES;
        self.alertImageView.hidden = YES;
        self.alertHeadingTextLabel.hidden = YES;
        self.alertContentsTextView.hidden = YES;
        self.shareButton.hidden = YES;
        self.alertView.hidden = YES;
		[self.airQualityAlertsActivityIndicator stopAnimating];
		self.airQualityAlertsActivityIndicator.hidden = YES;
    }
    else
    {
		CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:@"1"];	
		[customBadge1 setFrame:CGRectMake(self.view.frame.size.width/2+80, 360, customBadge1.frame.size.width, customBadge1.frame.size.height)];
        [self.view addSubview:customBadge1];  
		self.alertContentsTextView.backgroundColor = [UIColor clearColor];
		NSDate *date = [NSDate date];
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"MM/d/YYYY"];
		self.dateLabel.text = [dateFormat stringFromDate:date];  
		self.alertImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Alerts_Module_%@",self.colourOfTheAQI] ofType:@"png"]];
        if ([colourOfTheAQI isEqualToString:@"Yellow"]) {
            self.alertContentsTextView.text = @"Yellow - Moderate.Air Quality is acceptable.However,for some pollutants there may be a health concern for some people.";
        }
        else if ([colourOfTheAQI isEqualToString:@"Red"]) {
            self.alertContentsTextView.text = @"Red - Unhealthy.Everyone may begin to experience health effects.";
        }
        else if ([colourOfTheAQI isEqualToString:@"Maroon"]) {
            self.alertContentsTextView.text = @"Maroon - Hazardous.Health Warnings of emergency conditions.";
        }
        else if ([colourOfTheAQI isEqualToString:@"Purple"]) {
            self.alertContentsTextView.text = @"Purple - Very Unhealthy.Health Warnings of emergency conditions.";
        }
        else if ([colourOfTheAQI isEqualToString:@"Orange"]) {
            self.alertContentsTextView.text = @"Orange - Unhealthy for Sensitive Groups.Members of sensitive groups may experience healt effects.";
        }
	}
	self.airQualityAlertsActivityIndicator.hidden = YES;
	zipCode = self.zipCodeForLocation;
	[self fetchAddressFromZipCode:zipCode];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:208/255.0 green:26/255.0 blue:44/255.0 alpha:0.5];
}
- (void)viewDidUnload
{
    [self setMainBackGroundView:nil];
    [self setChangeLocationView:nil];
    [self setZipCodeField:nil];
    [self setFaqScrollView:nil];
    [self setMainAQIView:nil];
    [self setCloseModelShareView:nil];
    [self setDoneToolBar:nil];
    [self setLocationNameLabel:nil];
    [self setLocationNameLabel:nil];
    [self setAlertImageView:nil];
    [self setAlertContentsTextView:nil];
    [self setDateLabel:nil];
    [self setAlertsHeadingLabel:nil];
    [self setAlertHeadingTextLabel:nil];
    [self setAlertView:nil];
    [self setShareButton:nil];
    [self setShareButtonsView:nil];
	[self setAirQualityAlertsActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (IBAction)showCurrentForecasts:(id)sender {
	[self.delegate sendZipCode:self withDataSent:zipCode];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeLocation:(id)sender {
    
    self.mainBackGroundView.alpha = 0.65;
    self.mainBackGroundView.opaque = NO;
    self.mainBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:mainBackGroundView];
    [self.view bringSubviewToFront:changeLocationView];
    [closeModelShareView setFrame:CGRectMake(255.0, 25.0, 35.0, 32.0)];
    [self.view bringSubviewToFront:closeModelShareView];
	
}


- (IBAction)doneEditingZipCode:(id)sender {
	
	if ([zipCodeField.text length] < 5) {
		UIAlertView *alertForFiveDigitZipCode = [[UIAlertView alloc]initWithTitle:@"Invalid Zip Code" message:@"Please enter a valid 5 digit zip code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertForFiveDigitZipCode show];
	}
	else{
    [zipCodeField resignFirstResponder];
    zipCode = [zipCodeField.text intValue];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self.airQualityAlertsActivityIndicator startAnimating];
	self.airQualityAlertsActivityIndicator.hidden = NO;
	self.dateLabel.hidden = YES;
	self.alertsHeadingLabel.hidden = YES;
	self.alertImageView.hidden = YES;
	self.alertHeadingTextLabel.hidden = YES;
	self.alertContentsTextView.hidden = YES;
	self.shareButton.hidden = YES;
	self.alertView.hidden = YES;
    [self fetchAddressFromZipCode:zipCode];
    [self fetchForecastAndCurrentObservedValues];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.view bringSubviewToFront:mainAQIView];
	}
}

- (IBAction)closeModelShareView:(id)sender {
	
}


- (IBAction)showFAQ:(id)sender
{
    self.mainBackGroundView.alpha = 0.705;
    self.mainBackGroundView.opaque = NO;
    self.mainBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:mainBackGroundView];
    [self.view bringSubviewToFront:faqScrollView];
    [closeModelShareView setFrame:CGRectMake(275.0, 25.0, 35.0, 32.0)];
    [self.view bringSubviewToFront:closeModelShareView];
}

- (IBAction)closeShareView:(id)sender {
    [zipCodeField resignFirstResponder];
    [self.view bringSubviewToFront:mainAQIView];
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
    else if([elementName isEqualToString:@"GeocodeResponse"])
		return;
}


- (IBAction)shareButton:(id)sender {
    self.mainBackGroundView.alpha = 0.705;
    self.mainBackGroundView.opaque = NO;
    self.mainBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:mainBackGroundView];
    [self.view bringSubviewToFront:shareButtonsView];
    [closeModelShareView setFrame:CGRectMake(265.0, 105.0, 32.0, 32.0)];
    [self.view bringSubviewToFront:closeModelShareView];
}
- (IBAction)sendTweet:(id)sender {
    super.initialTweetText = [[NSString alloc] initWithFormat:@"The Red Deluxe app gives you the ability to see what your lungs are collecting anywhere in US. To get air and health updates, go to APP_URL"];
    [super sendTweet:nil];
	
}

- (IBAction)postOnFacebook:(id)sender {
    [super postOnFacebook:nil];
}

- (IBAction)sendMail:(id)sender {
    super.initialMailSubject = [[NSString alloc] initWithFormat:@"How's the air you're breathing?"];
	super.initialMailBody = [[NSString alloc] initWithFormat:@"The Red Deluxe app from the American Lung Association gives you the ability to see what your lungs are collecting anywhere in the United States. To get air and health updates, go to APP_URL"];
    [super sendMail:nil]; 
}
#pragma FetchForecastResults

- (void)fetchForecastAndCurrentObservedValues
{
    if (!zipCode) {
        zipCode = 10001;
    }
    __block BOOL successInParsingTheXMLDocument;
    __block BOOL alertToBeShown = NO;
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
            if ([currentParticlePollutionValues count] != 0) {
                if ([[currentParticlePollutionValues objectAtIndex:0]integerValue] < 0) {
                    [currentParticlePollutionValues replaceObjectAtIndex:0 withObject:@"0"];
                }
                NSString *colourOfTheAirQualityIndex = [self colourOfTheAQI:[[currentParticlePollutionValues objectAtIndex:0]integerValue]];
                NSLog(@"%@",colourOfTheAirQualityIndex);
				self.dateLabel.hidden = NO;
				self.alertsHeadingLabel.hidden = NO;
				self.alertImageView.hidden = NO;
				self.alertHeadingTextLabel.hidden = NO;
				self.alertContentsTextView.hidden = NO;
				self.shareButton.hidden = NO;
				self.alertView.hidden = NO;
                CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:@"1"];
                if ([colourOfTheAirQualityIndex isEqualToString:@"Orange"]||[colourOfTheAirQualityIndex isEqualToString:@"Red"]||[colourOfTheAirQualityIndex isEqualToString:@"Purple"]||[colourOfTheAirQualityIndex isEqualToString:@"Maroon"]||[colourOfTheAirQualityIndex isEqualToString:@"Yellow"]) {
                    [customBadge1 setFrame:CGRectMake(self.view.frame.size.width/2+80, 360, customBadge1.frame.size.width, customBadge1.frame.size.height)];
                    [self.view addSubview:customBadge1];    
                    self.alertContentsTextView.backgroundColor = [UIColor clearColor];
                    NSDate *date = [NSDate date];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM/d/YYYY"];
                    self.dateLabel.text = [dateFormat stringFromDate:date];  
                    self.alertImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Alerts_Module_%@",colourOfTheAirQualityIndex] ofType:@"png"]];
                    if ([colourOfTheAirQualityIndex isEqualToString:@"Yellow"]) {
                        self.alertContentsTextView.text = @"Yellow - Moderate.Air Quality is acceptable.However,for some pollutants there may be a health concern for some people.";
                    }
                    else if ([colourOfTheAirQualityIndex isEqualToString:@"Red"]) {
                        self.alertContentsTextView.text = @"Red - Unhealthy.Everyone may begin to experience health effects.";
                    }
                    else if ([colourOfTheAirQualityIndex isEqualToString:@"Maroon"]) {
                        self.alertContentsTextView.text = @"Maroon - Hazardous.Health Warnings of emergency conditions.";
                    }
                    else if ([colourOfTheAirQualityIndex isEqualToString:@"Purple"]) {
                        self.alertContentsTextView.text = @"Purple - Very Unhealthy.Health Warnings of emergency conditions.";
                    }
                    else if ([colourOfTheAirQualityIndex isEqualToString:@"Orange"]) {
                        self.alertContentsTextView.text = @"Orange - Unhealthy for Sensitive Groups.Members of sensitive groups may experience healt effects.";
                    }
					[self.airQualityAlertsActivityIndicator stopAnimating];
					self.airQualityAlertsActivityIndicator.hidden = YES;
			}
				else
				{
					self.dateLabel.hidden = YES;
					self.alertsHeadingLabel.hidden = YES;
					self.alertImageView.hidden = YES;
					self.alertHeadingTextLabel.hidden = YES;
					self.alertContentsTextView.hidden = YES;
					self.shareButton.hidden = YES;
					self.airQualityAlertsActivityIndicator.hidden = YES;
					self.alertView.hidden = YES; 
				}
				
            }
            if ([currentOzoneValues count] != 0) {
                if ([[currentOzoneValues objectAtIndex:0]integerValue] < 0) {
                    [currentOzoneValues replaceObjectAtIndex:0 withObject:@"0"];
                }
                NSString *colourOfTheAirQualityIndex = [self colourOfTheAQI:[[currentOzoneValues objectAtIndex:0]integerValue]];
                CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:@"1"];
                if ([colourOfTheAirQualityIndex isEqualToString:@"Orange"]||[colourOfTheAirQualityIndex isEqualToString:@"Red"]||[colourOfTheAirQualityIndex isEqualToString:@"Purple"]||[colourOfTheAirQualityIndex isEqualToString:@"Maroon"]||[colourOfTheAirQualityIndex isEqualToString:@"Yellow"]) {
                    [customBadge1 setFrame:CGRectMake(self.view.frame.size.width/2+80, 360, customBadge1.frame.size.width, customBadge1.frame.size.height)];
                    [self.view addSubview:customBadge1];    
                    self.alertContentsTextView.backgroundColor = [UIColor clearColor];
					self.dateLabel.hidden = NO;
					self.alertsHeadingLabel.hidden = NO;
					self.alertImageView.hidden = NO;
					self.alertHeadingTextLabel.hidden = NO;
					self.alertContentsTextView.hidden = NO;
					self.shareButton.hidden = NO;
					self.alertView.hidden = NO;
                    NSDate *date = [NSDate date];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM/d/YYYY"];
                    self.dateLabel.text = [dateFormat stringFromDate:date];  
                    self.alertImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"480x800_Alerts_Module_%@",colourOfTheAirQualityIndex] ofType:@"png"]];
                    if ([colourOfTheAirQualityIndex isEqualToString:@"Yellow"]) {
                        self.alertContentsTextView.text = @"Yellow - Moderate.Air Quality is acceptable.However,for some pollutants there may be a health concern for some people.";
                    }
                    else if ([colourOfTheAirQualityIndex isEqualToString:@"Red"]) {
                        self.alertContentsTextView.text = @"Red - Unhealthy.Everyone may begin to experience health effects.";
                    }
                    else if ([colourOfTheAirQualityIndex isEqualToString:@"Maroon"]) {
                        self.alertContentsTextView.text = @"Maroon - Hazardous.Health Warnings of emergency conditions.";
                    }
                    else if ([colourOfTheAirQualityIndex isEqualToString:@"Purple"]) {
                        self.alertContentsTextView.text = @"Purple - Very Unhealthy.Health Warnings of emergency conditions.";
                    }
                    else if ([colourOfTheAirQualityIndex isEqualToString:@"Orange"]) {
                        self.alertContentsTextView.text = @"Orange - Unhealthy for Sensitive Groups.Members of sensitive groups may experience healt effects.";
                    }
					[self.airQualityAlertsActivityIndicator stopAnimating];
					self.airQualityAlertsActivityIndicator.hidden = YES;
                }

                
            }
        });
    });
    
    dispatch_release(queue);
}
#pragma colour based on AQI value

-(NSString *)colourOfTheAQI:(NSInteger)AQIValue
{
    NSString *colourOfTheAirQualityIndex;
    if (AQIValue < 51) {
        colourOfTheAirQualityIndex = @"Green";
    }
    else if((AQIValue > 50)&&(AQIValue < 101))
    {
        colourOfTheAirQualityIndex = @"Yellow";
    }
    else if((AQIValue > 100)&&(AQIValue < 151))
    {
        colourOfTheAirQualityIndex = @"Orange";
    }
    else if((AQIValue > 150)&&(AQIValue < 201))
    {
        colourOfTheAirQualityIndex = @"Red";
    }
    else if((AQIValue > 200)&&(AQIValue < 301))
    {
        colourOfTheAirQualityIndex = @"Purple";
    }
    else if((AQIValue > 300)&&(AQIValue < 501))
    {
        colourOfTheAirQualityIndex = @"Maroon";
    }
    return colourOfTheAirQualityIndex;
}



@end
