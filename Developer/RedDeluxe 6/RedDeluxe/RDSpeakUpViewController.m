//
//  RDSpeakUpViewController.m
//  RedDeluxe
//
//  Created by Pradeep Rajkumar on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDSpeakUpViewController.h"

@implementation RDSpeakUpViewController
{
    CGPoint scrollViewCurrentOffset;
}
@synthesize messageField;
@synthesize contactCongressMenView;
@synthesize scrollView;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize emailField;
@synthesize homeAddressField;
@synthesize cityField;
@synthesize doneToolBar;
@synthesize stateField;
@synthesize zipCodeField;
@synthesize phoneNumberField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)animateView:(UIView*)textField up:(BOOL)up
{
    int count = 5;
    int movementDistance;
    if (count <= 5)
    {
        return;
    }
    else if (count == 6)
    {
        movementDistance = 213;
    }
    const float movementDuration = 0.28f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == messageField)
    {
        CGRect currentTextFieldBounds;
        CGPoint currentTextFieldBoundsOrigin;
        currentTextFieldBounds = [messageField bounds];
        currentTextFieldBounds = [messageField convertRect:currentTextFieldBounds toView:scrollView];
        currentTextFieldBoundsOrigin = currentTextFieldBounds.origin;
        currentTextFieldBoundsOrigin.x = 0;
        currentTextFieldBoundsOrigin.y -= 105;
        [scrollView setContentOffset:currentTextFieldBoundsOrigin animated:YES];
		[self.view bringSubviewToFront:doneToolBar];
		[doneToolBar setHidden:NO];

    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [messageField resignFirstResponder];
    [scrollView setContentOffset:scrollViewCurrentOffset animated:YES]; 
	[doneToolBar setHidden:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	NSLog(@"%f",scrollView.bounds.origin.y);
    if(textField == cityField || textField == stateField || textField == zipCodeField ||textField == phoneNumberField)
    {
        CGRect currentTextFieldBounds;
        CGPoint currentTextFieldBoundsOrigin;

        if(textField == cityField)
        {
            currentTextFieldBounds = [cityField bounds];
            currentTextFieldBounds = [cityField convertRect:currentTextFieldBounds toView:scrollView];
        }
    
        if(textField == stateField)
        {
            currentTextFieldBounds = [stateField bounds];
            currentTextFieldBounds = [stateField convertRect:currentTextFieldBounds toView:scrollView];
//			NSLog(@"state: %f",currentTextFieldBounds.origin.y);
//			currentTextFieldBoundsOrigin = currentTextFieldBounds.origin;
//			currentTextFieldBoundsOrigin.x = 0;
//			currentTextFieldBoundsOrigin.y -= 90;
//			NSLog(@"currenttext: %f",currentTextFieldBounds.origin.y);
//			[scrollView setContentOffset:currentTextFieldBoundsOrigin animated:YES];  
//			return;
        }
        if(textField == zipCodeField)
        {
            currentTextFieldBounds = [zipCodeField bounds];
			//NSLog(@"state: %@",currentTextFieldBounds);
            currentTextFieldBounds = [zipCodeField convertRect:currentTextFieldBounds toView:scrollView];
//			NSLog(@"zip: %f",currentTextFieldBounds.origin.y);
        }

        if(textField == phoneNumberField)
        {
            currentTextFieldBounds = [phoneNumberField bounds];
            currentTextFieldBounds = [phoneNumberField convertRect:currentTextFieldBounds toView:scrollView];
        }
        currentTextFieldBoundsOrigin = currentTextFieldBounds.origin;
        currentTextFieldBoundsOrigin.x = 0;
		if(currentTextFieldBoundsOrigin.y > 135)
		{
			currentTextFieldBoundsOrigin.y -= 60;
		}
		else
		{
			currentTextFieldBoundsOrigin.y = 0;
		}
		NSLog(@"currenttext: %f",currentTextFieldBoundsOrigin.y);
        [scrollView setContentOffset:currentTextFieldBoundsOrigin animated:YES];  
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == firstNameField)
	{
		[firstNameField resignFirstResponder];
		[lastNameField becomeFirstResponder];
	}
	if(textField == lastNameField)
	{
		[lastNameField resignFirstResponder];
		[emailField becomeFirstResponder];
	}
	if(textField == emailField)
	{
		[emailField resignFirstResponder];
		[homeAddressField becomeFirstResponder];
	}
	if(textField == homeAddressField)
	{
		[homeAddressField resignFirstResponder];
		[cityField becomeFirstResponder];
	}
	if(textField == cityField)
	{
		[cityField resignFirstResponder];
		[stateField becomeFirstResponder];
	}
    
	if(textField == stateField)
	{
		[stateField resignFirstResponder];
		[zipCodeField becomeFirstResponder];
	}
	if(textField == zipCodeField)
	{
		[zipCodeField resignFirstResponder];
		[phoneNumberField becomeFirstResponder];
	}
	
	if(textField == phoneNumberField)
	{
		[phoneNumberField resignFirstResponder];
		[messageField becomeFirstResponder];
	}
	
    //[scrollView setContentOffset:scrollViewCurrentOffset animated:YES]; 
    
    return YES;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIImage *)makeImageOfSize:(CGSize)size withImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
    { 
        NSLog(@"could not scale image");
    }
    return newThumbnail;
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:208/255.0 green:26/255.0 blue:44/255.0 alpha:0.5];
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"city"]) {
        NSLog(@"City: %@",elementName);
    }
    else
    {
        NSLog(@"nothing comes as city");
    }
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"In found");
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"city"])
    {
        NSLog(@"Obtained the element");
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,25)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,25)];  
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];    
    titleLabel.text = @"Speak Up";
    [titleView addSubview:titleLabel];
    UIBarButtonItem *titleBarItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.rightBarButtonItem = titleBarItem; 
    [messageField setDelegate:(id)self];
    [firstNameField setDelegate:(id)self];
    [lastNameField setDelegate:(id)self];
    [emailField setDelegate:(id)self];
    [homeAddressField setDelegate:(id)self];
    [cityField setDelegate:(id)self];
    
    [stateField setDelegate:(id)self];
    [zipCodeField setDelegate:(id)self];
    [phoneNumberField setDelegate:(id)self];
    [messageField setDelegate:(id)self];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 280)];
    scrollViewCurrentOffset = scrollView.contentOffset;

	messageField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"480x800_Speak_Up_Message_Field.png"]];
    
}


