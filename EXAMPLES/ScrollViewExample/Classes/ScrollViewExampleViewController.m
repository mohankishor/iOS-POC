//
//  ScrollViewExampleViewController.m
//  ScrollViewExample
//
//  Created by Chakra on 31/03/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#define SCROLLVIEW_CONTENT_HEIGHT 460
#define SCROLLVIEW_CONTENT_WIDTH  320

#import "ScrollViewExampleViewController.h"

@implementation ScrollViewExampleViewController

@synthesize scrollview, textField1,textField2;



- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
		
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self
	 selector:@selector
	 (keyboardDidShow:) 
	 name: UIKeyboardDidShowNotification
	 object:nil];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self 
	 selector:@selector
	 (keyboardDidHide:) name:
	 UIKeyboardDidHideNotification
	 object:nil];
	
	scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH,
										SCROLLVIEW_CONTENT_HEIGHT);
	

	displayKeyboard = NO;
}

-(void) viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self];
}

-(void) keyboardDidShow: (NSNotification *)notif {
		if (displayKeyboard) {
			return;
	}
	
	
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	offset = scrollview.contentOffset;
	
		CGRect viewFrame = scrollview.frame;
	viewFrame.size.height -= keyboardSize.height;
	scrollview.frame = viewFrame;
	
	CGRect textFieldRect = [Field frame];
	textFieldRect.origin.y += 10;
	[scrollview scrollRectToVisible: textFieldRect animated:YES];
	displayKeyboard = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
	if (!displayKeyboard) {
		return; 
	}
	
	scrollview.frame = CGRectMake(0, 0, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
	
	scrollview.contentOffset =offset;
	
	 displayKeyboard = NO;
	
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
	 Field = textField;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}



- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
	
	
}

- (void)viewDidUnload {
	}


- (void)dealloc {
    [super dealloc];
}

@end
