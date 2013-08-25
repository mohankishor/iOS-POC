//
//  Created by Björn Sållarp on 2009-07-17.
//  NO Copyright 2009 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "DetailsViewController.h"


@implementation DetailsViewController
@synthesize titleLabel, descriptionLabel, inhabitantsLabel, descriptionScrollView, emailButton, phoneButton;
@synthesize cityName, inhabitants, description, email, phone;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self.titleLabel setText:self.title];
	[self.inhabitantsLabel setText:[NSString stringWithFormat:@"Inhabitants: %@", inhabitants]];
	[self.descriptionLabel setText:self.description];
	
	// Calculate the height of the description text. Uses code described here: http://blog.sallarp.com/iphone-uilabel-multiline-dynamic-height/
	float textHeight = [MLUtils calculateHeightOfTextFromWidth:self.description : descriptionLabel.font :descriptionLabel.frame.size.width :UILineBreakModeWordWrap];
	
	CGRect frame = descriptionLabel.frame;
	frame.size.height = textHeight;
	descriptionLabel.frame = frame;
	
	CGSize contentSize = descriptionScrollView.contentSize;
	contentSize.height = textHeight;
	descriptionScrollView.contentSize = contentSize;
	
	
	emailButton.hidden = (self.email == nil || [self.email isEqualToString:@""] == YES);
	phoneButton.hidden = (self.phone == nil || [self.phone isEqualToString:@""] == YES);
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(IBAction) phoneButtonClicked:(id)sender
{
	NSString *callPhone = [NSString stringWithFormat:@"tel:%@",phone];
	NSLog(@"Calling: %@", callPhone);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}
-(IBAction) emailButtonClicked:(id)sender
{
	[self openInAppEmail:[NSArray arrayWithObject:email] mailSubject:@"" mailBody:@"" isHtml:YES];
}

- (void)openInAppEmail:(NSArray*)recipients
		   mailSubject:(NSString*)mailSubject
			  mailBody:(NSString*)mailBody
				isHtml:(BOOL)isHtml
{
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setToRecipients:recipients];
	[controller setSubject:mailSubject];
	[controller setMessageBody:mailBody isHTML:isHtml];
	[self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[titleLabel release];
	[descriptionLabel release];
	[inhabitantsLabel release];
	[descriptionScrollView release];
	[phoneButton release];
	[emailButton release];
	[cityName release];
	[inhabitants release];
	[description release];
    [super dealloc];
}


@end
