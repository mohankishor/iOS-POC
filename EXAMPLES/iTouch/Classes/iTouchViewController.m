//
//  iTouchViewController.m
//  iTouch
//
//  Created by Anand Kumar Y N on 19/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "iTouchViewController.h"

@implementation iTouchViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	mainView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
	mainView.backgroundColor=[UIColor grayColor];
	self.view=mainView;
	[mainView release];
	
	subView=[[UIView alloc]initWithFrame:CGRectMake(60, 50, 100, 150)];
	subView.backgroundColor=[UIColor redColor];
	[self.view addSubview:subView];
	[subView release];
	//
	subView1=[[UIView alloc]initWithFrame:CGRectMake(60, 50, 100, 150)];
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"images.jpg"]];
	//subView1.backgroundColor=[UIColor blueColor];
	subView1.backgroundColor=background;
	
	[self.view addSubview:subView1];
	[background release];
		[subView1 release];
	
	
	
	subView2=[[UIView alloc]initWithFrame:CGRectMake(170, 50, 100, 150)];
	subView2.backgroundColor=[UIColor redColor];
	[mainView addSubview:subView2];
	[subView2 release];
	//
	subView3=[[UIView alloc]initWithFrame:CGRectMake(170, 50, 100, 150)];
	UIColor *background1 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"images.jpg"]];
	//subView1.backgroundColor=[UIColor blueColor];
	subView3.backgroundColor=background1;
	[self.view addSubview:subView3];
	[subView3 release];
	
	//********************************************
	
	//myView=[[UIView alloc]initWithFrame:CGRectMake(60, 210, 100, 150)];
//	myView.backgroundColor=[UIColor redColor];
//	[self.view addSubview:myView];
//	[myView release];
//	//
//	myView1=[[UIView alloc]initWithFrame:CGRectMake(60, 210, 100, 150)];
//	UIColor *background2 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Clown_Fish1.jpg"]];
//	//subView1.backgroundColor=[UIColor blueColor];
//	myView1.backgroundColor=background2;
//	
//	[self.view addSubview:myView1];
//	[background2 release];
//	[myView1 release];
//	
//	
//	
//	myView2=[[UIView alloc]initWithFrame:CGRectMake(170, 210, 100, 150)];
//	myView2.backgroundColor=[UIColor redColor];
//	[mainView addSubview:myView2];
//	[myView2 release];
//	//
//	myView3=[[UIView alloc]initWithFrame:CGRectMake(170, 210, 100, 150)];
//	UIColor *background3 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Clown_Fish1.jpg"]];
//	//subView1.backgroundColor=[UIColor blueColor];
//	myView3.backgroundColor=background3;
//	
//	
//	[mainView addSubview:myView3];
//	[background3 release];
//	[myView3 release];
//	
//[subView1 setHidden:YES];
	//UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"anImage.png"]];
//		self.view.backgroundColor = background;
//		[background release];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	
	UITouch *touch = [[event allTouches] anyObject];
	 if((CGRectContainsPoint([subView frame], [touch locationInView:self.view])) |(CGRectContainsPoint([subView1 frame], [touch locationInView:self.view])))
	 {
		 
	if([subView1 isHidden])
	{
		[subView1 setHidden:NO];
		[subView setHidden:YES];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:subView1 cache:YES];
	}
	else{
		[subView1 setHidden:YES];
		[subView setHidden:NO];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:subView cache:YES];
	}
	 }
		else
		{
	if([subView3 isHidden]){
		[subView3 setHidden:NO];
		[subView2 setHidden:YES];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:subView3 cache:YES];
	}
	else{
		[subView3 setHidden:YES];
		[subView2 setHidden:NO];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:subView2 cache:YES];
	}
			
		}
	//[UIView setAnimationDelay:2];
	if(([subView isHidden] & [subView2 isHidden])|([subView1 isHidden] & [subView3 isHidden]))
	{
		NSLog(@"Matching Pair");
		alert =	[[UIAlertView alloc] initWithTitle: @"Alert Message"
										   message: @"You Have One Mathcing Pair"
										  delegate: self
								 cancelButtonTitle: @"OK"
								 otherButtonTitles: nil];
		[alert show];
		[alert release];
		
	}
	[UIView commitAnimations];
		
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	UITouch *touch=[touches anyObject];
//	CGPoint point = [touch locationInView:self.view];
//	
//	if(CGRectContainsPoint(self.view.frame, point))
//	{
//		[subView setFrame:CGRectMake(point.x  , point.y, subView.frame.size.width, subView.frame.size.height)];
//	}
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[subView release];
    [super dealloc];
}

@end
