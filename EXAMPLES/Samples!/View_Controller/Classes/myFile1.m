    //
//  myFile1.m
//  View_Controller
//
//  Created by Anand Kumar Y N on 11/08/10.
//  Copyright 2010 Sourcebits Technologies. All rights reserved.
//

#import "myFile1.h"


@implementation myFile1

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	[mainView setBackgroundColor:[UIColor whiteColor]];
	self.view = mainView;
	[mainView release];
	
	//NSLog(@"2 =%d",mIndexNumber);
	
	//UIImageView *vImage=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
	 UIImageView *vImage=[[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 200, 200)];
	switch(mIndexNumber)
	{
		case 0:self.title=@"Red Apple";
				[vImage setImage:[UIImage imageNamed:@"Red Apple.gif"]];
			break;
		case 1:self.title=@"Green Apple";
			[vImage setImage:[UIImage imageNamed:@"Green Apple.gif"]];
			break;
		case 2:self.title=@"Pear";
			[vImage setImage:[UIImage imageNamed:@"Pear.gif"]];
			break;
		case 3:self.title=@"Orange";
			[vImage setImage:[UIImage imageNamed:@"Orange.gif"]];
			break;
		case 4:self.title=@"Strawberry";
			[vImage setImage:[UIImage imageNamed:@"Strawberry.gif"]];
			break;
		case 5:self.title=@"Sunflower";
			[vImage setImage:[UIImage imageNamed:@"Sunflower.gif"]];
			break;
		default:
			break;
	}
			
	 [self.view addSubview:vImage];
	 [vImage release];
	  }

-(void)viewIndex:(NSInteger)inIndex
{//
//	UIImageView *vImage=[[UIImageView alloc]initWithFrame:CGRectMake(40, 100, 200, 200)];
//	[vImage setImage:[UIImage imageNamed:@"Sunflower.gif"]];
//	[self.view addSubview:vImage];
//	[vImage release];
	//NSLog(@"index Number %d",inIndex);
	mIndexNumber=inIndex;
	
}

	
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
}


@end
