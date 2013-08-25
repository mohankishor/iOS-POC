//
//  ToolBarSampleViewController.m
//  ToolBarSample
//
//  Created by Reshma Nayak on 27/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "ToolBarSampleViewController.h"

@implementation ToolBarSampleViewController




// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	
	//create toolbar
	
		toolbar=[[UIToolbar alloc]init];
	//toolbar=[UIToolbar new];
	toolbar.barStyle=UIBarStyleDefault;
		//[toolbar sizeToFit];
	toolbar.frame=CGRectMake(0,410,320,50);
 
	
	
	
	//add buttons
	UIBarButtonItem * button1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector (pressButton1:)];
	UIBarButtonItem *button2= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector (pressButton2:)];
	UIBarButtonItem *button3= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector (pressButton3:)];
 
	NSArray *array=[NSArray arrayWithObjects:button1,button2,button3,nil];
 
    [toolbar setItems:array animated:NO];	
	[self.view addSubview:toolbar]; 
}

-(void)pressButton1:(id)sender{
	
	//label.text=@"Add";
}
-(void)pressButton2:(id)sender{
	
	//label.text=@"Cancel";
}
-(void)pressButton3:(id)sender{
	
	//label.text=@"Save";
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
}


- (void)dealloc {
    [super dealloc];
	
	[toolbar release];
	[label release];
}

@end
