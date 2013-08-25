/*
 
 Copyright (c) 2010, Mobisoft Infotech
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are 
 permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of 
 conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation and/or 
 other materials provided with the distribution.
 
 Neither the name of Mobisoft Infotech nor the names of its contributors may be used to 
 endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS 
 OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
 OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 OF SUCH DAMAGE.
 
 */

#import "ScrollableViewController.h"


@implementation ScrollableViewController

@synthesize ctrlKeyboardFocusFieldM;
@synthesize svScrollViewM;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self registerForKeyboardNotifications];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.ctrlKeyboardFocusFieldM = nil;
	self.svScrollViewM = nil;
}


- (void)dealloc {
	[ctrlKeyboardFocusFieldM release];
	[svScrollViewM release];
    [super dealloc];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (bKeyboardShownM)
        return;
	
	NSDictionary* info = [aNotification userInfo];
	
	// Get the size of the keyboard.
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	// Resize the scroll view (which is the root view of the window)
	CGRect viewFrame = [self.svScrollViewM frame];
	viewFrame.size.height -= keyboardSize.height;
	self.svScrollViewM.frame = viewFrame;
	
	// Scroll the active text field into view.
	CGRect textFieldRect = [self.ctrlKeyboardFocusFieldM frame];
	[self.svScrollViewM scrollRectToVisible:textFieldRect animated:YES];
		
    bKeyboardShownM = YES;
	
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
	
	
	// Get the size of the keyboard.
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	// Reset the height of the scroll view to its original value
	CGRect viewFrame = [self.svScrollViewM frame];
	viewFrame.size.height += keyboardSize.height;
	self.svScrollViewM.frame = viewFrame;
	
	
    bKeyboardShownM = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.ctrlKeyboardFocusFieldM = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.ctrlKeyboardFocusFieldM = nil;
}

- (void) registerForEditingEvents:(UIControl *) aControl {
	[aControl addTarget:self	action:@selector(textFieldDidBeginEditing:) 
								forControlEvents:UIControlEventEditingDidBegin];
	[aControl addTarget:self	action:@selector(textFieldDidEndEditing:) 
								forControlEvents:UIControlEventEditingDidEnd];
} 

@end
