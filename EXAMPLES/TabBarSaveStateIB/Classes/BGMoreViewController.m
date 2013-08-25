//
//  BGMoreViewController.m
//  TabBarSaveStateIB
//
//  Created by Sambasivarao D on 29/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BGMoreViewController.h"


@implementation BGMoreViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title=@"More";
    }
    return self;
}

-(IBAction) editButtonClicked
{
	
	NSLog(@"editButtonClicked");

	editViewController=[[BGEditTabBarControllersVC alloc] initWithNibName:@"BGEditTabBarControllersVC" bundle:nil];
	[self.view addSubview:editViewController.view];
	self.navigationItem.leftBarButtonItem=nil;
	self.navigationItem.rightBarButtonItem=doneItem;
	
//	UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:editViewController1];
//	[self presentModalViewController:nav animated:YES];
//	[editViewController1 release];
//	[nav release];
}

-(IBAction) doneButtonClicked
{
	[editViewController.view removeFromSuperview];
	self.navigationItem.leftBarButtonItem=editItem;
	self.navigationItem.rightBarButtonItem=nil;

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[editViewController release];
}


@end
