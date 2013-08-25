//
//  NTViewController.m
//  NotificationTry
//
//  Created by test on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NTViewController.h"

@implementation NTViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Notification";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotification:) name:@"Notification" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (IBAction)notifyButtonPressed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification" object:self];
}
-(void)handleNotification:(NSNotification *)pNotification
{
    NSLog(@"#1 received message = %@",(NSString*)[pNotification object]);
    UIAlertView *notifyAlert = [[UIAlertView alloc]initWithTitle:@"Notification" message:@"You have a notification" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [notifyAlert show];                         
}

@end
