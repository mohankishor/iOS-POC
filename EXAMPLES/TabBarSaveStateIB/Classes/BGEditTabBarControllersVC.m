//
//  BGEditTabBarControllersVC.m
//  TabBarSaveStateIB
//
//  Created by Sambasivarao D on 29/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BGEditTabBarControllersVC.h"


@implementation BGEditTabBarControllersVC

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	scrollView.bouncesZoom = NO;
	scrollView.delegate = self;
	scrollView.clipsToBounds = YES;
	scrollView.contentSize = CGSizeMake(320, 1000);
	
//	mainView.frame=CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
//	button.frame=CGRectMake(120, mainView.bounds.size.height-100, 100, 30);
//	[mainView addSubview:button];
	
	
	[self addControllersImagesOnView];
	
}
-(void) addControllersImagesOnView
{
	
	int i=0,i1=0; 
	int n=40;
	
	while(i<n)
	{
		int yy = 3 +i1*74;
		int j=0;
		for(j=0; j<4;j++)
		{
			if (i>=n) break;

			CGRect rectView = CGRectMake(10+80*j ,yy,50,50);
			UIView *vv = [[UIView alloc]initWithFrame:rectView];
			[vv setBackgroundColor:[UIColor grayColor]];
			
			CGRect buttonRect = CGRectMake(10, 5, 30, 30);
			UIButton *button=[[UIButton alloc] initWithFrame:buttonRect];
			UIImage *buttonImageNormal=[UIImage imageNamed:@"logo.png"];
			[button setBackgroundImage:buttonImageNormal	forState:UIControlStateNormal];
			[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventAllEvents];
			[vv addSubview:button];
 			//[button release];
			
			UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0,48, 50, 12)] autorelease];
			label.text =[NSString stringWithFormat:@"tab %d",i+1];
			label.textColor = [UIColor blackColor];
			label.backgroundColor = [UIColor clearColor];
			label.textAlignment = UITextAlignmentCenter;
			label.font = [UIFont fontWithName:@"ArialMT" size:12]; 
			[vv addSubview:label];
			//[label release];
			
			
			UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:withTag:)];
			panGesture.minimumNumberOfTouches = 1;
			panGesture.maximumNumberOfTouches = 1;
			[vv addGestureRecognizer:panGesture];
			[panGesture release];
			[mainView addSubview:vv];
			//[vv release];
			
			i++;

		}
		i1 = i1+1;
	}
}

-(void) buttonClicked:(id)sender{
	UIButton *button=(UIButton *)sender;
	previousX=button.bounds.origin.x;
	previousY=button.bounds.origin.y;
	NSLog(@"previous (x,y)-->(%f, %f)",previousX,previousY);
}

-(void)handlePan: (UIPanGestureRecognizer*)gestureRecognizer withTag:(int)tag
{
	
	UIView *buttonView = (UIView *)gestureRecognizer.view;

	CGPoint translation = [gestureRecognizer translationInView:buttonView];
	
	buttonView.center = CGPointMake(buttonView.center.x + translation.x, 
									buttonView.center.y + translation.y);
	
	// reset translation
	[gestureRecognizer setTranslation:CGPointZero inView:buttonView];
	
	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan){

		NSLog(@"at begining (x, y ) --> ( %f, %f)",buttonView.center.x,buttonView.center.y);
		previousX=buttonView.center.x;
		previousY=buttonView.center.y;
	}
	if ([gestureRecognizer state] == UIGestureRecognizerStateEnded){
		NSLog(@"at ending (x, y ) --> ( %f, %f)",buttonView.center.x,buttonView.center.y);
		//if (buttonView.center.y>440) {
//			
//		}else
		if (previousX!=buttonView.center.x && previousY!=buttonView.center.y) {
			buttonView.center = CGPointMake(previousX,previousY);	
		}

	}else {
		//NSLog(@"in between (x, y ) --> ( %f, %f)",buttonView.center.x,buttonView.center.y);
	}


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
}


@end