- (void)viewDidUnload
{
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setEmailField:nil];
    [self setHomeAddressField:nil];
    [self setStateField:nil];
    [self setZipCodeField:nil];
    [self setPhoneNumberField:nil];
    [self setMessageField:nil];
    [self setCityField:nil];
    [self setContactCongressMenView:nil];
    [self setScrollView:nil];
	[self setDoneToolBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendMessage:(id)sender {
    [messageField resignFirstResponder];
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
    [emailField resignFirstResponder];
    [homeAddressField resignFirstResponder];
    [cityField resignFirstResponder];
    
    [stateField resignFirstResponder];
    [zipCodeField resignFirstResponder];
    [phoneNumberField resignFirstResponder]; 
    [scrollView setContentOffset:scrollViewCurrentOffset animated:YES]; 
    [self textViewDidEndEditing:messageField];
    //NSString *value = @"ConvioKey"; //Convio Key must be added here
    NSURL *url = [[NSURL alloc] initWithString:@"https://secure2.convio.net/organization/site/CRAdvocacyAPI?method=takeAction &api_key=value &v=value [ &auth=value ] [ &center_id=value ] [ &error_redirect=value ] [ &redirect=value ] [ &response_format=xml | json ] [ &sign_redirects=value ] [ &source=value ] [ &sso_auth_token=value ] [ &sub_source=value ] [ &success_redirect=value ] [ &suppress_response_codes=value ] &alert_id=value &alert_type=action | call | lte [ &anonymous=value ] [ &body=value ] [ &called=value ] [ &cc=value ] [ &city=value ] [ &contact_name=value ] [ &contact_position=value ] [ &country=value ] [ &email=value ] [ &first_name=value ] [ &last_name=value ] [ &note=value ] [ &opt_in=value ] [ &phone=value ] [ &preview=true ] [ &recipient=all | internet | fax | print | call ] [ &reply=value ] [ &state=value ] [ &street1=value ] [ &street2=value ] [ &subject=value ] [ &survey=value ] [ &title=value ] [ &zip=value ]"];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    xmlParser.delegate = self;
    
    BOOL successInParsingTheXMLDocument = [xmlParser parse];
    
    if(successInParsingTheXMLDocument)
        NSLog(@"No Errors");
    else
    {
        UIAlertView *noInternetAlert = [[UIAlertView alloc] initWithTitle:@"Not allowed to Post" message:@"Sorry you are not allowed to submit your voice to the Congressmen since you are not signed in to the Convio" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noInternetAlert show];
    }

}
- (IBAction)giveManyCongressManAlert:(id)sender {
    UIAlertView *multipleCongressMen = [[UIAlertView alloc] initWithTitle:nil message:@"Some zip codes have multiple members of congress. Your address will determine which member of congress your message goes to." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [multipleCongressMen show];
}
- (IBAction)donePressed:(id)sender {
	[messageField resignFirstResponder];
	[doneToolBar setHidden:YES];
	[scrollView setContentOffset:scrollViewCurrentOffset animated:YES]; 
}
@end
