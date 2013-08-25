//
//  QTViewController.m
//  Projtry
//
//  Created by test on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QTViewController.h"

@implementation QTViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Try";
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)tap:(id)sender {
    [self showLoadingView];
}
-(void)showLoadingView
{
	CGRect transparentViewFrame = CGRectMake(0.0, 0.0,310.0,460.0);
	UIView *transparentView = [[UIView alloc] initWithFrame:transparentViewFrame];
	transparentView.backgroundColor = [UIColor lightGrayColor];
	transparentView.alpha = 0.9;
    
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = transparentView.center;
	[spinner startAnimating];
    
	UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 30)];
	messageLabel.textAlignment = UITextAlignmentCenter;
	messageLabel.text = @"please wait...";
    
	[transparentView addSubview:spinner];
	[transparentView addSubview:messageLabel];
    
	[self.view addSubview:transparentView];
}
@end
