//
//  RDViewController.m
//  RedDeluxe
//
//  Created by test on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDViewController.h"

@implementation RDViewController
@synthesize checkAQI;
@synthesize currentParticlePollutionButton;
@synthesize currentOzoneButton;
@synthesize todaysForecastParticlePollutionButton;
@synthesize todaysForecastOzoneButton;
@synthesize tomorrowsForecastParticlePollutionButton;
@synthesize tomorrowsForecastOzoneButton;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.currentParticlePollutionButton.hidden = YES;
    //self.currentOzoneButton.hidden = YES;
    self.todaysForecastOzoneButton.hidden = YES;
    self.todaysForecastParticlePollutionButton.hidden = YES;
    self.tomorrowsForecastOzoneButton.hidden = YES;
    self.tomorrowsForecastParticlePollutionButton.hidden = YES;
    dispatch_queue_t queue = dispatch_queue_create("FetchingObservedXML", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{ 

        NSURL *url = [[NSURL alloc] initWithString:@"http://ws1.airnowgateway.org/GatewayWebServiceREST/Gateway.svc/observedbyzipcode?zipcode=94954&format=xml&key=5D38E681-0393-4FF5-8639-A31E46167B46"];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        xmlParser.delegate = self;
        //Start parsing the XML file.
        
        BOOL successInParsingTheXMLDocument = [xmlParser parse];
        
        if(successInParsingTheXMLDocument)
            NSLog(@"No Errors");
        else
        {
            UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Unable to retrieve data.An Internet Connection is required." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Learn More", nil];
            [noInternetConnectionAlert show];
        }
        dispatch_async(main, ^{
            
        });
    });
    
    dispatch_release(queue);
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
  if([elementName isEqualToString:@"AQI"]) {
      checkAQI = YES;
    }
    else
    {
        checkAQI = NO;
    }
    
    NSLog(@"Processing Element: %@", elementName);
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (checkAQI) {
        int currentValue = [string integerValue];
        NSLog(@"%d",currentValue);
    }
    NSLog(@"In found");
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"ObsByZipList"])
		return;	
}

- (void)viewDidUnload
{
    [self setCurrentOzoneButton:nil];
    [self setTodaysForecastParticlePollutionButton:nil];
    [self setTodaysForecastOzoneButton:nil];
    [self setTomorrowsForecastParticlePollutionButton:nil];
    [self setTomorrowsForecastOzoneButton:nil];
    [self setCurrentParticlePollutionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AirQualityAlerts"]) {
        NSLog(@"segue");
      [segue destinationViewController];
    }
}

- (IBAction)showAirQualityAlerts:(id)sender {
    [self performSegueWithIdentifier:@"AirQualityAlerts" sender:self];
}

@end
