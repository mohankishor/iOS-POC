//
//  GSViewController.m
//  GraphicStructures
//
//  Created by test on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSViewController.h"

@implementation GSViewController

@synthesize length = _length;

@synthesize width = _width;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _length = CGRectGetHeight(self.view.bounds);
    _width = CGRectGetWidth(self.view.bounds);
    Rectangle *drawRectangle = [[Rectangle alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,480.0)];
    drawRectangle.length = 100.0;
    drawRectangle.width = 200.0;
    [self.view addSubview:drawRectangle];
    [drawRectangle setNeedsDisplay];
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

@end
