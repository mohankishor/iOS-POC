//
//  OpenMailAppDelegate.m
//  OpenMail
//
//  Created by Brandon Trebitowski on 2/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "OpenMailAppDelegate.h"

@implementation OpenMailAppDelegate

@synthesize window,txtTo,txtSubject,txtBody,btnSend;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == txtTo) {
		[txtSubject becomeFirstResponder];
	} else {
		[txtTo resignFirstResponder];
		[txtSubject resignFirstResponder];
	}
	return YES;
}

-(IBAction) send:(id) sender {
	[self sendEmailTo:[txtTo text] withSubject:[txtSubject text] withBody:[txtBody text]];
}

- (void) sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body {
	NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
							[to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[body  stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
